//
//  ScrollableCardViewModel.swift
//  VFGMVA10Framework
//
//  Created by Giovanni Romaniello on 11/07/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

// allows local markets to have complete control on card configuration
public protocol ScrollableCardConfigurator: AnyObject {
    func configure(
        cardCell: ScrollableCardItemCollectionViewCell,
        model: ScrollableCardItemModel
    )
}

public protocol ScrollableCardViewModelProtocol {
    var title: String? { get }
    var layout: ScrollableCardLayout { get }
    var numberOfCards: Int { get }
    func cardAtIndex(index: UInt) -> ScrollableCardItemModel?
    var scrollableCardConfigurator: ScrollableCardConfigurator? { get }
}

public class ScrollableCardViewModel {
    public weak var scrollableCardConfigurator: ScrollableCardConfigurator?
    public let scrollableCard: ScrollableCardModel

    public init(with model: ScrollableCardModel) {
        self.scrollableCard = model
    }
}

extension ScrollableCardViewModel: ScrollableCardViewModelProtocol {
    public var title: String? {
        scrollableCard.title
    }

    public var layout: ScrollableCardLayout {
        scrollableCard.layout ?? .large
    }

    public var numberOfCards: Int {
        scrollableCard.cards?.count ?? 0
    }

    public func cardAtIndex(index: UInt) -> ScrollableCardItemModel? {
        guard let cards = self.scrollableCard.cards,
    index < cards.count else {
    return nil
        }
        return cards[Int(index)]
    }
}
