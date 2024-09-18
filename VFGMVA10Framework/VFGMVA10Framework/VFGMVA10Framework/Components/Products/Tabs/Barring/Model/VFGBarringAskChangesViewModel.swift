//
//  VFGBarringAskChangesViewModel.swift
//  VFGMVA10Framework
//
//  Created by Trachani, Vasiliki, Vodafone on 23/5/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// Barring ask changes model for QuickActionsViewController
public struct VFGBarringAskChangesViewModel: Codable {
    /// Description of quick action model.
    var description: String?
    /// Details of quick action model.
    var moreDetails: String?

    public init(description: String? = nil, moreDetails: String? = nil) {
        self.description = description
        self.moreDetails = moreDetails
    }
}
