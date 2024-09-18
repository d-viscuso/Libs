//
//  TrayItem.swift
//  mva10
//
//  Created by Ahmed Hamdy Gomaa on 12/11/18.
//  Copyright © 2018 vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class TrayItemView: UIView {
    let nibName = "TrayItem"

    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var itemTitleLabel: VFGLabel!
    @IBOutlet weak var button: VFGButton!
    @IBOutlet weak var iconImageViewHeight: NSLayoutConstraint!

    var badgeView: VFGBadgeView?
    var contentView = UIView()
    var isLastSelectedItem = false
    var isNavigationItem = false

    var trayItem: VFGTrayItemModel? {
        didSet {
            self.configureTrayItem()
        }
    }
    var itemClick: ((VFGTrayItemModel) -> Void)?
    var subTrayItemScale: SubTrayItemScale?

    fileprivate func updateSelectionStatus(isSelected: Bool) {
        if isSelected {
            changeColor(from: .VFGListDataRemainingPercentage, to: .VFGListDataPrimary)
            isLastSelectedItem = true
            badgeView?.shouldSkipObserverUpdate = true
            if badgeView?.badgeModel != nil {
                badgeView?.hideBadge(animated: true)
            }
        } else {
            if isLastSelectedItem {
                changeColor(from: .VFGListDataPrimary, to: .VFGListDataRemainingPercentage)
                isLastSelectedItem = false
                badgeView?.shouldSkipObserverUpdate = false
                if badgeView?.badgeModel != nil {
                    badgeView?.showBadge(animated: true)
                }
            }
        }
    }

    func changeColor(from old: UIColor, to new: UIColor) {
        let changeColor = CATransition()
        changeColor.duration = Constants.TrayAnimations.trayItemTextDuration
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.itemTitleLabel.layer.add(changeColor, forKey: nil)
            self.iconImageView.layer.add(changeColor, forKey: nil)
            self.iconImageView.tintColor = new

            self.configureItemScale()
        }
        iconImageView.image = self.iconImageView.image?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = old
        CATransaction.commit()
    }

    func configureItemScale() {
        if self.subTrayItemScale == .normal {
            self.iconImageViewHeight.constant = 32

            if self.isLastSelectedItem {
                self.itemTitleLabel.font = UIFont.vodafoneBold(16)
            } else {
                self.itemTitleLabel.font = UIFont.vodafoneRegular(14)
            }
        } else {
            self.iconImageViewHeight.constant = 24

            if self.isLastSelectedItem {
                self.itemTitleLabel.font = UIFont.vodafoneBold(10)
            } else {
                self.itemTitleLabel.font = UIFont.vodafoneRegular(10)
            }
        }
    }

    @IBAction func trayItemPressed(_ sender: Any) {
        trayItemAction()
    }

    @objc func trayItemAction() {
        itemClick?(trayItem ?? VFGTrayItemModel())
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    func xibSetup() {
        guard let view = self.loadViewFromNib(nibName: nibName) else {
            VFGErrorLog("TrayItemView is nil")
            return
        }
        contentView = view

        xibSetup(contentView: contentView)
    }

    func configureTrayItem() {
        itemTitleLabel.text = trayItem?.title?.localized(bundle: Bundle.mva10Framework)
        itemTitleLabel.textColor = .VFGListDataRemainingPercentage
        configureItemScale()
        accessibilityValue = trayItem?.title?.localized(bundle: Bundle.mva10Framework)
        iconImageView.image = trayItem?.icon
        trayItem?.isSelected.bind { [weak self] isSelected in
            guard let self = self else { return }
            self.updateSelectionStatus(isSelected: isSelected)
        }
        setupVoiceOverAccessibility()

        guard let badge = trayItem?.badge else {
            return
        }
        badgeView = VFGBadgeView()
        guard let badgeView = badgeView else { return }
        iconImageView.addSubview(badgeView)
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            badgeView.topAnchor.constraint(equalTo: iconImageView.topAnchor, constant: -5),
            badgeView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: -11)
        ])

        badgeView.setup(with: badge)
        if badge == Constants.messageCenterBadgeID {
            badgeView.accessibilityIdentifier = "MCmsgCounter"
        } else {
            badgeView.accessibilityIdentifier = "MC\(badge)"
        }
    }
}
