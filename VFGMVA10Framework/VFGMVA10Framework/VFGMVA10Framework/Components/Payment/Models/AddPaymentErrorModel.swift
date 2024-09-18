//
//  AddPaymentErrorModel.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 9/28/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// Add payment error model.
public struct AddPaymentErrorModel {
    /// Title.
    let title: String
    /// Description.
    let desc: String
    /// Button title.
    let buttonTitle: String
    /// Boolean that determines whether to enable or disable action button.
    let shouldRetryAction: Bool

    public init(
        title: String,
        desc: String,
        buttonTitle: String,
        shouldRetryAction: Bool
    ) {
        self.title = title
        self.desc = desc
        self.buttonTitle = buttonTitle
        self.shouldRetryAction = shouldRetryAction
    }
}
