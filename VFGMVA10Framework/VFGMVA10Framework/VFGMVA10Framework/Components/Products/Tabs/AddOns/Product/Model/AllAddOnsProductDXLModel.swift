//
//  AllAddOnsProductDXLModel.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 31/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public struct AllAddOnsDXLProducts: Codable {
    let eligibleProductOffering: [EligibleProductOffering]
    let digitalProductOffering: [AddOnsDXLProducts.DigitalProductOffering]

    // MARK: - EligibleProductOffering
    struct EligibleProductOffering: Codable {
        let id: [IdArray]
        let name, type, status: String
        let parts: Parts
        var addOnType: String? {
            return type
        }
        // MARK: - IdArray
        struct IdArray: Codable {
            let value: String
        }
        // MARK: - Parts
        struct Parts: Codable {
            let customerAccount, subscription: CustomerAccount
        }
        // MARK: - CustomerAccount
        struct CustomerAccount: Codable {
            let id: [IdArray]
        }
    }

    enum CodingKeys: String, CodingKey {
        case eligibleProductOffering
        case digitalProductOffering
    }
}
