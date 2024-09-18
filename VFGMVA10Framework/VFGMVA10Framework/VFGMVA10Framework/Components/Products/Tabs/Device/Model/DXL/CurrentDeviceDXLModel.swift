//
//  CurrentDeviceDXLModel.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 1/31/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public struct CurrentDeviceDXLModel: Codable {
    let digitalProductOffering: [DigitalProductOfferingElement]
    let product: [DigitalProductOfferingProduct]
    let recommendation: [Recommendation]

    // MARK: - DigitalProductOfferingElement
    struct DigitalProductOfferingElement: Codable {
        let id, name: String
        let isBundle: Bool
        let lifecycleStatus: String
        let isSellable: Bool
        let attachment: [Attachment]
        let category: [Category]
        let digitalProductOfferingPrice: [DigitalProductOfferingPrice]

        enum CodingKeys: String, CodingKey {
            case id, name, isBundle, lifecycleStatus, isSellable
            case attachment = "attachment "
            case category, digitalProductOfferingPrice
        }
    }

    // MARK: - Attachment
    struct Attachment: Codable {
        let isDefault: Bool
        let relatedTo, attachmentDescription, id, attachmentType: String
        let url: String
        let mimeType: String

        enum CodingKeys: String, CodingKey {
            case isDefault, relatedTo
            case attachmentDescription = "description"
            case id, attachmentType, url, mimeType
        }
    }

    // MARK: - Category
    struct Category: Codable {
        let id, categoryType: String
        let lifecycleStatus: String?
        let name: String
        let isRoot: Bool
        let parentID: String?

        enum CodingKeys: String, CodingKey {
            case id, categoryType, lifecycleStatus, name, isRoot
            case parentID = "parentId"
        }
    }

    // MARK: - DigitalProductOfferingPrice
    struct DigitalProductOfferingPrice: Codable {
        let id, priceType: String
        let price: DutyFreeAmountClass
    }

    // MARK: - DutyFreeAmountClass
    struct DutyFreeAmountClass: Codable {
        let value: Double
        let unit: String
    }

    // MARK: - DigitalProductOfferingProduct
    struct DigitalProductOfferingProduct: Codable {
        let id, name, startDate, terminationDate: String
        let product: [ProductProduct]
        let productPrice: [ProductPrice]
        let relatedParty: [RelatedParty]
        let status: String
    }

    // MARK: - ProductProduct
    struct ProductProduct: Codable {
        let id, startDate, terminationDate, status: String
        let relatedParty: [RelatedParty]
        let productCharacteristic: [ProductCharacteristic]
        let realizingResource: [RealizingResource]
        let productOffering: ProductOffering?
        let productRelationship: [ProductRelationship]?
    }

    // MARK: - ProductCharacteristic
    struct ProductCharacteristic: Codable {
        let name, value: String
    }

    // MARK: - ProductOffering
    struct ProductOffering: Codable {
        let id, name: String
    }

    // MARK: - ProductRelationship
    struct ProductRelationship: Codable {
        let relationshipType: String
        let product: Offering
    }

    // MARK: - Offering
    struct Offering: Codable {
        let id: String
    }

    // MARK: - RealizingResource
    struct RealizingResource: Codable {
        let id, referredType: String

        enum CodingKeys: String, CodingKey {
            case id
            case referredType = "@referredType"
        }
    }

    // MARK: - RelatedParty
    struct RelatedParty: Codable {
        let id, role: String
    }

    // MARK: - ProductPrice
    struct ProductPrice: Codable {
        let priceType, recurringChargePeriod: String
        let price: ProductPricePrice
    }

    // MARK: - ProductPricePrice
    struct ProductPricePrice: Codable {
        let dutyFreeAmount: DutyFreeAmountClass
    }

    // MARK: - Recommendation
    struct Recommendation: Codable {
        let id, name: String
        let item: [Item]
    }

    // MARK: - Item
    struct Item: Codable {
        let offering: Offering
    }
}

extension CurrentDeviceDXLModel: CurrentDeviceModelProtocol {
    public var deviceDetails: DeviceDetails? {
        let isEligibleForUpgrade = digitalProductOffering.first?.isSellable
        let deviceName = digitalProductOffering.first?.name
        let contractEndDate = getDateInOrdinal(date: product.first?.terminationDate ?? "")
        let upgradePrice = "600€"
        return DeviceDetails(
            deviceOwnerDetails: product.first?.name,
            contractEndDate: contractEndDate,
            deviceName: deviceName,
            isEligableForUpgrade: isEligibleForUpgrade,
            upgradePrice: upgradePrice)
    }

    func getDateInOrdinal(date: String) -> String {
        guard let date = VFGDateHelper.getDateFromString(dateString: date) else {
            return ""
        }
        let calendar = Calendar.current
        let dateComponents = calendar.component(.day, from: date)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        guard let day = numberFormatter.string(from: dateComponents as NSNumber) else {
            return ""
        }
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "MMM yyyy"
        let dateString = "\(day) \(dateFormatter.string(from: date))"
        return dateString
    }
}
