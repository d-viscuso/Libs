//
//  VFGSubtrayViewProtocol.swift
//  VFGMVA10Group
//
//  Created by Sandra Morcos on 8/7/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Protocol for any sub tray view with its initial properties and methods
public protocol VFGSubtrayViewProtocol: UIView {
    // MARK: - Required
    /// *VFGSubTrayView* initializer
    /// - Parameters:
    ///    - title: Sub tray view title
    ///    - subtitle: Sub tray view subtitle
    ///    - onRefresh: Sub tray view refresh handler
    init(_ title: String, _ subtitle: String, _ onRefresh: @escaping () -> Void)
    /// Collection view within sub tray view
    var collectionView: UICollectionView? { get }
    /// Delegation protocol for sub tray view actions
    var delegate: VFGSubtrayViewDelegate? { get set }
    /// Delegation protocol for sub tray view data source
    var dataSource: VFGSubtrayViewDataSource? { get set }
    /// Sub tray view data model
    var dataModel: VFGSubTrayModel? { get set }
    /// Type of error if sub tray didn't load successfully
    var error: Error? { get set }
    /// Information text for sub tray view
    var informationText: String? { get set }
    /// Title text for sub tray view
    var title: String? { get }
    /// Determine whether horizontal sub tray can be converted to a vertical one or not
    var enableAutoSwitchToVerticalSubTray: Bool? { get set }

    // MARK: - Optional
    /// Sub tray view height
    var height: CGFloat { get }
    /// Bottom constraints constant for sheet view if exist
    var sheetViewBottomConstraintTrayContent: CGFloat { get }
    /// Reload views inside sub tray view
    func reloadViews()
}

extension VFGSubtrayViewProtocol {
    public func reloadViews() {
        collectionView?.reloadData()
        collectionView?.setContentOffset(.zero, animated: false)
    }

    public var sheetViewBottomConstraintTrayContent: CGFloat {
        0
    }

    public var height: CGFloat {
        0
    }

    public var informationText: String? {
        get { nil }
        set { _ = newValue }
    }

    public var enableAutoSwitchToVerticalSubTray: Bool? {
        get { nil }
        set { _ = newValue }
    }
}
