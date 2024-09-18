//
//  ProductsHeaderViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 11/10/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// Products header view's model.
public struct ProductsHeaderViewModel {
    /// Title.
    public var title: String?
    /// Balance value.
    public var balanceValue: String?
    /// Balance text.
    public var balanceText: String?
    /// BalanceTextColor.
    public var balanceTextColor: UIColor?
    /// Phone number.
    public var phoneNumber: String?
    /// Boolean to determine if the topUp button will appear or not.
    public var enableTopup: Bool?
    /// Boolean to determine if the billing button will appear or not, default is false.
    public var enableBilling: Bool?
    /// Boolean to determine if the refresh button will appear or not, default is true.
    public var enableRefresh: Bool?
    /// Billing button title.
    public var billingBtnTitle: String?
    /// TopUp button title.
    public var topUpBtnTitle: String?
    /// User Profile.
    public var isUserProfile: Bool?
    /// Profile Details.
    public var isProfileDetails: Bool?
    /// SimExpiredDate.
    public var simExpiredDate: String?
    /// TopUpMoveBottom.
    public var topUpMoveBottom: Bool?
    /// isSimIconShowed.
    public var shouldShowSimIcon: Bool?

    /// Public Init.
    public init(
        title: String?,
        balanceValue: String?,
        balanceText: String?,
        balanceTextColor: UIColor? = nil,
        phoneNumber: String?,
        enableTopup: Bool?,
        enableBilling: Bool? = false,
        enableRefresh: Bool? = false,
        billingBtnTitle: String? = "",
        isUserProfile: Bool? = false,
        isProfileDetails: Bool? = false,
        topUpBtnTitle: String? = nil,
        simExpiredDate: String? = nil,
        topUpMoveBottom: Bool? = false,
        shouldShowSimIcon: Bool? = false
    ) {
        self.title = title
        self.balanceValue = balanceValue
        self.balanceText = balanceText
        self.balanceTextColor = balanceTextColor
        self.phoneNumber = phoneNumber
        self.enableTopup = enableTopup
        self.enableBilling = enableBilling
        self.enableRefresh = enableRefresh
        self.billingBtnTitle = billingBtnTitle
        self.topUpBtnTitle = topUpBtnTitle
        self.isProfileDetails = isProfileDetails
        self.isUserProfile = isUserProfile
        self.simExpiredDate = simExpiredDate
        self.topUpMoveBottom = topUpMoveBottom
        self.shouldShowSimIcon = shouldShowSimIcon
    }
}
