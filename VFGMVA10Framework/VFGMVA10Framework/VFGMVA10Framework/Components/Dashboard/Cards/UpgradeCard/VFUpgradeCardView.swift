//
//  VFUpgradeCardView.swift
//  VFGMVA10Group
//
//  Created by Mahmoud Amer on 7/28/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// Dashboard upgrade card view
class VFUpgradeCardView: UIView {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardTitle: VFGLabel!
    @IBOutlet weak var cardSubTitle: VFGLabel!
    @IBOutlet weak var cardButtonTitle: VFGLabel!
    @IBOutlet weak var backgroundViewCenterConstraint: NSLayoutConstraint!
    /// Dashboard upgrade card view action
    var itemAction: (() -> Void)?
    /// Dashboard actions list
    let actions = VFGManagerFramework.dashboardDelegate?.dashboardActions()
    let startPoint = CGPoint(x: 1.0, y: 0.0)
    let endPoint = CGPoint(x: 0.0, y: 1.0)
    /// Dashboard item
    var item: VFGDashboardItem? {
        didSet {
            setup()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundView.setGradientBackgroundColor(
            colors: UIColor.VFGDiscoverRedGradient,
            startPoint: startPoint,
            endPoint: endPoint
        )
        setupAccessibilityLabels()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.layer.sublayers?.first?.frame = backgroundView.bounds
    }

    private func setup() {
        guard
            let item = item,
            let metaData = item.metaData else { return }

        let localizedTitle = "dashboard_upgrade_component_title_topup".localized()
        let giftData = metaData["giftData"] as? [String: Any]
        cardTitle.text = String(
            format: localizedTitle,
            (metaData["username"] as? String)?.localized(bundle: .mva10Framework) ?? "",
            "\(giftData?["giftThreshold"] as? Int ?? 0)",
            "\(giftData?["currency"] as? String ?? "")",
            "\(giftData?["giftValue"] as? Int ?? 0)",
            "\(giftData?["giftUnit"] as? String ?? "")",
            "\(giftData?["giftPrice"] as? Int ?? 0)",
            "\(giftData?["currency"] as? String ?? "")")

        let localizedSubTitle = "dashboard_upgrade_component_subtitle_topup".localized()
        cardSubTitle.text = String(
            format: localizedSubTitle,
            "\(giftData?["normalPrice"] as? Int ?? 0)",
            "\(giftData?["currency"] as? String ?? "")",
            "\((giftData?["endData"] as? String)?.localized() ?? "")")
        cardButtonTitle.text = "dashboard_upgrade_component_button_topup".localized()

        if let itemId = item.itemActionId {
            itemAction = actions?[itemId]
        }
    }

    // MARK: - Actions
    @IBAction func upgradeCardClicked(_ sender: Any) {
        itemAction?()
    }

    private func upgradeCardVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "Upgrade"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(upgradeCardClicked))
    }

    private func setupAccessibilityLabels() {
        isAccessibilityElement = false
        backgroundView.isAccessibilityElement = false
        cardButtonTitle.accessibilityTraits = .button
        cardButtonTitle.accessibilityCustomActions = [upgradeCardVoiceOverAction()]
        guard
            let cardTitle = cardTitle,
            let cardSubTitle = cardSubTitle,
            let cardButtonTitle = cardButtonTitle
        else { return }
        accessibilityElements = [cardTitle, cardSubTitle, cardButtonTitle]
    }
}
