//
//  BannerCTACardsViewProtocol.swift
//  VFGMVA10Framework
//
//  Created by İhsan Kahramanoğlu on 12/27/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// BannerCTACardsViewProtocol
public protocol BannerCTACardsViewProtocol: AnyObject {
    /// protocol used to customize see all button.
    var seeAllButtonProtocol: VFGSeeAllProtocol { get }
    /// A method used to get cards layout type.
    /// - Returns: An enum value which represents cards layout type, it might be *.large* or *.small*.
    func getLayoutType() -> BannerCTACardType
    /// A method used to get numbet of CTA cards.
    /// - Returns: An integer value which represents numbet of CTA cards.
    func getNumberOfCards() -> Int
    /// A method which is used to get each CTA card model for specific index path.
    /// - Parameter indexPath: An instance of type *IndexPath* which represents the current CTA index path.
    /// - Returns: An instance of type *BannerCTACardItemModel* which represents CTA card model at given index.
    func getCardModel(for indexPath: IndexPath) -> BannerCTACardItemModel?
    /// A method which is used to get CTA card delegate instance.
    /// - Returns: An instance of type *BannerCTACardDelegate* which represents CTA card delegate instance.
    func getBannerCTACardDelegate() -> BannerCTACardDelegate?
}

/// A protocol used to configure horizontal scrollable cards tracking data.
public protocol HorizontalScrollableCardsTrackingProtocol: AnyObject {
    /// A function that is invoked when the user swipe cards.
    ///  - Parameters:-
    ///    - currentPosition: position of the card the user is swiping from.
    ///    - destinationPosition: position of the card the user is swiping to.
    func trackHorizontalScrolling(currentPosition: Int, destinationPosition: Int)
}
