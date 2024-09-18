//
//  AddOnsProductDXLModel+AddOnsProductsProtocol.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 31/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

extension AddOnsDXLProducts: AddOnsProductsProtocol {
    public var addOns: [AddOnsProductModel]? {
        var list: [AddOnsProductModel] = []
        product.first?.product.forEach { subProduct in
            let idSelection = digitalProductOffering.first(where :) { $0.id == subProduct.id }
            let isPromo = digitalProductOffering.first(where :) { $0.id == subProduct.id }?.isPromo
            let isSellable = digitalProductOffering.first(where :) { $0.id == subProduct.id }?.isSellable
            let productPrice = (subProduct.productPrice.first?.price.dutyFreeAmount.value ?? 0)
                + (subProduct.productPrice.first?.price.taxIncludedAmount.value ?? 0)
            let productPriceUnit = subProduct.productPrice.first?.price.taxIncludedAmount.unit.moneySymbol ?? ""
            let productPriceString = priceString(priceValue: productPrice)
            let productPriceAmount = "\(productPriceString)\(productPriceUnit)"
            let subTitlePeriod = subProduct.productPrice.first?.recurringChargePeriod
            let title = idSelection?.digitalCharacteristic
                .first(where:) { $0.name == "slogan" }?
                .digitalCharacteristicValue
                .first(where:) { $0.id == "slogan" }?
                .value ?? ""
            let isRenewable = idSelection?
                .digitalCharacteristic
                .first(where:) { $0.name == "renewal" }?
                .digitalCharacteristicValue
                .first(where:) { $0.id == "isAutoRenewable" }?.value ?? ""
            let startDate = idSelection?
                .digitalTerm
                .first(where:) { $0.name == "Commercial release" }?
                .validFor.startDateTime.toDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") ?? ""
            let endDate = idSelection?
                .digitalTerm.first(where:) { $0.name == "Commercial release" }?
                .validFor.endDateTime.toDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") ?? ""
            let priceDetails = idSelection?
                .digitalProductOfferingPrice
                .first(where:) { $0.id == "P1" }?.recurringChargePeriodType ?? ""
            let priceValue = priceString(
                priceValue: idSelection?
                    .digitalProductOfferingPrice.first?.price.value)
            let priceUnit = idSelection?
                .digitalProductOfferingPrice
                .first?.price.unit.moneySymbol
            let priceAmount = "\(priceValue)\(priceUnit ?? "") "
            let addOnTypeValue = subProduct
                .productCharacteristic
                .first(where:) { $0.name == "type" }?.value
            let addonType = addOnTypeValue
            let image = idSelection?.attachment.first(where:) { $0.relatedTo == "icon" }?.id

            let addOnsDetails = AddOnPlanDetails(
                title: title,
                description: idSelection?.description ?? "",
                startDate: startDate,
                expirationDate: endDate,
                priceDetails: priceDetails,
                price: priceAmount,
                isAutoRenewable: Bool(isRenewable) ?? true,
                renewalType: RenewalType(rawValue: priceDetails) ?? .monthly)

            let addOnProduct = AddOnsProductModel(
                title: subProduct.name,
                subTitle: "\(productPriceAmount) \(subTitlePeriod ?? "")",
                imageName: image ?? "socialPass",
                addonType: addonType ?? AddOnsTypeLocalize.passes.localizedString,
                addOnDetails: addOnsDetails,
                identifier: subProduct.id,
                isPromoAddon: isPromo ?? false,
                isSellable: isSellable ?? true)
            list.append(addOnProduct)
        }
        return list
    }

    func priceString(priceValue: Double?) -> String {
        return String(format: "%.2f", priceValue ?? 0.0)
    }
}
