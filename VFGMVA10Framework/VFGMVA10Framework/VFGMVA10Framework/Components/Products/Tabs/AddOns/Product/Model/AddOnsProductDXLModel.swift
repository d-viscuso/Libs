//
//  AddOnsProductDXLModel.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 26/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public struct AddOnsDXLProducts: Codable {
    public let digitalProductOffering: [DigitalProductOffering]
    public let product: [Product]

    public struct DigitalProductOffering: Codable {
        let id: String?
        let name: String?
        let description: String?
        let isBundle: Bool?
        let lifecycleStatus: String?
        let isSellable: Bool?
        let isPromo: Bool?
        let attachment: [Attachment]
        let digitalTerm: [DigitalTerm]
        let digitalProductOfferingPrice: [DigitalProductOfferingPrice]
        let digitalCharacteristic: [DigitalCharacteristic]

        // MARK: Attachment
        struct Attachment: Codable {
            let isDefault: Bool
            let relatedTo: String
            let description: String
            let id: String
            let attachmentType: String
            let url: String
            let mimeType: String
        }

        // MARK: DigitalTerm
        struct DigitalTerm: Codable {
            let name: String
            let validFor: ValidFor
        }

        // MARK: ValidFor
        struct ValidFor: Codable {
            let startDateTime, endDateTime: String
        }

        // MARK: DigitalProductOfferingPrice
        struct DigitalProductOfferingPrice: Codable {
            let isDefault: Bool
            let id: String
            let priceType: String
            let recurringChargePeriodType: String
            let recurringChargePeriodLength: Int
            let price: Price
        }

        // MARK: Price
        struct Price: Codable {
            let value: Double
            let unit: String
        }

        // MARK: DigitalCharacteristic
        struct DigitalCharacteristic: Codable {
            let name: String
            let digitalCharacteristicValue: [DigitalCharacteristicValue]
        }

        // MARK: DigitalCharacteristicValue
        struct DigitalCharacteristicValue: Codable {
            let id, value: String
        }
    }

    public struct Product: Codable {
        let id: String
        let name: String?
        let startDate: String
        let terminationDate: String
        let product: [Product]

        // MARK: Product
        struct Product: Codable {
            let id: String
            let name: String
            let productCharacteristic: [ProductCharacteristic]
            let productOffering: ProductOffering
            let productPrice: [ProductPrice]
            let relatedParty: [RelatedParty]
            let status: String
        }

        // MARK: ProductCharacteristic
        struct ProductCharacteristic: Codable {
            let name, value: String
        }

        // MARK: ProductOffering
        struct ProductOffering: Codable {
            let id: String
        }

        // MARK: ProductPrice
        struct ProductPrice: Codable {
            let priceType, recurringChargePeriod: String
            let price: Price
        }

        // MARK: Price
        struct Price: Codable {
            let taxRate: Int
            let dutyFreeAmount, taxIncludedAmount: PaidAmount
        }

        // MARK: PaidAmount
        struct PaidAmount: Codable {
            let unit: String
            let value: Double
        }

        // MARK: - RelatedParty
        struct RelatedParty: Codable {
            let id, role: String
        }
    }

    enum CodingKeys: String, CodingKey {
        case digitalProductOffering
        case product
    }
}
