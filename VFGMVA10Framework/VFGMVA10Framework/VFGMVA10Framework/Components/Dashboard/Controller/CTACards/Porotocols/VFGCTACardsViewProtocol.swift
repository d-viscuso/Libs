//
//  VFGCTACardsViewProtocol.swift
//  VFGMVA10Framework
//
//  Created by İhsan Kahramanoğlu on 1/16/23.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import Foundation

/// VFGCTACardsViewProtocol
public protocol VFGCTACardsViewProtocol: AnyObject {
    /// A string instance which represents overlay description.
    var descriptionText: String { get set }
    /// A method used to change current card model with a given one.
    /// - Parameter cardModel: An instance of type *BannerCTACardModel* which represents specific CTA card model.
    func changeCardModel(with cardModel: BannerCTACardModel)
    /// A method which is used to get CTA card delegate instance.
    /// - Returns: An instance of type *BannerCTACardDelegate* which represents CTA card delegate instance.
    func getBannerCTACardDelegate() -> BannerCTACardDelegate?
    /// A method used to get cards layout type.
    /// - Returns: An enum value which represents cards layout type, it might be *.large* or *.small*.
    func getLayoutType() -> BannerCTACardType
    /// A method used to get numbet of CTA cards.
    /// - Returns: An integer value which represents numbet of CTA cards.
    func getNumberOfCards() -> Int
    /// A method which is used to get each CTA card model for specific index path.
    /// - Parameter indexPath: An instance of type *IndexPath* which represents the current CTA index path.
    /// - Returns: An instance of type *BannerCTACardItemModel* which represents CTA card model at given index.
    func getCardItem(for indexPath: IndexPath) -> BannerCTACardItemModel?
}
