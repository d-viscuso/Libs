//
//  VFGFailureAddPlanModel.swift
//  VFGMVA10Framework
//
//  Created by Abdelrahman Elnagdy on 17/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

public class VFGFailureAddPlanModel {
    public var mainTitle: String?
    public var subTitle: String?
    public var tryAgainButtonTitle: String?
    public var cancelButtonTitle: String?

    public init (
        mainTitle: String?,
        subTitle: String?,
        tryAgainButtonTitle: String?,
        cancelButtonTitle: String? = nil
    ) {
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        self.tryAgainButtonTitle = tryAgainButtonTitle
        self.cancelButtonTitle = cancelButtonTitle
    }
}
