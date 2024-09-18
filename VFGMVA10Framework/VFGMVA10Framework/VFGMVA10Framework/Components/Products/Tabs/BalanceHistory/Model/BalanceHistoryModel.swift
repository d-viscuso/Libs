//
//  BalanceHistoryModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 11/4/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// Balance history model protocol.
public protocol BalanceHistoryModelProtocol {
    /// List of balance sections.
    var balanceSections: [BalanceHistorySection]? { get }
}

extension BalanceHistoryModel: BalanceHistoryModelProtocol {}

/// Balance history model.
public struct BalanceHistoryModel: Codable {
    /// List of balance sections.
    public var balanceSections: [BalanceHistorySection]?
    /// List of balance items.
    public var balanceSectionItems: [BalanceItemDetails]?

    public enum CodingKeys: String, CodingKey {
        case balanceSectionItems = "balance_history"
    }

    public init(balanceHistory: [BalanceItemDetails]?) {
        self.balanceSectionItems = balanceHistory
    }
}

public struct BalanceHistorySection: Codable {
    public var balanceSectionItems: [BalanceItemDetails]?
    public var title: String?

    public init(
        title: String?,
        items: [BalanceItemDetails]?
    ) {
        self.title = title
        balanceSectionItems = items
    }
}

public struct BalanceItemDetails: Codable {
    public let balanceAmount: String?
    public let balanceAmountInfo: String?
    public let balanceTitle: String?
    public let balanceDescription: String?
    public var balanceDate: String?
    public var balanceType: String?
    public var balanceImage: String?
    public var balanceImageBundle: Bundle?
    public var balanceAmountColor: UIColor?

    public enum CodingKeys: String, CodingKey {
        case balanceAmount = "balance_amount"
        case balanceAmountInfo = "balance_amount_info"
        case balanceTitle = "balance_title"
        case balanceDescription = "balance_description"
        case balanceType = "balance_type"
        case balanceDate = "balance_date"
        case balanceImage = "balance_image"
    }

    public init (
        balanceAmount: String?,
        balanceAmountInfo: String?,
        balanceTitle: String?,
        balanceDescription: String?,
        balanceType: String?,
        balanceDate: String?,
        balanceImage: String?,
        balanceImageBundle: Bundle? = nil,
        balanceAmountColor: UIColor?
    ) {
        self.balanceAmount = balanceAmount
        self.balanceAmountInfo = balanceAmountInfo
        self.balanceTitle = balanceTitle
        self.balanceType = balanceType
        self.balanceDate = balanceDate
        self.balanceDescription = balanceDescription
        self.balanceImage = balanceImage
        self.balanceImageBundle = balanceImageBundle
        self.balanceAmountColor = balanceAmountColor
    }
}

public enum BalanceHistoryLocalize: String {
    case all
    case topup
    public var localizedString: String {
        switch self {
        case .all:
            return "balance_history_see_all_categories".localized(bundle: .mva10Framework)
        case .topup:
            return "my_products_header_payg_topup_button_title".localized(bundle: .mva10Framework)
        }
    }
}
