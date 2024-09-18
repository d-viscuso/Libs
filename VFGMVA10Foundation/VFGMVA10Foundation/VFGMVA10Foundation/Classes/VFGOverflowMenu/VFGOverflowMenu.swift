//
//  VFGOverflowMenu.swift
//  VFGMVA10Foundation
//
//  Created by Fafoutis, Athinodoros, Vodafone Greece on 27/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// A delegate protocol that manages user interactions with the overflow menu,
/// including open and close actions.
public protocol VFGOverflowMenuDelegate: AnyObject {
    func didSelect(selectedItem: VFGOverflowMenuItem, index: Int)
    // Optional methods by adding an empty body in extension
    /// A method that gets invoked before the overflow menu opens.
    func willOpen()
    /// A method that gets invoked once the overflow menu is opened.
    func didOpen()
    /// A method that gets invoked before the overflow menu closes.
    func willClose()
    /// A method that gets invoked once the overflow menu is closed.
    func didClose()
}

public extension VFGOverflowMenuDelegate {
    func willOpen() {}
    func didOpen() {}
    func willClose() {}
    func didClose() {}
}

/// OverflowMenu is a menu that can be user under or above every uiElement and can only be added through code
public class VFGOverflowMenu: UIView {
    public weak var overflowMenuDelegate: VFGOverflowMenuDelegate?
    public var isOpened = false
    public var isShownAboveTriggerView = false
    var isForcedToAppearBelow: Bool?
    var isHashingTextEnabled: Bool?
    var tableView: UITableView
    var shadow: UIView
    var selectedIndex: Int?
    var pointToParent = CGPoint(x: 0, y: 0)
    var keyboardHeight: CGFloat = 0
    var shouldOpen = false

    let triggerView: UIView
    let baseView: UIView?
    let overflowMenuDatasource: [VFGOverflowMenuItem]
    var filteredOverflowMenuDatasource: [VFGOverflowMenuItem]
    let rowEstimatedHeight: CGFloat
    let maxTableHeight: CGFloat
    let hideOptionsWhenSelect: Bool
    let rowBackgroundColor = UIColor.VFGOverflowMenuBackground
    let selectedRowBackgroundColor = UIColor.VFGOverflowMenuSelectedCell
    let accessibilityModel: VFGOverflowMenuAccessibilityModel

    /// OverflowMenu is a menu that can be user under or above every uiElement
    /// - Parameters:
    ///   - triggerView: The OverflowMenu will be shown under or above this view and it will have the same width
    ///   - baseView: The view in witch the OverflowMenu will be added as a subview. Used to calculate if the menu will be shown bellow or above the triggerView
    ///   - overflowMenuDatasource: A list with VFGOverflowMenuItem that will be shown within the OverflowMenu
    ///   - rowEstimatedHeight: The estimated row height
    ///   - maxTableHeight: The maximum height of the OverflowMenu. If the height is lower than this number then the height is calculated automatically
    ///   - isForcedToAppearBelow: Force menu to shown from below what ever the parent view location, its false by default
    ///   - isHashingTextEnabled: enable showing text in drop down secured with Asterisk, its false by default
    ///   - hideOptionsWhenSelect: Whether or not should close the OverflowMenu when an item is selected
    ///   - accessibilityModel: Provide this model if you want leading image, primary and secondary texts to have a custom accessibilityIdentifier
    public init(
        triggerView: UIView,
        baseView: UIView?,
        overflowMenuDatasource: [VFGOverflowMenuItem],
        rowEstimatedHeight: CGFloat = 48,
        maxTableHeight: CGFloat = 150,
        hideOptionsWhenSelect: Bool = true,
        isForcedToAppearBelow: Bool? = nil,
        isHashingTextEnabled: Bool? = nil,
        accessibilityModel: VFGOverflowMenuAccessibilityModel = VFGOverflowMenuAccessibilityModel()
    ) {
        self.triggerView = triggerView
        self.baseView = baseView
        self.overflowMenuDatasource = overflowMenuDatasource
        self.filteredOverflowMenuDatasource = overflowMenuDatasource
        self.rowEstimatedHeight = rowEstimatedHeight
        self.maxTableHeight = min(maxTableHeight, CGFloat(overflowMenuDatasource.count) * rowEstimatedHeight)
        self.hideOptionsWhenSelect = hideOptionsWhenSelect
        self.accessibilityModel = accessibilityModel
        self.isForcedToAppearBelow = isForcedToAppearBelow
        self.isHashingTextEnabled = isHashingTextEnabled
        tableView = UITableView()
        shadow = UIView()
        super.init(frame: .zero)
        observeKeyboard()
    }

    required init?(coder: NSCoder) {
        // init(coder:) has not been implemented
        return nil
    }
}

extension VFGOverflowMenu {
    /// Show the OverflowMenu
    public func open() {
        guard !isOpened else {
            return
        }
        isOpened = true

        overflowMenuDelegate?.willOpen()

        pointToParent = getConvertedPoint(baseView: baseView)

        setupTable(
            with: CGRect(
                x: pointToParent.x,
                y: pointToParent.y + triggerView.frame.height,
                width: triggerView.frame.width,
                height: triggerView.frame.height
            ),
            in: baseView
        )
        let estimatedTableHeight = min(
            maxTableHeight,
            CGFloat(filteredOverflowMenuDatasource.count) * rowEstimatedHeight)
        var height = (baseView?.frame.height ?? 0) - (pointToParent.y + triggerView.frame.height + 5)
        height -= keyboardHeight
        if let isForcedToAppearBelow = isForcedToAppearBelow {
            isShownAboveTriggerView = !isForcedToAppearBelow
        } else {
            isShownAboveTriggerView = height < estimatedTableHeight
        }
        let y = isShownAboveTriggerView
        ? pointToParent.y - estimatedTableHeight
            : pointToParent.y + triggerView.frame.height + 5

        showTable(
            with: CGRect(
            x: pointToParent.x,
            y: y,
            width: triggerView.frame.width,
            height: estimatedTableHeight
        ))
        tableView.reloadData()
    }

    /// Hide the OverflowMenu
    public func close() {
        guard isOpened else {
            return
        }
        isOpened = false

        overflowMenuDelegate?.willClose()
        shadow.removeFromSuperview()
        UIView.animate(
            withDuration: 0.25,
            animations: {
                self.tableView.frame = CGRect(
                    x: self.pointToParent.x,
                    y: self.pointToParent.y + self.triggerView.frame.height,
                    width: self.triggerView.frame.width,
                    height: 0)
                self.shadow.alpha = 0
                self.shadow.frame = self.tableView.frame
            },
            completion: { _ in
                self.tableView.removeFromSuperview()
                self.overflowMenuDelegate?.didClose()
            })
    }

    /// Shows or Hides the OverflowMenu
    public func toggle() {
        if isOpened {
            close()
        } else {
            open()
        }
    }

    func updateDataSource(text: String) {
        filterOverFlowMenuItems(text: text)
        let estimatedTableHeight = min(
            maxTableHeight,
            CGFloat(filteredOverflowMenuDatasource.count) * rowEstimatedHeight)
        tableView.frame = CGRect(
            x: tableView.frame.minX,
            y: tableView.frame.minY,
            width: tableView.frame.width,
            height: estimatedTableHeight)
        shadow.frame = tableView.frame
        shadow.configureShadow(shouldRasterize: true)
        tableView.reloadData()
    }

    func filterOverFlowMenuItems(text: String) {
        if text.isEmpty {
            filteredOverflowMenuDatasource = overflowMenuDatasource
        }
        filteredOverflowMenuDatasource = overflowMenuDatasource.filter { item  in
            item.primaryText.lowercased().hasPrefix(text.lowercased())
        }
    }

    func checkShouldOpen() {
        if shouldOpen {
            open()
        }
    }

    /// Check and return if a text is exists as primary text in any of the datasource items
    /// - Parameter primaryText: The text for the search
    /// - Returns: Whether or not the primary texts exists as primary text in any of the datasource items
    public func containsOption(with primaryText: String) -> Bool {
        return filteredOverflowMenuDatasource.contains {
            $0.primaryText == primaryText
        }
    }

    private func getConvertedPoint(baseView: UIView?) -> CGPoint {
        var convertedPoint = triggerView.frame.origin
        guard var superView = triggerView.superview else { return convertedPoint }

        while superView != baseView {
            convertedPoint = superView.convert(convertedPoint, to: superView.superview)
            guard let superviewSuperview = superView.superview else { break }
            superView = superviewSuperview
        }
        return superView.convert(convertedPoint, to: baseView)
    }

    private func setupTable(with frame: CGRect, in view: UIView?) {
        tableView.frame = frame

        tableView.register(VFGOverflowMenuTableViewCell.self, forCellReuseIdentifier: "VFGOverflowMenuTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 48
        tableView.separatorColor = .clear

        shadow = UIView(frame: tableView.frame)
        shadow.backgroundColor = .clear
        view?.addSubview(shadow)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        tableView.alpha = 0
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 6.0
        tableView.backgroundColor = rowBackgroundColor
        view?.addSubview(tableView)
    }

    private func showTable(with frame: CGRect) {
        UIView.animate(
            withDuration: 0.25,
            animations: {
                self.tableView.frame = frame
                self.tableView.alpha = 1
                self.shadow.frame = self.tableView.frame
            },
            completion: { _ in
                self.layoutIfNeeded()
                self.shadow.configureShadow(shouldRasterize: true)
                self.overflowMenuDelegate?.didOpen()
            }
        )
    }
}

extension VFGOverflowMenu: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOverflowMenuDatasource.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = VFGOverflowMenuTableViewCell(
            with: filteredOverflowMenuDatasource[indexPath.row],
            shouldHideSeparator: indexPath.row == filteredOverflowMenuDatasource.count - 1,
            isHashingTextEnabled: isHashingTextEnabled ?? false,
            isSelected: indexPath.row == selectedIndex
        )

        return cell
    }
}

extension VFGOverflowMenu: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let selectedItem = filteredOverflowMenuDatasource[indexPath.row]
        tableView.cellForRow(at: indexPath)?.alpha = 0
        UIView.animate(
            withDuration: 0.15,
            animations: {
                tableView.cellForRow(at: indexPath)?.alpha = 1.0
                tableView.cellForRow(at: indexPath)?.backgroundColor = self.rowBackgroundColor
            },
            completion: { _ in
                if self.hideOptionsWhenSelect {
                    self.close()
                }
                let index = self.overflowMenuDatasource.firstIndex {
                    $0 == selectedItem
                }
                self.overflowMenuDelegate?.didSelect(selectedItem: selectedItem, index: index ?? indexPath.row)
            }
        )
    }
}

extension VFGOverflowMenu {
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(whenKeyboardOpens),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(whenKeyboardCloses),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    @objc func whenKeyboardOpens (notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        keyboardHeight = keyboardFrame?.height ?? 0
        checkShouldOpen()
    }

    @objc func whenKeyboardCloses() {
        keyboardHeight = 0
    }
}
