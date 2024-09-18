//
//  VFGDropdown.swift
//  VFGMVA10Foundation
//
//  Created by Fafoutis, Athinodoros, Vodafone Greece on 25/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// A delegate protocol manages user interactions with the drop down and its life cycle
public protocol VFGDropdownDelegate: AnyObject {
    /// A method invoked after select the item from drop down at the specified index.
    func didSelect(selectedItem: VFGOverflowMenuItem, index: Int)
    // Optional
    /// A method invoked when the drop down is about to open
    func willOpen()
    /// A method invoked after the drop down opened
    func didOpen()
    /// A method invoked when the drop down is about to close
    func willClose()
    /// A method invoked after the drop down closed
    func didClose()
}

public extension VFGDropdownDelegate {
    func willOpen() {}
    func didOpen() {}
    func willClose() {}
    func didClose() {}
}

/// VFGDropdown is an overflow menu that is placed under a VFGTextField and can be added both though code and UI
public class VFGDropdown: VFGTextField {
    public weak var dropdownDelegate: VFGDropdownDelegate?
    var overflowMenu: VFGOverflowMenu
    public var isMenuOpened = false {
        didSet {
            if isMenuOpened {
                setRightButtonAccessibilityHint(with: "Press to hide drop down menu")
            } else {
                setRightButtonAccessibilityHint(with: "Press to show drop down menu")
            }
            accessibilityCustomActions = [rightButtonVoiceOverAction()]
        }
    }

    @IBInspectable var hideOptionsWhenSelect: Bool = true
    @IBInspectable var supportFreeText: Bool = false
    @IBInspectable var rowEstimatedHeight: CGFloat = 48
    @IBInspectable var maxTableHeight: CGFloat = 150

    var isForcedToAppearBelow: Bool?
    var isHashingTextEnabled: Bool?

    /// VFGDropdown is an overflow menu that is placed under a VFGTextField
    /// - Parameters:
    ///   - topTitleText: VFGTextField's top title text
    ///   - placeHolder: VFGTextField's placeholder text
    ///   - tipText: VFGTextField's tip text
    ///   - rowEstimatedHeight: The estimated row height
    ///   - maxTableHeight: The maximum height of the OverflowMenu. If the height is lower than this number then the height is calculated automatically
    ///   - hideOptionsWhenSelect: If true, closes the OverflowMenu when an item is selected
    ///   - supportFreeText: If true, user can write directly within the textfield, otherwise the user cannot write in textfield and the text is updated only by selecting an element from overflow menu
    ///   - items: A list with VFGOverflowMenuItem that will be shown within the OverflowMenu
    ///   - parentViewController: A base view controller that the menu will be shown over
    ///   - isForcedToAppearBelow: If true it forces menu to shown from below what ever the parent view location, its false by default
    ///   - isHashingTextEnabled: If true it enables showing text in drop down secured with Asterisk, its false by default
    public init(
        topTitleText: String? = nil,
        placeHolder: String? = nil,
        tipText: String? = nil,
        rowEstimatedHeight: CGFloat = 50,
        maxTableHeight: CGFloat = 150,
        hideOptionsWhenSelect: Bool = true,
        supportFreeText: Bool = false,
        items: [VFGOverflowMenuItem] = [],
        parentViewController: UIViewController? = nil,
        isForcedToAppearBelow: Bool? = nil,
        isHashingTextEnabled: Bool? = nil
    ) {
        self.hideOptionsWhenSelect = hideOptionsWhenSelect
        self.supportFreeText = supportFreeText
        self.rowEstimatedHeight = rowEstimatedHeight
        self.maxTableHeight = maxTableHeight
        self.isHashingTextEnabled = isHashingTextEnabled
        self.isForcedToAppearBelow = isForcedToAppearBelow

        overflowMenu = VFGOverflowMenu(
            triggerView: UIView(),
            baseView: UIView(),
            overflowMenuDatasource: [],
        isForcedToAppearBelow: isForcedToAppearBelow,
        isHashingTextEnabled: isHashingTextEnabled)
        super.init(frame: .zero)
        customUI()
        configure(
            topTitleText: topTitleText,
            placeHolder: placeHolder,
            tipText: tipText,
            items: items,
            parentViewController: parentViewController
        )
        setAccessibilityForVoiceOver()
    }

    /// When initializing the VFGDropdown through UI, you should call the configure method in order to set its data and frame
    @objc public required init?(coder aDecoder: NSCoder) {
        self.overflowMenu = VFGOverflowMenu(
            triggerView: UIView(),
            baseView: UIView(),
            overflowMenuDatasource: [],
            isForcedToAppearBelow: isForcedToAppearBelow,
            isHashingTextEnabled: isHashingTextEnabled)
        super.init(coder: aDecoder)
        customUI()
    }

    override func customUI() {
        super.customUI()
        delegate = self
        resetTextField()
        textFieldRightIcon = nil
    }

    /// VFGDropdown is an overflow menu that is placed under a VFGTextField. When added through UI this method must be called in order to configure its values
    /// - Parameters:
    ///   - topTitleText: VFGTextField's top title text
    ///   - placeHolder: VFGTextField's placeholder text
    ///   - tipText: VFGTextField's tip text
    ///   - items: A list with VFGOverflowMenuItem that will be shown within the OverflowMenu
    ///   - parentViewController: A base view controller that the menu will be shown over
    public func configure(
        topTitleText: String? = nil,
        placeHolder: String? = nil,
        tipText: String? = nil,
        items: [VFGOverflowMenuItem],
        parentViewController: UIViewController? = nil
    ) {
        configureTextField(
            topTitleText: topTitleText ?? textFieldTopTitleText,
            placeHolder: placeHolder ?? textFieldPlaceHolderText,
            rightIcon: VFGFoundationAsset.Image.icChevronDown,
            tipText: tipText
        )

        // remove the tipHeight in order to eliminate the space between the textfield and the overflow menu
        if tipText == nil {
            textFieldView?.errorHintLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }

        overflowMenu = VFGOverflowMenu(
            triggerView: self,
            baseView: parentViewController?.view ?? self.parentViewController?.view,
            overflowMenuDatasource: items,
            rowEstimatedHeight: rowEstimatedHeight,
            maxTableHeight: maxTableHeight,
            hideOptionsWhenSelect: hideOptionsWhenSelect,
            isForcedToAppearBelow: isForcedToAppearBelow,
            isHashingTextEnabled: isHashingTextEnabled)
        overflowMenu.overflowMenuDelegate = self
    }

    public func closeOverflowMenu() {
        overflowMenu.close()
    }

    public func selectItem(_ item: VFGOverflowMenuItem) {
        textFieldText = "\(isHashingTextEnabled ?? false ? item.primaryText.hashWithAsterisk() : item.primaryText)"
    }

    private var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

    func setAccessibilityForVoiceOver() {
        setRightButtonAccessibilityLabel(with: "Drop down menu")
        setRightButtonAccessibilityHint(with: "Press to show drop down menu")
        accessibilityCustomActions = [rightButtonVoiceOverAction()]
    }
}

extension VFGDropdown: VFGTextFieldProtocol {
    public func vfgTextFieldDidBeginEditing(_ vfgTextField: VFGTextField) {
        overflowMenu.shouldOpen = true
    }

    public func vfgTextFieldDidEndEditing(_ vfgTextField: VFGTextField) {
        overflowMenu.close()
        overflowMenu.shouldOpen = false
    }

    public func vfgTextFieldRightButtonClicked(_ vfgTextField: VFGTextField) {
        rightButtonPressed()
    }
    @objc func rightButtonPressed() {
        overflowMenu.toggle()
        let selectedIndex = overflowMenu.overflowMenuDatasource.firstIndex { $0.primaryText == textFieldText }
        overflowMenu.selectedIndex = selectedIndex
        textFieldView?.changeBorderColor(to: overflowMenu.isOpened ? .focus : .normal)
    }
    func rightButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = isMenuOpened ? "Close drop menu" : "Open drop menu"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(rightButtonPressed)
        )
    }

    public func vfgTextFieldShouldChange(
        _ vfgTextField: VFGTextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if let textFieldText = vfgTextField.textFieldText as NSString? {
            let primaryText = textFieldText.replacingCharacters(in: range, with: string)
            return supportFreeText || overflowMenu.containsOption(with: primaryText)
        }
        return supportFreeText
    }

    public func vfgTextFieldDidChange(_ vfgTextField: VFGTextField, text: String) {
        overflowMenu.updateDataSource(text: text)
    }

    public func vfgTextFieldShouldBeginEditing(_ vfgTextField: UITextField) -> Bool {
        return supportFreeText
    }
}

extension VFGDropdown: VFGOverflowMenuDelegate {
    public func didSelect(selectedItem: VFGOverflowMenuItem, index: Int) {
        selectItem(selectedItem)
        dropdownDelegate?.didSelect(selectedItem: selectedItem, index: index)
    }

    public func willOpen() {
        UIView.animate(withDuration: 0.25) {
            self.textFieldView?.rightButton.transform = CGAffineTransform(rotationAngle: .pi)
            self.layoutIfNeeded()
        }
        dropdownDelegate?.willOpen()
    }

    public func didOpen() {
        dropdownDelegate?.didOpen()
        isMenuOpened = true
    }

    public func willClose() {
        UIView.animate(withDuration: 0.25) {
            self.textFieldView?.rightButton.transform = CGAffineTransform.identity
            self.textFieldView?.changeBorderColor(to: .normal)
            self.layoutIfNeeded()
        }
        dropdownDelegate?.willClose()
    }

    public func didClose() {
        endEditing(true)
        if !textFieldText.isEmpty {
            textFieldView?.changeBorderState(to: .full)
        }
        dropdownDelegate?.didClose()
        isMenuOpened = false
    }
}
