//
//  PaymentViewModelProtocol.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 9/23/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

/// A viewModel protocol which handles UI logic
public protocol PaymentViewModelProtocol {
    /// Control the background image which may be depend on `CardType`
    func cardBackgroundImage(at cardOfType: CardType) -> UIImage

    /// Control text color which may be depend on `CardType`
    func cardTextColor(at cardOfType: CardType) -> UIColor
}
