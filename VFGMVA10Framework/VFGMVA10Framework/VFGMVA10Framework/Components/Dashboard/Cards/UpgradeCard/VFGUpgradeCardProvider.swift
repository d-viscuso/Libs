//
//  VFGUpgradeCardProvider.swift
//  VFGMVA10Group
//
//  Created by Mohamed Mahmoud Zaki on 4/16/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

// MARK: - json keys
/// Dashboard upgrade card keys
enum VFGUpgradeCardMetaDataKeys {
    static let title = "title"
    static let subtitle = "subtitle"
    static let buttonTitle = "buttonTitle"
}
/// Dashboard upgrade card entry
public class VFGUpgradeCardProvider: NSObject, VFGComponentEntry, VFDashboardListEntryProtocol {
    required public init(config: [String: Any]?, error: [String: Any]?) {}

    let minPercentage: CGFloat = 0.0
    let maxPercentage: CGFloat = 0.5
    var parallexConstraint: NSLayoutConstraint?
    var parallexInitialValue: CGFloat?

    public lazy var cardView: UIView? = {
        guard let view: VFUpgradeCardView = UIView.loadXib(bundle: Bundle.mva10Framework) else {
            return nil
        }
        parallexConstraint = view.backgroundViewCenterConstraint
        parallexInitialValue = view.backgroundViewHeightConstraint.constant
        view.item = item
        return view
    }()

    public var cardEntryViewController: UIViewController? {
        return nil
    }

    public func didScroll(percentage: CGFloat) {
        guard percentage > minPercentage,
            percentage < maxPercentage,
        let initialValue = parallexInitialValue else {
            return
        }
        let newParallexValue = initialValue * percentage
        parallexConstraint?.constant = -newParallexValue
    }

    // MARK: - VFDashboardListEntryProtocol
    public var showMoreHeight: CGFloat?

    public var showMoreAction: ((Bool) -> Void)?

    public var hasShowMore: Bool?

    public var item: VFGDashboardItem?
}
