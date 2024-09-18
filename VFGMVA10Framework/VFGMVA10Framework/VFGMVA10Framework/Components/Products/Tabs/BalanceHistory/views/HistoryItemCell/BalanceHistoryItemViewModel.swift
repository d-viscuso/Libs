//
//  BalanceHistoryItemViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 11/10/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// Balance history item view model.
public struct BalanceHistoryItemViewModel {
    /// Icon name in assets.
    var iconName: String?
    /// Title.
    var title: String?
    /// Description.
    var balanceDescription: String?
    /// Subtitle.
    var subtitle: String?
    /// Balance amount.
    var amount: String?
    /// Amount info.
    var amountInfo: String?
    /// Balance type.
    var balanceType: String?
    /// Icon bundle.
    var iconBundle: Bundle?
    /// Amount color.
    var amountColor: UIColor?

    public init(
        iconName: String?,
        title: String?,
        balanceDescription: String?,
        subtitle: String?,
        amount: String?,
        amountInfo: String?,
        balanceType: String?,
        iconBundle: Bundle? = nil,
        amountColor: UIColor? = nil
    ) {
        self.iconName = iconName
        self.amount = amount
        self.amountInfo = amountInfo
        self.title = title
        self.balanceDescription = balanceDescription
        self.subtitle = subtitle
        self.balanceType = balanceType
        self.iconBundle = iconBundle
        self.amountColor = amountColor
    }
}
