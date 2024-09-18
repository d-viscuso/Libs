//
//  OtherVodafoneAppsView.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 16/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import UIKit

/// A view which shows a group of apps which is related to you organization.
public class OtherVodafoneAppsView: UIView {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var accordionButton: VFGButton!
    @IBOutlet weak var accordionButtonContainerView: UIView!
    @IBOutlet weak var accordionButtonHeightConstraint: NSLayoutConstraint!

    public var cardHeight: CGFloat {
        let numberOfItems = dataSource?.numberOfItems(in: self) ?? 0
        let tableViewHeight = isExpanded ? rowHeight * CGFloat(numberOfItems) : rowHeight * CGFloat(visibleRows)
        let accordionButtonHeight = hasShowMore ? accordionButtonHeightConstraint.constant : .zero
        return tableViewHeight + accordionButtonHeight
    }
    /// Height for each list item
    public var rowHeight: CGFloat = 50
    /// Number of visible row only which indicates applications which is showed to the user before pressing *See more*
    public var visibleRows = 3
    /// Maximum number of rows which is populated through the component include visible and hidden ones
    public var maximumNumberOfRows = 6
    /// Height of accordion buttton container
    public var accordionButtonContainerHeight: CGFloat = 84 {
        didSet {
            accordionButtonHeightConstraint.constant = accordionButtonContainerHeight
        }
    }
    /// Callback which is called once the height of the component changes
    public var cardHeightDidChange: ((CGFloat) -> Void)?
    /// Other Vodafone apps data source
    public weak var dataSource: OtherVodafoneAppsDataSource? {
        didSet {
            reloadData()
        }
    }
    /// Other Vodafone apps delegate
    public weak var delegate: OtherVodafoneAppsDelegate?
    /// Other Vodafone appps apearance
    public weak var appearance: OtherVodafoneAppsAppearance? {
        didSet {
            tableView.reloadData()
        }
    }

    private var isExpanded = false
    private var hasShowMore: Bool {
        guard let dataSource = dataSource else {
            return false
        }

        return dataSource.numberOfItems(in: self) > visibleRows
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
        setupAccordionButtonVisibility()
        setupAccordionButtonAppearance()
    }

    private func setupTableView() {
        registerCells()
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func registerCells() {
        let otherVodafoneAppCellNib = UINib(
            nibName: String(describing: OtherVodafoneAppsCell.self),
            bundle: .mva10Framework)
        tableView.register(
            otherVodafoneAppCellNib,
            forCellReuseIdentifier: String(describing: OtherVodafoneAppsCell.self))
    }

    private func setupAccordionButtonVisibility() {
        accordionButtonContainerView.isHidden = !hasShowMore
        accordionButtonHeightConstraint.constant = hasShowMore ? accordionButtonContainerHeight : .zero
    }

    private func setupAccordionButtonAppearance() {
        accordionButton.setTitleColor(.VFGRedOrangeTextMva12, for: .normal)
        accordionButton.titleLabel?.adjustsFontSizeToFitWidth = true
        accordionButton.titleLabel?.font = .vodafoneRegular(16)
        if isExpanded {
            setupExpandedButtonAppearance()
        } else {
            setupCollapsedButtonAppearance()
        }
    }

    private func setupCollapsedButtonAppearance() {
        accordionButton.setTitle(
            "dashboard_group_component_show_more".localized(bundle: Bundle.mva10Framework),
            for: .normal
        )
    }

    private func setupExpandedButtonAppearance() {
        accordionButton.setTitle(
            "dashboard_group_component_show_less".localized(bundle: Bundle.mva10Framework),
            for: .normal
        )
    }

    /// This method is used to reload the component
    public func reloadData() {
        setupAccordionButtonVisibility()
        cardHeightDidChange?(cardHeight)
        tableView.reloadData()
    }

    @IBAction func accordionButtonDidPress(_ sender: UIButton) {
        isExpanded.toggle()
        setupAccordionButtonAppearance()
        reloadData()
    }
}

extension OtherVodafoneAppsView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else { return 0 }

        let numberOfItems = min(dataSource.numberOfItems(in: self), maximumNumberOfRows)
        return isExpanded ? numberOfItems : visibleRows
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: OtherVodafoneAppsCell.self),
            for: indexPath) as? OtherVodafoneAppsCell,
            let dataSource = dataSource
        else { return OtherVodafoneAppsCell() }
        cell.configure(model: dataSource.otherVodafoneApps(self, appForRowAt: indexPath.row))
        cell.appStateButtonAction = { [weak self] appInfo in
            guard let self = self else { return }
            self.delegate?.otherVodafoneApps(self, itemCTADidPress: appInfo)
        }
        return cell
    }
}

extension OtherVodafoneAppsView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}
