//
//  VFGSeasonalOffersCardView.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 17/06/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// delegate to let the market to implement the Seasonal offer  logic
public protocol SeasonalOfferDelegate: AnyObject {
    // func called when there is a click on inactive card
    func seasonalOfferCardClicked(cardModel: SeasonalOffersCardModel?)
}

/// VFGSeasonalOffersCardView: this card show the seasonal offers:
/// his content can be an ActiveSeasonalOfferCard or InactiveSeasonalOfferCard depending from the model SeasonalOffersCardModel type field
public class VFGSeasonalOffersCardView: UIView {
    @IBOutlet weak var offerContentView: UIView!
    @IBOutlet weak var background: VFGImageView!

    let startPoint = CGPoint(x: 0.25, y: 0.5)
    let endPoint = CGPoint(x: 0.75, y: 0.5)

    public weak var delegate: SeasonalOfferDelegate?

    var errorView: VFGSeasonalOffersErrorView?
    var shimmerView: VFGSeasonalOffersShimmerView?
    var seasonalOfferMode: VFGSeasonalOfferMode?
    var model: SeasonalOffersCardModel?
    var item: VFGDashboardItem? {
        didSet {
            guard let model = model else {
                return
            }
            setupView(mode: seasonalOfferMode, model: model)
        }
    }

    /// State of  the **HorizontalDiscoverView**
    public var state: VFGContentState = .loading {
        didSet {
            if state != .error {
                removeErrorView()
            }
            guard let model else {
                showShimmerView()
                return
            }
            config(model: model)
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        background.setGradientBackgroundColor(
            colors: [
                UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor,
                UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
            ],
            startPoint: startPoint,
            endPoint: endPoint
        )
    }

    /// configure offer card view with model
    /// - Parameter model: data model to configure the view
    public func config(model: SeasonalOffersCardModel) {
        self.model = model
        self.seasonalOfferMode = model.type

        if let url = URL(string: model.backgroundImageURL) {
            background.download(from: url, placeholder: VFGFrameworkAsset.Image.placeholder)
        }

        setupView(mode: seasonalOfferMode, model: model)
    }

    private func setupView(mode: VFGSeasonalOfferMode?, model: SeasonalOffersCardModel) {
        seasonalOfferMode = mode
        offerContentView.removeSubviews()
        removeShimmerView()

        switch mode {
        case .active:
            guard let cardView: ActiveSeasonalOfferCard = UIView.loadXib(bundle: Bundle.mva10Framework) else { return }
            cardView.config(model: model)
            cardView.delegate = self
            offerContentView.embed(view: cardView)
        default:
            guard let cardView: InactiveSeasonalOfferCard = UIView.loadXib(bundle: Bundle.mva10Framework) else {
                return
            }
            cardView.config(model: model)
            cardView.delegate = self
            cardView.item = item
            offerContentView.embed(view: cardView)
        }

        layoutSubviews()
    }

    public func showErrorView(
        with errorModel: VFGErrorModel,
        tryAgain completion: (() -> Void)?
    ) {
        state = .error
        errorView = .init(frame: bounds)
        offerContentView.removeSubviews()
        offerContentView.embed(view: errorView ?? UIView())
        errorView?.configure(errorModel: errorModel) { [weak self] in
            self?.state = .loading
            completion?()
        }
    }

    func showShimmerView() {
        shimmerView = .init(frame: .zero)
        guard let shimmerView else { return }
        shimmerView.startShimmering()
        offerContentView.embed(view: shimmerView)
        offerContentView.layoutIfNeeded()
    }

    func removeErrorView() {
        errorView?.removeFromSuperview()
        errorView = nil
    }

    func removeShimmerView() {
        shimmerView?.stopShimmering()
        shimmerView?.removeFromSuperview()
        shimmerView = nil
    }
}

extension VFGSeasonalOffersCardView: SeasonalOfferCardDelegate {
    func activateSeasonalOffer() {
        guard let model = model else {
            return
        }
        setupView(mode: .active, model: model)
    }

    func inactiveSeasonalOfferClicked(cardModel: SeasonalOffersCardModel?) {
        delegate?.seasonalOfferCardClicked(cardModel: cardModel)
    }

    func activeSeasonalOfferClicked(cardModel: SeasonalOffersCardModel?) {
        delegate?.seasonalOfferCardClicked(cardModel: cardModel)
    }
}
