//
//  HorizontalCardsModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 04/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

/// A struct which represents a model contains horizontal list of cards.
public struct HorizontalCardsModel: Codable {
    public var cards: [HorizontalCardModel]?

    public init(
        cards: [HorizontalCardModel]?
    ) {
        self.cards = cards
    }
}
