//
//  BalanceAndProductsModel.swift
//  VFGMVA10Framework
//
//  Created by Sandra Morcos on 11/18/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

/// Balance and Products Model.
public struct BalanceAndProductsModel: Codable, Equatable {
    /// Buckets list.
    public var bucket: [Bucket]?
    /// Eligible products list.
    public let eligibleProducts: [Product]?

    public init(bucket: [Bucket]?, eligibleProducts: [Product]?) {
        self.bucket = bucket
        self.eligibleProducts = eligibleProducts
    }

    /// Bucket model.
    public struct Bucket: Codable, Equatable {
        /// Boolean to determine if this bucket is default or not.
        public let isDefault: Bool?
        /// Boolean to determine if this bucket is shared or not.
        public let isShared: Bool?
        /// Useage type of the balance or product.
        public let usageType: String?
        /// Bucket balance list.
        public let bucketBalance: [BucketBalance]?
        /// Bucket counter list.
        public let bucketCounter: [BucketCounter]?

        public init(
            isDefault: Bool?,
            isShared: Bool?,
            usageType: String?,
            bucketBalance: [BucketBalance]?,
            bucketCounter: [BucketCounter]?
        ) {
            self.isDefault = isDefault
            self.isShared = isShared
            self.usageType = usageType
            self.bucketBalance = bucketBalance
            self.bucketCounter = bucketCounter
        }
    }

    /// Bucket balance model.
    public struct BucketBalance: Codable, Equatable {
        /// Remaining value name.
        public let remainingValueName: String?
        /// Remaing value.
        public let remainingValue: Value?
        /// Validation period.
        public let validfor: ValidityPeriod?

        public init(
            remainingValueName: String?,
            remainingValue: Value?,
            validfor: ValidityPeriod?
        ) {
            self.remainingValueName = remainingValueName
            self.remainingValue = remainingValue
            self.validfor = validfor
        }
    }

    /// Validation period model.
    public struct ValidityPeriod: Codable, Equatable {
        /// Start date time.
        public let startDateTime: String?
        /// End date time.
        public let endDateTime: String?

        public init(startDateTime: String?, endDateTime: String?) {
            self.startDateTime = startDateTime
            self.endDateTime = endDateTime
        }
    }

    /// Value model.
    public struct Value: Codable, Equatable {
        /// Value amout.
        public let amount: Double?
        /// Unit.
        public let units: String?

        public init(amount: Double?, units: String?) {
            self.amount = amount
            self.units = units
        }
    }

    /// Bucket counter model.
    public struct BucketCounter: Codable, Equatable {
        /// Counter type.
        public let counterType: String?
        /// Value name.
        public let valueName: String?
        /// Value.
        public let value: Value?

        public init(
            counterType: String?,
            valueName: String?,
            value: Value?
        ) {
            self.counterType = counterType
            self.valueName = valueName
            self.value = value
        }
    }

    public struct Product: Codable, Equatable {
        public let name: String?

        public init(name: String?) {
            self.name = name
        }
    }
}
