//
//  VFGSuccessAddPlanModel.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 05/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

public class VFGSuccessAddPlanModel {
    public var mainTitle: String?
    public var subTitle: String?
    public var buttonTitle: String?

    public init (
        mainTitle: String?,
        subTitle: String?,
        buttonTitle: String?
    ) {
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        self.buttonTitle = buttonTitle
    }
}
