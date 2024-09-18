//
//  ActiveSeasonalOfferCard.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 15/06/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation


/// ActiveSeasonalOfferCard: when the SeasonalOffersCardModel type is active this view shows the countdown of the active offer
public class ActiveSeasonalOfferCard: UIView {
    @IBOutlet weak var cardTitleLabel: VFGLabel!
    @IBOutlet weak var countDownContainer: VFGCountdownView!
    @IBOutlet weak var cardButtonLabel: VFGLabel!

    weak var delegate: SeasonalOfferCardDelegate?

    var model: SeasonalOffersCardModel? {
        didSet {
            if model?.offerDate != nil {
                countDownContainer.dataSource = self
                countDownContainer.startCounting()
                countDownContainer.delegate = self
            }
        }
    }

    /// Configure the ActiveSeasonalOfferCard view using the model
    /// - Parameter model: SeasonalOffersCardModel with the configuration data
    public func config(model: SeasonalOffersCardModel) {
        self.model = model
        cardTitleLabel.textColor = UIColor.VFGWhiteText
        cardTitleLabel.font = UIFont.vodafoneBold(14)
        cardTitleLabel.numberOfLines = 0
        cardTitleLabel.lineBreakMode = .byWordWrapping
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.12
        paragraphStyle.lineSpacing = 5
        cardTitleLabel.attributedText = NSMutableAttributedString(
            string: model.activeTitle,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        cardButtonLabel.text = model.activeButtonTitle
    }

    @IBAction func activeSeasonalOfferClicked(_ sender: Any) {
        delegate?.activeSeasonalOfferClicked(cardModel: model)
    }
}

// MARK: - hide seansonal offer Logic
extension ActiveSeasonalOfferCard {
    public func hideSeansonalOffer() {
        let dashboardManager = VFGManagerFramework.dashboardDelegate?.dashboardManager
        let dataSource = dashboardManager?.dashboardController.dashboardDataSource
        guard let seaonsalOfferSection = dataSource?.seansonalOfferIndexInSections() else {
            return
        }
        let indexPath = IndexPath(item: 0, section: seaonsalOfferSection)
        dashboardManager?.hideItem(at: indexPath)
    }
}

extension ActiveSeasonalOfferCard: VFGCountdownDataSource {
    /// Converts the model offer date from string to TimeInterval
    /// - Parameter view: countdown view
    /// - Returns: time interval in seconds from the offer date
    public func countdownTime(_ view: VFGCountdownView) -> TimeInterval {
        let date = VFGDateHelper.getDateFromString(dateString: model?.offerDate ?? "")
        return date?.timeIntervalSinceNow ?? TimeInterval()
    }
}

extension ActiveSeasonalOfferCard: VFGCountdownDelegate {
    /// hide the offer view when the timer expires (state is finished)
    /// - Parameters:
    ///   - view: countdown view
    ///   - state: state of the timer
    public func countdown(_ view: VFGCountdownView, stateDidChange state: VFGTimerState) {
        if state == .finished {
            hideSeansonalOffer()
        }
    }
}
