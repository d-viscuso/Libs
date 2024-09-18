//
//  BannerCTACardsViewModel.swift
//  VFGMVA10Framework
//
//  Created by İhsan Kahramanoğlu on 12/27/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// A class which represents CTA cards view model
public class BannerCTACardsViewModel {
    // MARK: BannerCTACardsViewProtocol properties
    public var seeAllButtonProtocol: VFGSeeAllProtocol
    // MARK: Private properties
    private weak var delegate: BannerCTACardDelegate?
    private var model: BannerCTACardModel

    public init(
        model: BannerCTACardModel,
        delegate: BannerCTACardDelegate? = nil,
        seeAllButtonProtocol: VFGSeeAllProtocol = VFGSeeAllButtonViewModel(shouldShowSeeAll: false)
    ) {
        self.model = model
        self.delegate = delegate
        self.seeAllButtonProtocol = seeAllButtonProtocol
    }
}

extension BannerCTACardsViewModel: BannerCTACardsViewProtocol {
    public func getLayoutType() -> BannerCTACardType {
        return model.type
    }

    public func getNumberOfCards() -> Int {
        return model.cards.count
    }

    public func getCardModel(for indexPath: IndexPath) -> BannerCTACardItemModel? {
        guard model.cards.count > indexPath.row else { return nil }
        return model.cards[indexPath.row]
    }

    public func getBannerCTACardDelegate() -> BannerCTACardDelegate? {
        return delegate
    }
}
