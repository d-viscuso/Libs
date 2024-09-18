//
//  VFGHorizontalSubTrayCollectionViewCell.swift
//  mva10
//
//  Created by Yahya Saddiq on 26/11/20.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// *VFGSubTray* collection view cell
class VFGSubTrayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var recommendationView: UIView?
    @IBOutlet weak var recommendedLabel: VFGLabel?
    @IBOutlet weak var titleLabel: VFGLabel?
    @IBOutlet weak var subtitleLabel: VFGLabel?
    @IBOutlet weak var descriptionLabel: VFGLabel?
    @IBOutlet weak var imageView: VFGImageView?
    @IBOutlet weak var lockView: UIView?
    @IBOutlet weak var trayBackgroundView: UIView?
    @IBOutlet weak var customizeButton: VFGButton?
    @IBOutlet weak var defaultImageView: VFGImageView?
    @IBOutlet weak var containerTrailingConstraint: NSLayoutConstraint?
    /// *VFGSubTray* collection view cell badge view
    var badgeView: VFGBadgeView?
    /// Sub tray item data model
    var item: VFGSubTrayItem?
    /// Sub tray view notification manager
    var notificationManager = VFGRemoteNotificationManager.shared
    /// Determine whether cell access is locked or not
    var isLocked = true
    /// Sub tray access secure content subtitle
    let lockedAccessText = "sub_tray_access_secure_content_subtitle".localized(bundle: .mva10Framework)
    /// Sub tray view customize button action
    var customizeButtonActionClosure: (() -> Void)?
    var topAnchorBadgeConstraint: CGFloat = 4
    var trailingAnchorBadgeConstraint: CGFloat = -10
    private let recommendationViewRadius: CGFloat = 6.3

    override func prepareForReuse() {
        badgeView?.removeFromSuperview()
        badgeView = nil
        defaultImageView?.isHidden = true
        updateOutlineUnselected()
        super.prepareForReuse()
    }
    /// *VFGSubTrayCollectionViewCell* setup
    /// - Parameters:
    ///    - item: Sub tray view item data model
    ///    - index: Sub tray view index
    ///    - type: Sub tray view type
    ///    - isLocked: Determine whether cell access is locked or not
    ///    - isCustomizable: Determine if sub tray can be customized or not
    ///    - isHighlighted: Determine if sub tray view item or not
    func setup(
        item: VFGSubTrayItem,
        index: Int,
        type: String?,
        isLocked: Bool,
        isCustomizable: Bool = false,
        isHighlighted: Bool = false
    ) {
        self.item = item
        self.isLocked = isLocked

        recommendedLabel?.text = "sub_tray_item_recommended_view".localized(bundle: .mva10Framework)
        titleLabel?.text = item.title?.localized(bundle: .mva10Framework)
        imageView?.image = isLocked ? VFGImage(named: (item.imageName ?? "") + "_locked") : item.image
        lockView?.isHidden = !isLocked
        subtitleLabel?.text = isLocked ? lockedAccessText : item.formattedSubTitle
        subtitleLabel?.numberOfLines = 2
        descriptionLabel?.text = item.description?.localized(bundle: .mva10Framework)
        descriptionLabel?.isHidden = item.description?.localized(bundle: .mva10Framework).isEmpty ?? true
        trayBackgroundView?.backgroundColor = isLocked ? .VFGWhiteBackground : .VFGLightGreyBackground
        let customizeText = item.customizeText?.localized(bundle: .mva10Framework)
        customizeButton?.isHidden = !isCustomizable && customizeText == nil
        customizeButton?.setTitle(item.customizeText?.localized(bundle: .mva10Framework), for: .normal)

        if let animationType = item.imageViewAnimation {
            imageView?.animate(animationType, delay: 0.5)
        }

        if (item.showBadge ?? true) && !VFGUser.shared.isLimitedUser {
            setupBadge(for: item)
        }

        defaultImageView?.isHidden = !(item.isDefault ?? false)
        setupAccessibilityIds(at: index, and: type ?? "")
        recommendationView?.roundUpperCorners(cornerRadius: recommendationViewRadius)
        recommendationView?.isHidden = !(item.hasBanner ?? false)

        // Outline
        if isLocked {
            updateOutlineLocked()
        } else if isHighlighted {
            updateOutlineSelected()
        } else {
            updateOutlineUnselected()
        }
        setupVoiceOverAccessibility()
    }

    @IBAction func customizeButtonPressed(_ sender: Any) {
        customizeButtonAction()
    }

    @objc func customizeButtonAction() {
        customizeButtonActionClosure?()
    }

    private func setupBadge(for item: VFGSubTrayItem) {
        guard let badge = item.badge else {
            return
        }

        badgeView = VFGBadgeView()
        guard let badgeView = badgeView else { return }
        addSubview(badgeView)
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            badgeView.topAnchor.constraint(equalTo: topAnchor, constant: topAnchorBadgeConstraint),
            badgeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingAnchorBadgeConstraint)
        ])

        badgeView.backgroundColor = .VFGLightGreyBackground
        badgeView.setup(with: badge)

        if item.badge == SubTrayBadge.messageCenter.rawValue
            || item.badge == SubTrayBadge.sohoMessageCenter.rawValue {
            notificationManager.retrieveUnreadMessagesCountAndNotifyListeners()
        }
    }

    private func setupAccessibilityIds(at index: Int, and type: String) {
        let index = index + 1
        titleLabel?.accessibilityIdentifier = "ST\(type)Item\(index)Title"
        subtitleLabel?.accessibilityIdentifier = "ST\(type)Item\(index)SubTitle"
        accessibilityIdentifier = "ST\(type)Item\(index)"
    }
    /// *VFGSubTray* selected collection view cell layed configuration
    func updateOutlineSelected() {
        trayBackgroundView?.layer.borderWidth = 2
        trayBackgroundView?.layer.borderColor = UIColor.VFGActiveSelectionOutline.cgColor
    }
    /// *VFGSubTray* unselected collection view cell layed configuration
    func updateOutlineUnselected() {
        trayBackgroundView?.layer.borderWidth = 0
        trayBackgroundView?.layer.borderColor = .none
    }
    /// *VFGSubTray* locked collection view cell layed configuration
    func updateOutlineLocked() {
        trayBackgroundView?.layer.borderColor = UIColor.VFGLightGreyBackground.cgColor
        trayBackgroundView?.layer.borderWidth = 2
    }
    /// Update *VFGSubTray* collection view cell trailing constraint constant
        /// - Parameters:
        ///    - value: Cell new trailing constraint constant
    func updateContainerTrailingContraint(with value: CGFloat) {
        containerTrailingConstraint?.constant = value
        layoutIfNeeded()
    }
}

extension VFGSubTrayCollectionViewCell: VFGSubtrayBadgesProtocol {
    func badgeDidUpdate(newBadges: [String: BadgeModel]?) {
        switch item?.badge {
        case SubTrayBadge.messageCenter.rawValue, SubTrayBadge.sohoMessageCenter.rawValue:
            guard let badgeModel = newBadges?[Constants.messageCenterBadgeID],
                let counter = badgeModel.text else { return }
                if counter == "0" {
                    badgeView?.isHidden = true
                    subtitleLabel?.text = isLocked
                        ? lockedAccessText
                        : item?.subTitle?.localized(bundle: .mva10Framework)
                } else
                    if let subTitleWithCounter = item?.itemSubTitleWithBadge?.localized(bundle: .mva10Framework) {
                    badgeView?.isHidden = false
                        subtitleLabel?.text = isLocked
                            ? lockedAccessText
                            : String(format: subTitleWithCounter, counter)
                    }
        case SubTrayBadge.myOrders.rawValue:
            badgeView?.isHidden = true
            subtitleLabel?.text = isLocked
                ? lockedAccessText
                : item?.formattedSubTitle
        case SubTrayBadge.addresses.rawValue:
            badgeView?.isHidden = true
            subtitleLabel?.text = isLocked
                ? lockedAccessText
                : item?.formattedSubTitle

        default:
            return
        }
    }
}
