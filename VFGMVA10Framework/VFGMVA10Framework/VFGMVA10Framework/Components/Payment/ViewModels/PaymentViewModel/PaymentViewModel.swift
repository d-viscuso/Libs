//
//  PaymentViewModel.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 8/25/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

/// Payment view model.
public class PaymentViewModel: PaymentViewModelProtocol {
    public init() {}
    public func cardBackgroundImage(at cardOfType: CardType) -> UIImage {
        switch cardOfType {
        default:
            return VFGFrameworkAsset.Image.paymentCardBackground ?? UIImage()
        }
    }

    public func cardTextColor(at cardOfType: CardType) -> UIColor {
        switch cardOfType {
        default:
            return .VFGWhiteText
        }
    }
}
