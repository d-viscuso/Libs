//
//  VFGUpgradePlanModel.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 5/19/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

// MARK: - VFGUpgradePlanModel
public struct VFGUpgradePlanModel: Codable {
    let currentPlan: Plan
    let otherPlans: [Plan]
    public struct Plan: Codable {
        let id, name: String
        let imageURL: String?
        let price: Price?
        let subscriptions: [Subscription]?
        let isRecommended: Bool?

        enum CodingKeys: String, CodingKey {
            case id, name
            case imageURL = "imageUrl"
            case price, subscriptions, isRecommended
        }
    }
    public struct Subscription: Codable {
        let imageURL: String

        enum CodingKeys: String, CodingKey {
            case imageURL = "imageUrl"
        }
    }
    public struct Price: Codable {
        let recurringPrice: Int
        let recurrencePeriod: String
        let details: [Detail]
        var contractPeriod: Int?
        var currency: String?
        public struct Detail: Codable {
            let imageURL: String
            let detailDescription: String

            enum CodingKeys: String, CodingKey {
                case imageURL = "imageUrl"
                case detailDescription = "description"
            }
        }
    }
}

extension VFGUpgradePlanModel.Plan: Equatable {}

extension VFGUpgradePlanModel.Subscription: Equatable {}

extension VFGUpgradePlanModel.Price: Equatable {}

extension VFGUpgradePlanModel.Price.Detail: Equatable {}
