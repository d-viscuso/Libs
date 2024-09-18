//
//  MultiTabsHeaderViewModel.swift
//  VFGMVA10Foundation
//
//  Created by Moataz Akram on 12/4/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

// A struct that represents a model for multi tabs view controller header
public struct MultiTabsHeaderViewModel {
    var title: String?
    var subtitleBoldText: String?
    var subtitleRegText: String?
    var secondSubtitleText: String?
    var enableTopup: Bool?
    var enableBilling: Bool?
    var billingBtnTitle: String?
    var refreshStatusModel: VFGRefreshStatusModel?
    var hideSubtitleText: Bool
    var hideSecondSubtitleText: Bool
    var hideTitle: Bool

    /// Multi tabs header view model initializer
    /// - Parameters:
    ///   - title: Multi tabs header title
    ///   - subtitleBoldText: Multi tabs header bold subtitle text
    ///   - subtitleRegText: Multi tabs header regular subtitle text
    ///   - secondSubtitleText: Multi tabs header second subtitle text
    ///   - enableTopup: A boolean flag to show or hide top-up, default value is false
    ///   - enableBilling: A boolean flag to show or hide billing, default value is false
    ///   - billingBtnTitle: billing button title
    ///   - refreshStatusModel: Multi tabs header refresh label model
    public init(
        title: String? = "",
        subtitleBoldText: String? = "",
        subtitleRegText: String? = "",
        secondSubtitleText: String? = "",
        enableTopup: Bool? = false,
        enableBilling: Bool? = false,
        billingBtnTitle: String? = "",
        refreshStatusModel: VFGRefreshStatusModel? = VFGRefreshStatusModel(),
        hideSubtitleText: Bool = false,
        hideSecondSubtitleText: Bool = false,
        hideTitle: Bool = false
    ) {
        self.title = title
        self.subtitleBoldText = subtitleBoldText
        self.subtitleRegText = subtitleRegText
        self.secondSubtitleText = secondSubtitleText
        self.enableTopup = enableTopup
        self.enableBilling = enableBilling
        self.billingBtnTitle = billingBtnTitle
        self.refreshStatusModel = refreshStatusModel
        self.hideSubtitleText = hideSubtitleText
        self.hideSecondSubtitleText = hideSecondSubtitleText
        self.hideTitle = hideTitle
    }
}
