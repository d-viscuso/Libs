//
//  VFGroupItemView.swift
//  VFGMVA10
//
//  Created by Mahmoud Amer on 1/16/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import UIKit
import VFGMVA10Foundation
/// Dashboard grouped item view
class VFGroupItemView: UIView {
    let nibName = "VFGroupItemView"
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var arrowImageView: VFGImageView!
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var titleLabel: VFGLabel!
    /// Dashboard grouped item badge view
    var badgeView: VFGBadgeView?
    var badgeTopMargin: CGFloat = -10
    var badgeTrailingMargin: CGFloat = 10
    /// Dashboard grouped item model
    var itemModel: VFGSubItem? {
        didSet {
            setupView()
        }
    }
    /// Dashboard grouped item action
    var itemAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    private func setupView() {
        guard let model = itemModel else {
            return
        }
        if let icon = model.icon {
            iconImageView.download(by: icon)
        }
        titleLabel.text = model.title?.localized(bundle: Bundle.mva10Framework) ?? ""
        if let badgeId = model.badgeId {
            setupBadgeView(with: model.initialBadgeValue, badgeId: badgeId)
        } else {
            badgeView = nil
        }
    }

    @IBAction func itemTapped(_ sender: VFGButton) {
        itemAction?()
    }

    private func setupBadgeView(with intialValue: Int?, badgeId: String) {
        badgeView = VFGBadgeView()
        guard let badgeView = badgeView else { return }
        addSubview(badgeView)
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            badgeView.topAnchor.constraint(
                equalTo: iconImageView.topAnchor,
                constant: badgeTopMargin),
            badgeView.trailingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor,
                constant: badgeTrailingMargin)
        ])

        badgeView.backgroundColor = .red
        badgeView.setup(with: badgeId)
        guard let intialValue = intialValue else { return }
        badgeView.update(with: BadgeModel(text: "\(intialValue)"))
    }

    private func viewVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "Select \(titleLabel.text ?? "")"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(itemTapped))
    }

    override var isAccessibilityElement: Bool {
        get { true }
        set {}
    }

    override var accessibilityLabel: String? {
        get { titleLabel.text }
        set {}
    }

    private func setupVoiceoverAccessibility() {
        accessibilityCustomActions = [viewVoiceOverAction()]
        [arrowImageView, iconImageView, titleLabel].forEach {
            $0?.isAccessibilityElement = false
        }
    }
}

extension VFGroupItemView {
    /// Dashboard grouped item view XIB load
    func xibSetup() {
        guard let view = loadViewFromNib(nibName: nibName) else {
            VFGErrorLog("VFGroupItemView is nil")
            return
        }
        contentView = view
        xibSetup(contentView: contentView)
        setupVoiceoverAccessibility()
    }
}
