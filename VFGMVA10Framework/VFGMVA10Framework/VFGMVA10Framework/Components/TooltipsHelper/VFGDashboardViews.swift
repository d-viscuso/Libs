//
//  VFGDashboardViews.swift
//  VFGMVA10Group
//
//  Created by Yahya Saddiq on 17/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

/// Dashboard views
public enum VFGDashboardViews {
    static let keyWindow = UIApplication.shared.keyWindow

    /// Horizontal scrolling usage cards.
    public static func usageCards(with id: String) -> UIView? {
        keyWindow?.view(withId: id)
    }

    /// Scroll usage cards action.
    public static func scrollUsageCards(with id: String) {
        guard let usageCards = (usageCards(with: id) as? UICollectionView) else {
            return
        }

        (0..<usageCards.numberOfItems(inSection: 0)).forEach { index in
            delay(Double(index)) {
                usageCards.scrollToItem(
                    at: IndexPath(item: index, section: 0),
                    at: .centeredHorizontally,
                    animated: true
                )

                // if reached last card, return back to first to card
                if index == (usageCards.numberOfItems(inSection: 0) - 1) {
                    delay(Double(1)) {
                        usageCards.setContentOffset(.zero, animated: true)
                    }
                }
            }
        }
    }
}
