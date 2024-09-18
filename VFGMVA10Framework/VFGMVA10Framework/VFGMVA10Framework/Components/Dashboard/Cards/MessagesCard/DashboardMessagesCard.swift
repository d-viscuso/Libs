//
//  DashboardMessagesCard.swift
//  VFGMVA10Group
//
//  Created by Salma Ashour on 06/12/2020.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// Dashboard messages card
class DashboardMessagesCard: UIView {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var subTitleLabel: VFGLabel!
    @IBOutlet weak var cardImageView: VFGImageView!
    /// Dashboard messages card notification manager
    var notificationManager = VFGRemoteNotificationManager.shared

    convenience init(
        errorMessage: String?,
        tryAgainMessage: String = "dashboard_loading_error_try_again_button",
        accessibilityIdInitial: String? = nil
    ) {
        self.init(frame: CGRect.zero)
        accessibilityLabel = accessibilityIdInitial

        guard let errorMessage = errorMessage,
            !errorMessage.isEmpty,
            let errorCard: CompactErrorCard = UIView.loadXib(bundle: Bundle.foundation)
        else {
            commonInit()
            return
        }

        errorCard.configure(
            errorMessage: errorMessage.localized(bundle: Bundle.mva10Framework),
            tryAgainMessage: tryAgainMessage.localized(bundle: Bundle.mva10Framework),
            accessibilityIdInitial: accessibilityIdInitial)
        embed(view: errorCard)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func commonInit() {
        guard let contentView = self.loadViewFromNib(nibName: className, in: .mva10Framework) else {
            return
        }

        xibSetup(contentView: contentView)
        localizeTitleLabel()
        setupSubTitle()
        let image = VFGUser.shared.isLimitedUser ? VFGFrameworkAsset.Image.padlockClose : VFGFrameworkAsset.Image.icMail
        cardImageView.image = image
    }
    /// Dashboard messages card title localization
    func localizeTitleLabel() {
        titleLabel.text = "dashboard_my_messages_card_title".localized(bundle: Bundle.mva10Framework)
    }
    /// Dashboard messages card subtitle localization
    func setupSubTitle() {
        guard !VFGUser.shared.isLimitedUser else {
            subTitleLabel.text = "dashboard_item_secure_content_subtitle".localized(bundle: Bundle.mva10Framework)
            return
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateSubtitle(notification:)),
            name: .VFGBadgesTrackerID,
            object: nil
        )
        notificationManager.retrieveUnreadMessagesCountAndNotifyListeners()
    }

    @objc func updateSubtitle(notification: Notification) {
        guard
            let badgeModel = notification.userInfo?[Constants.messageCenterBadgeID] as? BadgeModel,
            let counter = badgeModel.text else {
            return
        }

        if counter == "0" {
            subTitleLabel?.text = "tray_messages_section_subtitle".localized(bundle: Bundle.mva10Framework)
        } else {
            let subTitleWithCounter =
                "tray_messages_section_subtitle_with_badge".localized(bundle: Bundle.mva10Framework)
            subTitleLabel?.text = String(format: subTitleWithCounter, counter)
        }
    }
}
