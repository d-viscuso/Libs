//
//  AllAddOnsDXLProducts+AddOnsProductsProtocol.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 31/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

extension AllAddOnsDXLProducts: AddOnsProductsProtocol {
    public var addOns: [AddOnsProductModel]? {
        var list: [AddOnsProductModel]? = []

        eligibleProductOffering.forEach { eligibleOffer in
            let addOnTitle = eligibleOffer.name
            let addOnId = eligibleOffer.id.first?.value
            let selectedId = digitalProductOffering.first(where:) { $0.id == addOnId }
            let isPromo = digitalProductOffering.first(where:) { $0.id == addOnId }?.isPromo
            let isSellable = digitalProductOffering.first(where:) { $0.id == addOnId }?.isSellable
            let priceValue = selectedId?.digitalProductOfferingPrice.first?.price.value
            let addOnPriceString = String(format: "%.2f", priceValue ?? 0.0)
            let priceUnit = selectedId?.digitalProductOfferingPrice.first?.price.unit.moneySymbol
            let recurringPeriod = selectedId?.digitalProductOfferingPrice.first?.recurringChargePeriodType
            let addOnSubTitle = "\(addOnPriceString)\(priceUnit ?? "") \(recurringPeriod ?? "")"
            let addOnImageName = selectedId?.attachment.first(where:) { $0.relatedTo == "icon" }?.id
            let addOnType = eligibleOffer.addOnType

            let title = selectedId?.digitalCharacteristic
                .first(where:) { $0.name == "slogan" }?
                .digitalCharacteristicValue
                .first(where:) { $0.id == "slogan" }?
                .value ?? ""
            let description = selectedId?.description
            let isRenewable = selectedId?
                .digitalCharacteristic
                .first(where:) { $0.name == "renewal" }?
                .digitalCharacteristicValue
                .first(where:) { $0.id == "isAutoRenewable" }?.value ?? ""
            let startDate = selectedId?
                .digitalTerm
                .first(where:) { $0.name == "Commercial release" }?
                .validFor.startDateTime.toDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") ?? ""
            let endDate = selectedId?
                .digitalTerm.first(where:) { $0.name == "Commercial release" }?
                .validFor.endDateTime.toDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") ?? ""
            let priceDetails = selectedId?
                .digitalProductOfferingPrice
                .first(where:) { $0.id == "P1" }?.recurringChargePeriodType ?? ""
            let digitalProductPriceValue = selectedId?
                .digitalProductOfferingPrice.first?.price.value
            let priceString = String(format: "%.2f", digitalProductPriceValue ?? 0.0)
            let digitalProductPriceUnit = selectedId?
                .digitalProductOfferingPrice
                .first?.price.unit.moneySymbol
            let priceAmount = "\(priceString)\(digitalProductPriceUnit ?? "") "
            let renewalType = RenewalType(rawValue: priceDetails) ?? .monthly

            let addOnsDetails = AddOnPlanDetails(
                title: title,
                description: description ?? "",
                startDate: startDate,
                expirationDate: endDate,
                priceDetails: priceDetails,
                price: priceAmount,
                isAutoRenewable: Bool(isRenewable) ?? true,
                renewalType: renewalType)

            let addOnProduct = AddOnsProductModel(
                title: addOnTitle,
                subTitle: addOnSubTitle,
                imageName: addOnImageName ?? "socialPass",
                addonType: addOnType ?? AddOnsTypeLocalize.passes.localizedString,
                addOnDetails: addOnsDetails,
                identifier: addOnId ?? "",
                isPromoAddon: isPromo ?? false,
                isSellable: isSellable ?? true)
            list?.append(addOnProduct)
        }
        return list
    }
}
