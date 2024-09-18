//
//  MyPlanDXLModel+ActivePlanServicesProtocol.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 1/5/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

enum UsageTypes: String {
    case data
    case voice
    case sms
    case home
    case download
    case upload
    case broadband
    case subscription
}

extension MyPlanDXLModel: PrimaryPlanServiceProtocol, ActivePlanServicesProtocol {
    public var serviceTitle: String? {
        usageConsumptionReport?.first?.serviceTitle
    }

    public var serviceSubtitle: String? {
        usageConsumptionReport?.first?.serviceSubtitle
    }

    public var primaryPlan: PrimaryPlanServiceProtocol? {
        self
    }

    private var mobileProduct: MyPlanDXLModel.Product? {
        product?.first
    }

    private var mobilePlan: MyPlanDXLModel.Product.Product? {
        mobileProduct?.product
            .first { $0.productCharacteristic?
                .first { $0.name == "type" }?.value == Constants.ProductsAndServices
                .MyPlan.Kind.mobilePlan
            }
    }

    public var additionalExtraInfo: [PlanExtraInfo]? {
        var allExtraInfo: [PlanExtraInfo] = []

        if let minimumTermEndDateTime = mobilePlan?.productTerm?.first(
            where: { $0.productTermDescription == Constants.ProductsAndServices.MyPlan.Description.minimumTerm })?
            .validFor.endDateTime,
            let minimumTermEndDate = minimumTermEndDateTime.toDate() {
            allExtraInfo.append(PlanExtraInfo(
                infoDetails: minimumTermEndDate,
                infoTitle: "my_plan_primary_card_minimum_term_end_label".localized(bundle: .mva10Framework)))
        }

        if let eligibleToUpgradeFromDateTime = mobilePlan?.productTerm?.first(
            where: {
                $0.productTermDescription == Constants.ProductsAndServices.MyPlan.Description.upgradeEligibility
            })?
            .validFor.startDateTime,
            let eligibleToUpgradeFromDate = eligibleToUpgradeFromDateTime.toDate() {
            allExtraInfo.append(PlanExtraInfo(
                infoDetails: eligibleToUpgradeFromDate,
                infoTitle: "my_plan_primary_card_upgrade_start_label".localized(bundle: .mva10Framework)))
        }

        let simDetails = mobileProduct?.product.first {
            $0.type == Constants.ProductsAndServices.MyPlan.Kind.simDetails
        }

        if let simCardNumber = simDetails?.realizingResource?.first(
            where: { $0.referredType == "SIM card" })?.id {
            allExtraInfo.append(PlanExtraInfo(
                infoDetails: simCardNumber,
                infoTitle: "my_plan_primary_card_sim_number_label".localized(bundle: .mva10Framework)))
        }

        if let pukCode = simDetails?.productCharacteristic?.first(
            where: { $0.name == "PUK" })?.value {
            allExtraInfo.append(PlanExtraInfo(
                infoDetails: pukCode,
                infoTitle: "my_plan_primary_card_puk_code_label".localized(bundle: .mva10Framework)))
        }

        return allExtraInfo
    }

    public var additionalInclusions: [AdditionalInclusion]? {
        nil
    }

    public var extraInfo: [PlanExtraInfo]? {
        var list: [PlanExtraInfo] = []

        if let startDate = mobileProduct?.startDate.toDate() {
            list.append(
                PlanExtraInfo(
                infoDetails: startDate,
                infoTitle: String(
                    "my_plan_primary_card_renewal_date_label".localized(bundle: .mva10Framework).dropLast(5))
            )
            )
        }

        if let expirationDate = mobileProduct?.terminationDate.toDate() {
            list.append(PlanExtraInfo(
                infoDetails: expirationDate,
                infoTitle: "my_plan_primary_card_contract_end_label".localized(bundle: .mva10Framework)))
        }

        return list
    }

    public var mainInclusions: [MainInclusion]? {
        var allInclusions: [MainInclusion] = []
        let mainInclusions = getMainInclusions()
        let termsMainInclusions = getProductMainInclusions()
        if usageConsumptionReport?.first?.bucket
            .first?.usageType == PrimaryServiceType.subscription.rawValue {
            allInclusions.append(contentsOf: mainInclusions ?? [])
        } else {
            allInclusions.append(contentsOf: mainInclusions ?? [])
            allInclusions.append(contentsOf: termsMainInclusions ?? [])
        }

        return allInclusions
    }

    func getMainInclusions() -> [MainInclusion]? {
        var allInclusions: [MainInclusion] = []
        usageConsumptionReport?.first?.bucket.forEach { usageItem in
            switch usageItem.usageType {
            case UsageTypes.data.rawValue, UsageTypes.voice.rawValue, UsageTypes.sms.rawValue:
                if let units = usageItem.bucketCounter.first?.value?.units,
                let totalAmount = usageItem.bucketCounter.first(where: { $0.counterType == "global" })?.value?.amount,
                let usedAmount = usageItem.bucketCounter.first(where: { $0.counterType == "used" })?.value?.amount {
                    let details = InclusionDetails(
                        totalUsage: totalAmount,
                        remainingUsage: totalAmount - usedAmount,
                        inclusionUnit: units)

                    allInclusions.append(
                        MainInclusion(
                            inclusionServiceType: usageItem.usageType,
                            type: InclusionType.limited.rawValue,
                            inclusionDetails: details
                        )
                    )
                } else {
                    allInclusions.append(
                        MainInclusion(
                            inclusionServiceType: usageItem.usageType,
                            type: InclusionType.unlimited.rawValue
                        )
                    )
                }
            case UsageTypes.download.rawValue, UsageTypes.upload.rawValue, UsageTypes.broadband.rawValue:
                if let units = usageItem.bucketCounter.first?.value?.units,
                let totalAmount = usageItem.bucketCounter.first?.value?.amount {
                    let details = InclusionDetails(
                        totalUsage: totalAmount,
                        remainingUsage: .zero,
                        inclusionUnit: units)

                    allInclusions.append(
                        MainInclusion(
                            inclusionServiceType: usageItem.usageType,
                            type: InclusionType.informative.rawValue,
                            inclusionDetails: details,
                            bucketName: usageItem.name
                        )
                    )
                } else if let valueName = usageItem.bucketCounter.first?.valueName {
                    let details = InclusionDetails(
                        totalUsage: .zero,
                        remainingUsage: .zero,
                        inclusionUnit: valueName)

                    allInclusions.append(
                        MainInclusion(
                            inclusionServiceType: usageItem.usageType,
                            type: InclusionType.informative.rawValue,
                            inclusionDetails: details,
                            bucketName: usageItem.name
                        )
                    )
                } else {
                    allInclusions.append(
                        MainInclusion(
                            inclusionServiceType: usageItem.usageType,
                            type: InclusionType.informative.rawValue,
                            bucketName: usageItem.name)
                    )
                }
            default:
                allInclusions.append(
                    MainInclusion(
                        inclusionServiceType: usageItem.usageType,
                        type: InclusionType.informative.rawValue,
                        bucketName: usageItem.name)
                )
            }
        }
        return allInclusions
    }
    func getProductMainInclusions() -> [MainInclusion]? {
        var allInclusions: [MainInclusion] = []
        usageConsumptionReport?.first?.productTerm?.forEach { term in
            allInclusions.append(
                MainInclusion(
                    inclusionServiceType: "productTerms",
                    type: InclusionType.description.rawValue,
                    bucketName: term)
            )
        }
        return allInclusions
    }

    public var planName: String? {
        return mobileProduct?.product.first?.name
    }

    public var productStartDate: String? {
        return mobileProduct?.product.first?.startDate
    }

    public var productTerminationDate: String? {
        return mobileProduct?.product.first?.terminationDate
    }

    public var planPriceUnit: String? {
        guard let unit = mobileProduct?.productPrice?.first?.price.dutyFreeAmount.unit else {
            return nil
        }

        return unit.currencySymbol
    }

    public var planPrice: String? {
        guard let value = mobileProduct?.productPrice?.first?.price.dutyFreeAmount.value else {
            return ""
        }
        return "\(String(format: "%.2f", value))"
    }

    public var planStatus: String? {
        mobileProduct?.status.capitalized
    }

    public var startDate: String? {
        mobileProduct?.startDate
    }

    public var expirationDate: String? {
        mobileProduct?.terminationDate
    }
}
