//
//  AddOnsProduct.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 4/12/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//
import Foundation

/// addOns fetched model
public struct AddOnsProducts: Codable {
    public var addOns: [AddOnsProductModel]?
    enum CodingKeys: String, CodingKey {
        case addOns
    }
}

extension AddOnsProducts: AddOnsProductsProtocol {}

/// addOns item model
public struct AddOnsProductModel: Codable {
    /// Title.
    var title: String?
    /// Identifier.
    public var identifier: String?
    /// Subtitle.
    var subTitle: String?
    /// Image name in assets.
    public var imageName: String?
    /// Product type.
    var type: String?
    /// AddOn plan detail.
    public var addOnDetails: AddOnPlanDetails?
    /// Computed property returns the addOn type.
    var addonType: String? {
        return type
    }
    var toBeRenewedProduct = false
    var expiredAndRenewedProduct = false
    var expiredProduct = false
    public var isPromoAddon = false
    public var isSellable = true

    public init(
        title: String,
        subTitle: String,
        imageName: String,
        addonType: String,
        addOnDetails: AddOnPlanDetails,
        identifier: String,
        isPromoAddon: Bool = false,
        isSellable: Bool = true
    ) {
        self.title = title
        self.subTitle = subTitle
        self.imageName = imageName
        self.type = addonType
        self.addOnDetails = addOnDetails
        self.identifier = identifier
        self.isPromoAddon = isPromoAddon
        self.isSellable = isSellable
    }
    mutating func updateDetials(_ addOnDetails: AddOnPlanDetails?) {
        self.addOnDetails = addOnDetails
    }
    enum CodingKeys: String, CodingKey {
        case title = "addOnTitle"
        case subTitle = "addOnSubTitle"
        case imageName = "addOnImageName"
        case type = "addOnType"
        case addOnDetails = "addOnPlanDetails"
        case identifier = "addOnId"
        case isPromoAddon = "isPromo"
    }
}

public enum AddOnsTypeLocalize: String {
    case all
    case passes
    case others
    case myPlan
    public var localizedString: String {
        switch self {
        case .all:
            return "shop_addons_see_all_categories".localized(bundle: .mva10Framework)
        case .passes:
            return "shop_addons_passes_categories".localized(bundle: .mva10Framework)
        case .others:
            return "shop_addons_others_categories".localized(bundle: .mva10Framework)
        case .myPlan:
            return "shop_addons_my_plan_categories".localized(bundle: .mva10Framework)
        }
    }
}

/// Renewal type.
public enum RenewalType: String, CaseIterable {
    /// Renew the add-on the day after it's expiration date.
    case directly
    /// Renew the add-on next month at the same start date.
    case monthly
}

/// AddOn plan details model.
public struct AddOnPlanDetails: Codable {
    /// Title.
    let title: String?
    /// Description.
    let description: String?
    /// Plan start date.
    var startDate: String?
    /// Plan expiration date.
    public var expirationDate: String?
    /// Price details.
    let priceDetails: String?
    /// Price.
    let price: String?
    /// Boolean determines whether the plan is renewable or not.
    var isAutoRenewable: Bool?
    /// Plan type.
    var type: String?
    /// RenewalType if *directly* or *monthly*.
    var renewalType: RenewalType? {
        return RenewalType(rawValue: type ?? "")
    }
    /// Boolean determines whether it will show or hide renew view.
    var shouldHideAutoRenewView: Bool?
    /// Boolean determines whether it will show or hide action button.
    var shouldHideActionButton: Bool?
    /// Boolean determines whether it will show or hide active indicator.
    var shouldShowActiveIndicatorView: Bool?
    /// Boolean determines whether it will show or hide expiration date.
    var shouldHideExpirationDate: Bool?
    /// Boolean determines whether the plan is active or not.
    var isActive: Bool?
    /// Active date.
    var activeDate: String?
    /// Action button title.
    var activateButtonTitle: String?
    public init(
        title: String,
        description: String,
        startDate: String,
        expirationDate: String,
        priceDetails: String,
        price: String,
        isAutoRenewable: Bool = false,
        renewalType: RenewalType = .directly,
        shouldHideAutoRenewView: Bool = false,
        shouldHideActionButton: Bool = false,
        shouldShowActiveIndicatorView: Bool = false,
        shouldHideExpirationDate: Bool = false,
        isActive: Bool = false,
        activeDate: String? = nil,
        activateButtonTitle: String? = nil
    ) {
        self.title = title
        self.description = description
        self.startDate = startDate
        self.expirationDate = expirationDate
        self.priceDetails = priceDetails
        self.price = price
        self.isAutoRenewable = isAutoRenewable
        self.type = renewalType.rawValue
        self.shouldHideAutoRenewView = shouldHideAutoRenewView
        self.shouldHideActionButton = shouldHideActionButton
        self.shouldShowActiveIndicatorView = shouldShowActiveIndicatorView
        self.shouldHideExpirationDate = shouldHideExpirationDate
        self.isActive = isActive
        self.activeDate = activeDate
        self.activateButtonTitle = activateButtonTitle
    }

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case startDate
        case expirationDate
        case priceDetails
        case price
        case isAutoRenewable
        case type = "renewalType"
    }
}
