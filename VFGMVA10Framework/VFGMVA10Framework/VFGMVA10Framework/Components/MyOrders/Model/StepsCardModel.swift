//
//  StepsCardModel.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 19/12/2021.
//

import Foundation
/// My orders step card model
public struct StepsCardModel {
    let primaryButtonTitle: String?
    let primaryButtonAction: (() -> Void)?
    let secondaryButtonTitle: String?
    let secondaryButtonAction: (() -> Void)?
    let stepImageName: String

    public init(
        primaryButtonTitle: String? = nil,
        primaryButtonAction: (() -> Void)? = nil,
        secondaryButtonTitle: String? = nil,
        secondaryButtonAction: (() -> Void)? = nil,
        stepImageName: String
    ) {
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryButtonAction = primaryButtonAction
        self.secondaryButtonTitle = secondaryButtonTitle
        self.secondaryButtonAction = secondaryButtonAction
        self.stepImageName = stepImageName
    }
}
