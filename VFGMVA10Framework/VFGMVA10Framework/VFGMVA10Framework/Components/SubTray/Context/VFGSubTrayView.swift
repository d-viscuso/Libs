//
//  VFGSubTrayView.swift
//  VFGMVA10Group
//
//  Created by Mohamed Mahmoud Zaki on 8/6/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Sub tray view
open class VFGSubTrayView: UIView, VFGSubtrayViewProtocol, VFGSubtrayViewAnimatable {
    // MARK: - VFGSubtrayViewProtocol 
    public var title: String? {
        currentSubtrayState?.title
    }

    public var error: Error? {
        get {
            currentSubtrayState?.error
        }
        set {
            currentSubtrayState?.error = newValue
        }
    }

    public var informationText: String? {
        get {
            currentSubtrayState?.informationText
        }
        set {
            currentSubtrayState?.informationText = newValue
        }
    }

    public var collectionView: UICollectionView? {
        currentSubtrayState?.collectionView
    }

    public var height: CGFloat {
        currentSubtrayState?.height ?? 0
    }

    public var sheetViewBottomConstraintTrayContent: CGFloat {
        currentSubtrayState?.sheetViewBottomConstraintTrayContent ?? 0
    }

    public func reloadViews() {
        currentSubtrayState?.reloadViews()
    }

    weak public var delegate: VFGSubtrayViewDelegate? {
        didSet {
            currentSubtrayState?.delegate = delegate
        }
    }

    weak public var dataSource: VFGSubtrayViewDataSource? {
        didSet {
            currentSubtrayState?.dataSource = dataSource
        }
    }

    public var dataModel: VFGSubTrayModel? {
        didSet {
            currentSubtrayState?.dataModel = dataModel
            prepareStateTransition()
        }
    }

    public var enableAutoSwitchToVerticalSubTray: Bool?

    // MARK: - VFGSubtrayViewProtocol initializer
    required public init(_ title: String, _ subtitle: String, _ onRefresh: @escaping () -> Void) {
        super.init(frame: CGRect.zero)
        commonInit(title, subtitle, onRefresh)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - VFGDynamicSubTrayView variables
    /// Current sub tray state type
    public var currentSubtrayState: VFGBaseSubtrayView?
    /// Sub tray view subtitle
    public var subtitle: String?
    /// Sub tray view refresh handler
    public var onRefresh: (() -> Void)?

    // MARK: - VFGDynamicSubTrayView methods
    private func commonInit(_ title: String, _ subtitle: String, _ onRefresh: @escaping () -> Void) {
        self.subtitle = subtitle
        self.onRefresh = onRefresh
        transition(to: VFGHorizontalSubTrayView(title, subtitle, onRefresh))
    }
    /// Configuration for transition between sub tray different state types
    /// - Parameters:
    ///    - subtrayState: New sub tray for transition process
    ///    - dataSource: Sub tray data source
    open func transition(to subtrayState: VFGBaseSubtrayView, _ dataSource: VFGSubTrayModel? = nil) {
        removeSubviews()

        currentSubtrayState = subtrayState
        currentSubtrayState?.dataModel = dataSource

        delegate?.subtrayHeightDidChange(for: subtrayState)
        embed(view: subtrayState)
    }
    /// Sub tray different state types transition preparation
    open func prepareStateTransition() {
        guard
            let subtitle = subtitle,
            let title = currentSubtrayState?.title,
            let refresh = onRefresh,
            let currentSubtrayState = currentSubtrayState else {
                self.currentSubtrayState?.error = VFGSubTrayErrorResponse.transition
                return
        }

        switch (
            isSubTrayExpanded(),
            currentSubtrayState is VFGHorizontalSubTrayView
        ) {
        case (true, true):
            transition(to: VFGVerticalSubTrayView(title, subtitle, refresh), dataModel)
        case (false, false):
            transition(to: VFGHorizontalSubTrayView(title, subtitle, refresh), dataModel)
        default:
            break
        }
    }
    /// Determine wether sub tray is expanded or not
    public func isSubTrayExpanded() -> Bool {
        let itemsCount = dataModel?.items?.count ?? 0
        if checkForAutomaticVerticalTray(subTrayItemsCount: itemsCount) {
            return true
        }

        guard
            let dataSource = dataModel,
            let expandedTrayConfiguration =
                dataSource.metaData?["expandedTrayConfiguration"] as? VFGTrayItemModel.VFGTrayItemModelConfiguration,
            let isExpandedTrayEnabled = dataSource.metaData?["isExpandedTrayEnabled"] as? Bool,
            let subTrayItemsCount = dataSource.items?.count,
            let categoriesCount = currentSubtrayState?.categories.count
            else { return false }

        let itemCountThreshold = expandedTrayConfiguration.itemCountThreshold ?? 6
        let categoriesCountThreshold = expandedTrayConfiguration.categoriesCountThreshold ?? 2
        let isCategoriesEnabled = expandedTrayConfiguration.isCategoriesEnabled ?? false

        return
            isExpandedTrayEnabled &&
            subTrayItemsCount != 0 &&
            subTrayItemsCount >= itemCountThreshold &&
            (categoriesCount >= categoriesCountThreshold || !isCategoriesEnabled)
    }

    private func checkForAutomaticVerticalTray(subTrayItemsCount: Int) -> Bool {
        let configuration =
            dataModel?.metaData?["expandedTrayConfiguration"] as? VFGTrayItemModel.VFGTrayItemModelConfiguration
        let itemCountThreshold = configuration?.itemCountThreshold ?? 6
        return (enableAutoSwitchToVerticalSubTray ?? false) &&
            subTrayItemsCount > itemCountThreshold
    }
}
