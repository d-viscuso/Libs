//
//  VFGMVA12HeaderMenuItemView.swift
//  VFGMVA10Framework
//
//  Created by Ihsan Kahramanoglu on 14.06.2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import UIKit
import VFGMVA10Foundation

class VFGMVA12HeaderMenuItemView: UIView {
    @IBOutlet weak var menuButtonIcon: VFGImageView!
    @IBOutlet weak var menuItemButton: VFGButton!

    private lazy var menuItemBadgeView: VFGBadgeView = {
        let badgeView = VFGBadgeView()
        return badgeView
    }()

    private var menuItemModel: VFGMVA12HeaderMenuItemModelProtocol?
    private var menuItemBadgeModel: BadgeModel?
    private let menuItemBadgeViewNormalLeading: CGFloat = -20
    private let menuItemBadgeViewMaxWidth: CGFloat = 32

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(menuItemBadgeView)
        setupConstraints()
    }

    func setupConstraints() {
        menuItemBadgeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuItemBadgeView.leadingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: menuItemBadgeViewNormalLeading),
            menuItemBadgeView.widthAnchor.constraint(
                lessThanOrEqualToConstant: menuItemBadgeViewMaxWidth),
            menuItemBadgeView.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: 0)
        ])
    }

    func setMenuItem(_ menuItemModel: VFGMVA12HeaderMenuItemModelProtocol) {
        self.menuItemModel = menuItemModel

        menuButtonIcon.download(by: menuItemModel.imageIdentifier ?? "")

        menuItemBadgeView.setup(with: menuItemModel.badgeId)
        if let customText = menuItemModel.badgeCustomText, !customText.isEmpty {
            menuItemBadgeModel = BadgeModel(text: "\(customText)")
        } else {
            menuItemBadgeModel = BadgeModel(text: "\(menuItemModel.badgeCount)")
        }

        VFGBadgesTracker.shared.updateBadge(with: menuItemModel.badgeId, model: menuItemBadgeModel ?? BadgeModel())
    }

    @IBAction func menuItemButtonClicked(_ sender: Any) {
        menuItemModel?.clickAction()
    }
}
