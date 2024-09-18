//
//  InactiveSeasonalOfferCard.swift
//  VFGMVA10Framework
//
//  Created by Tuncel, Pelin, Vodafone on 6/15/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation


/// delegate to let the market to implement the Seasonal offer activation logic
protocol SeasonalOfferCardDelegate: AnyObject {
    // func called when there is a click on inactive card
    func inactiveSeasonalOfferClicked(cardModel: SeasonalOffersCardModel?)
    // func called after the seasonal offer is activated after delay is complete
    func activateSeasonalOffer()
    // func called when there is a click on active card
    func activeSeasonalOfferClicked(cardModel: SeasonalOffersCardModel?)
}


/// InactiveSeasonalOfferCard: this view is shown when the SeasonalOffersCardModel type is inactive or intermediate: in such cases the countdown is hidden
public class InactiveSeasonalOfferCard: UIView {
    @IBOutlet weak var logo: VFGImageView!
    @IBOutlet weak var primaryTextLabel: VFGLabel!
    @IBOutlet weak var primaryTextWithLogoLabel: VFGLabel!
    @IBOutlet weak var secondaryTextLabel: VFGLabel!

    weak var delegate: SeasonalOfferCardDelegate?
    /// Active card view action
    var itemAction: (() -> Void)?
    let actions = VFGManagerFramework.dashboardDelegate?.dashboardActions()
    var model: SeasonalOffersCardModel?
    public var item: VFGDashboardItem? {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
            setupAction()
        }
    }

    public func config(model: SeasonalOffersCardModel) {
        self.model = model
        let intermediateTitle = model.intermediateTitle
        let primaryTitle = model.primaryTitle
        primaryTextLabel.text = model.type == .intermediate(cardType: .withoutLogo) ? intermediateTitle : primaryTitle
        primaryTextWithLogoLabel.text = model.type ==
            .intermediate(cardType: .withLogo) ? intermediateTitle : primaryTitle
        secondaryTextLabel.text = model.secondaryTitle

        if let url = URL(string: model.logoImageURL) {
            logo.download(from: url, placeholder: VFGFrameworkAsset.Image.placeholder)
        }

        setupView(type: model.type.cardType)
    }

    private func setupView(type: VFGSeasonalOffersCardType?) {
        switch type {
        case .withoutLogo:
            primaryTextWithLogoLabel.isHidden = true
            logo.isHidden = true
            primaryTextLabel.isHidden = false
            secondaryTextLabel.isHidden = false
        default:
            logo.isHidden = false
            primaryTextWithLogoLabel.isHidden = false
            primaryTextLabel.isHidden = true
            secondaryTextLabel.isHidden = true
        }
        setupAction()
    }

    private func setupAction() {
        if let itemId = item?.itemActionId {
            itemAction = actions?[itemId]
        }
    }

    @IBAction func startSeasonalOfferActivation(_ sender: Any) {
        let actions = VFGManagerFramework.dashboardDelegate?.dashboardActions()
        let action = actions?[item?.itemActionId ?? "" ]
        action?()
        guard var model = model else {
            return
        }
        delegate?.inactiveSeasonalOfferClicked(cardModel: model)
        model.type = .intermediate(cardType: model.type.cardType ?? .withoutLogo)
        config(model: model)
        let waitOfferTime = model.waitOfferTime
        let delay: DispatchTime = .now() + DispatchTimeInterval.seconds(waitOfferTime)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.delegate?.activateSeasonalOffer()
        }
    }
}
