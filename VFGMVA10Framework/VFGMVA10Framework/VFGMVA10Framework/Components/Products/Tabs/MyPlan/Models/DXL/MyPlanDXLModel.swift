//
//  MyPlanDXLModel.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 1/5/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

// MARK: - MyPlanDXLModel
public struct MyPlanDXLModel: Codable, MyPlanModelProtocol {
    public var activePlanServices: ActivePlanServices? {
        ActivePlanServices(primaryPlan: primaryPlan)
    }

    let usageConsumptionReport: [UsageConsumptionReport]?
    let product: [Product]?

    // MARK: - Product
    struct Product: Codable {
        let id, name, startDate, terminationDate: String
        let type: String?
        let product: [Product]
        let productPrice: [ProductPrice]?
        let relatedParty: [RelatedParty]
        let status: String

        enum CodingKeys: String, CodingKey {
            case id, name, startDate, terminationDate
            case type = "@type"
            case product, productPrice, relatedParty, status
        }

        // MARK: Product
        struct Product: Codable {
            let id: String
            let name: String?
            let startDate, terminationDate: String, type: String?
            let productCharacteristic: [ProductCharacteristic]?
            let productOffering: ProductOfferingClass?
            let relatedParty: [RelatedParty]
            let status: String
            let productTerm: [ProductTerm]?
            let productRelationship: [ProductRelationship]?
            let realizingResource: [RealizingResource]?

            enum CodingKeys: String, CodingKey {
                case id, name, startDate, terminationDate
                case type = "@type"
                case
                    productCharacteristic,
                    productOffering, relatedParty, status, productTerm, productRelationship, realizingResource
            }
        }

        // MARK: ProductPrice
        struct ProductPrice: Codable {
            let priceType, recurringChargePeriod: String
            let price: Price
        }

        // MARK: Price
        struct Price: Codable {
            let dutyFreeAmount: DutyFreeAmount
        }

        // MARK: DutyFreeAmount
        struct DutyFreeAmount: Codable {
            let unit: String
            let value: Double
        }

        // MARK: ProductCharacteristic
        struct ProductCharacteristic: Codable {
            let name, value: String
        }

        // MARK: ProductOfferingClass
        struct ProductOfferingClass: Codable {
            let id: String
        }

        // MARK: ProductRelationship
        struct ProductRelationship: Codable {
            let relationshipType: String
            let product: ProductOfferingClass
        }

        // MARK: ProductTerm
        struct ProductTerm: Codable {
            let productTermDescription: String
            let validFor: ValidFor

            enum CodingKeys: String, CodingKey {
                case productTermDescription = "description"
                case validFor
            }
        }

        // MARK: ValidFor
        struct ValidFor: Codable {
            let endDateTime, startDateTime: String
        }

        // MARK: RealizingResource
        struct RealizingResource: Codable {
            let id, referredType: String

            enum CodingKeys: String, CodingKey {
                case id
                case referredType = "@referredType"
            }
        }
    }

    // MARK: - UsageConsumptionReport
    struct UsageConsumptionReport: Codable {
        let id: String?
        let serviceTitle: String?
        let serviceSubtitle: String?
        let bucket: [Bucket]
        let relatedParty: RelatedParty?
        let productTerm: [String]?

        // MARK: Bucket
        struct Bucket: Codable {
            let isShared: Bool
            let id, name, usageType: String
            let bucketCounter: [BucketCounter]
        }

        // MARK: BucketCounter
        struct BucketCounter: Codable {
            let counterType, level: String
            let value: Value?
            let valueName: String?
        }

        // MARK: Value
        struct Value: Codable {
            let amount: Float
            let units: String
        }
    }

    // MARK: - RelatedParty
    struct RelatedParty: Codable {
        let id, role: String
    }
}
