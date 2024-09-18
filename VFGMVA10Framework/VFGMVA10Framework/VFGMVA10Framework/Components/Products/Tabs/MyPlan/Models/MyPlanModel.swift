//
//  MyPlanModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 7/1/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// My plan model.
public struct MyPlanModel: Codable, MyPlanModelProtocol {
    public let activePlanServices: ActivePlanServices?

    public init(activePlanServices: ActivePlanServices) {
        self.activePlanServices = activePlanServices
    }

    enum CodingKeys: String, CodingKey {
        case activePlanServices = "active_plan_services"
    }
}

/// Active plan services.
public struct ActivePlanServices: Codable, ActivePlanServicesProtocol {
    public let primaryPlan: PrimaryPlanServiceProtocol?

    public init(primaryPlan: PrimaryPlanServiceProtocol?) {
        self.primaryPlan = primaryPlan
    }

    enum CodingKeys: String, CodingKey {
        case primaryPlan = "primary_plan"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        primaryPlan = try values.decode(PrimaryPlanService.self, forKey: .primaryPlan)
    }

    public func encode(to encoder: Encoder) throws {
    }
}

/// Primary plan service.
public struct PrimaryPlanService: Codable, PrimaryPlanServiceProtocol {
    public let additionalExtraInfo: [PlanExtraInfo]?
    public let additionalInclusions: [AdditionalInclusion]?
    public let extraInfo: [PlanExtraInfo]?
    public let mainInclusions: [MainInclusion]?
    public var serviceTitle: String?
    public var serviceSubtitle: String?
    public let planName: String?
    public let planPriceUnit: String?
    public let planPrice: String?
    public let planStatus: String?
    public let startDate: String?
    public let expirationDate: String?
    public var productStartDate: String?
    public var productTerminationDate: String?

    public init(
        additionalExtraInfo: [PlanExtraInfo],
        additionalInclusions: [AdditionalInclusion],
        extraInfo: [PlanExtraInfo],
        mainInclusions: [MainInclusion],
        serviceTitle: String,
        serviceSubtitle: String,
        planName: String,
        planPriceUnit: String,
        planPrice: String,
        planStatus: String,
        startDate: String,
        expirationDate: String,
        productStartDate: String,
        productTerminationDate: String
    ) {
        self.additionalExtraInfo = additionalExtraInfo
        self.additionalInclusions = additionalInclusions
        self.extraInfo = extraInfo
        self.mainInclusions = mainInclusions
        self.planName = planName
        self.planPriceUnit = planPriceUnit
        self.planPrice = planPrice
        self.planStatus = planStatus
        self.startDate = startDate
        self.expirationDate = expirationDate
        self.serviceTitle = serviceTitle
        self.serviceSubtitle = serviceSubtitle
        self.productStartDate = productStartDate
        self.productTerminationDate = productTerminationDate
    }

    enum CodingKeys: String, CodingKey {
        case additionalExtraInfo = "additional_extra_info"
        case additionalInclusions = "additional_inclusions"
        case extraInfo = "extra_info"
        case mainInclusions = "main_inclusions"
        case planName = "plan_name"
        case planPrice = "plan_price"
        case planPriceUnit = "price_unit"
        case planStatus = "plan_status"
        case startDate = "startDate"
        case expirationDate = "expirationDate"
        case productStartDate = "productStartDate"
        case productTerminationDate = "productTerminationDate"
    }
}

public struct MainInclusion: Codable {
    /// Inclusion service type *data, sms, broadband, etc*.
    public let inclusionServiceType: String?
    /// Inclusion type *limited, unlimited, informative or description*.
    public let type: String?
    /// Computed property returns Inclusion type *limited, unlimited, informative or description*.
    public var inclusionType: InclusionType? {
        return InclusionType(rawValue: type ?? "")
    }
    /// Computed property returns service type *data, sms, broadband, etc*
    public var servicesType: PrimaryServiceType? {
        return PrimaryServiceType(rawValue: inclusionServiceType ?? "")
    }
    /// Inclusion details model.
    public let inclusionDetails: InclusionDetails?
    /// Bucket name.
    public let bucketName: String?

    public init(
        inclusionServiceType: String,
        type: String,
        inclusionDetails: InclusionDetails? = nil,
        bucketName: String? = ""
    ) {
        let serviceName = PrimaryServiceType(rawValue: inclusionServiceType)?.serviceName ?? ""
        self.inclusionServiceType = inclusionServiceType
        self.type = type
        self.inclusionDetails = InclusionDetails(
            totalUsage: inclusionDetails?.totalUsage,
            remainingUsage: inclusionDetails?.remainingUsage,
            inclusionUnit: inclusionDetails?.inclusionUnit,
            addInclusionButton: "Add \(serviceName.isEmpty ? inclusionServiceType : serviceName)"
        )
        self.bucketName = bucketName
    }

    enum CodingKeys: String, CodingKey {
        case inclusionDetails = "inclusion_details"
        case inclusionServiceType = "inclusion_service_type"
        case type = "inclusion_type"
        case bucketName = "name"
    }
}

/// Inclusion details model.
public struct InclusionDetails: Codable {
    /// Total usage.
    public let totalUsage: Float?
    /// Remaining usage.
    public let remainingUsage: Float?
    /// Inclusion unit.
    public let inclusionUnit: String?
    /// Add inclusion button title.
    public let addInclusionButton: String?
    public init(
        totalUsage: Float?,
        remainingUsage: Float?,
        inclusionUnit: String?,
        addInclusionButton: String? = nil
    ) {
        self.totalUsage = totalUsage
        self.remainingUsage = remainingUsage
        self.inclusionUnit = inclusionUnit
        self.addInclusionButton = addInclusionButton
    }

    enum CodingKeys: String, CodingKey {
        case totalUsage = "total_usage"
        case remainingUsage = "remaining_usage"
        case inclusionUnit = "unit"
        case addInclusionButton = "Add_inclusion_button"
    }
}

/// Additional inclusion.
public struct AdditionalInclusion: Codable {
    /// Inclusion service type *data, sms, broadband, etc*.
    public let inclusionServiceType: String?
    /// Inclusion type *limited, unlimited, informative or description*.
    public let inclusionType: String?
    public init(
        inclusionServiceType: String,
        inclusionType: String
    ) {
        self.inclusionServiceType = inclusionServiceType
        self.inclusionType = inclusionType
    }

    enum CodingKeys: String, CodingKey {
        case inclusionServiceType = "inclusion_service_type"
        case inclusionType = "inclusion_type"
    }
}

/// Plan extra info.
public struct PlanExtraInfo: Codable {
    /// Info details.
    public let infoDetails: String?
    /// Info title.
    public let infoTitle: String?
    public init(
        infoDetails: String,
        infoTitle: String
    ) {
        self.infoDetails = infoDetails
        self.infoTitle = infoTitle
    }
    enum CodingKeys: String, CodingKey {
        case infoDetails = "info_details"
        case infoTitle = "info_title"
    }
}

public enum PrimaryServiceType: String {
    case data, voice, sms, home, upload, download, broadband, subscription, productTerms
    public var serviceIconName: String {
        switch self {
        case .data, .voice:
            return "dataSharing"
        case .sms:
            return "sms"
        case .home:
            return "icVHomeMonitor"
        case .upload:
            return "icUpload"
        case .download:
            return "icDownload"
        case .broadband:
            return "icWifiBroadband"
        case .subscription:
            return ""
        default:
            return ""
        }
    }
    public var serviceName: String {
        switch self {
        case .data:
            return "my_plan_primary_card_data".localized(bundle: Bundle.mva10Framework)
        case .voice:
            return "my_plan_primary_card_local_calls".localized(bundle: Bundle.mva10Framework)
        case .sms:
            return "my_plan_primary_card_sms".localized(bundle: Bundle.mva10Framework)
        default:
            return ""
        }
    }
}

public enum InclusionType: String {
    case limited
    case unlimited
    case informative
    case description
}
