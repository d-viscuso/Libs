//
//  VFGBarringItemViewModel.swift
//  VFGMVA10Framework
//
//  Created by Trachani, Vasiliki, Vodafone on 23/5/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// Barring item view model.
public struct VFGBarringItemViewModel: Codable {
    /// ID
    var id: String?
    /// Title.
    var title: String?
    /// Description.
    var description: String?
    /// State of the toggle.
    var toggleState: Bool
    /// Keys for quick action model of ask changes permission.
    var askChangesViewModel: VFGBarringAskChangesViewModel?

    public init(
        title: String?,
        description: String?,
        toggleState: Bool,
        askChangesViewModel: VFGBarringAskChangesViewModel? = nil
    ) {
        self.title = title
        self.description = description
        self.toggleState = toggleState
        self.askChangesViewModel = askChangesViewModel
    }
}
