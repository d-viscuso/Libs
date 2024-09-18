//
//  ProductSwitcherEditActionModel.swift
//  VFGMVA10Framework
//
//  Created by Loodos on 11/16/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// ProductSwitcherEditActionModel
public struct ProductSwitcherEditActionModel {
    /// Title for edit view
    var title: String
    /// Subtitle for edit view
    var subtitle: String
    /// Product name to be editted
    var productName: String
    /// Confirm button text
    var confirmButtonText: String
    /// Cancel button text
    var cancelButtonText: String
    /// Title for result view
    var resultTitle: String
    /// Subtitle for result view
    var resultSubtitle: String
    /// Confirm button text
    var resultConfirmButtonText: String
    /// Title for loading view
    var loadingTitle: String
    /// Title for error result view
    var errorTitle: String
    /// Subtitle for error view
    var errorSubtitle: String
    /// Error confirm button text
    var errorConfirmButtonText: String
    /// Confirm button action for edit
    var confirmButtonAction: ((String?) -> Void)
    /// Close action
    var closeAction: (() -> Void)

    public init(
        title: String,
        subtitle: String,
        productName: String,
        confirmButtonText: String,
        cancelButtonText: String,
        resultTitle: String,
        resultSubtitle: String,
        resultConfirmButtonText: String,
        loadingTitle: String,
        errorTitle: String,
        errorSubtitle: String,
        errorConfirmButtonText: String,
        confirmButtonAction: @escaping (String?) -> Void,
        closeAction: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.productName = productName
        self.confirmButtonText = confirmButtonText
        self.cancelButtonText = cancelButtonText
        self.resultTitle = resultTitle
        self.resultSubtitle = resultSubtitle
        self.resultConfirmButtonText = resultConfirmButtonText
        self.loadingTitle = loadingTitle
        self.errorTitle = errorTitle
        self.errorSubtitle = errorSubtitle
        self.errorConfirmButtonText = errorConfirmButtonText
        self.confirmButtonAction = confirmButtonAction
        self.closeAction = closeAction
    }
}

public enum ProductSwitcherEditViewState {
    case initial
    case loading
    case success
    case error
}
