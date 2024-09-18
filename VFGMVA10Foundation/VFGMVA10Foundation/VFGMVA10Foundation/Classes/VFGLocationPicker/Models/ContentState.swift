//
//  ContentState.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed AbdElnabi on 31/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// An enum which is used to handle which content to show in a given state.
public enum ContentState {
    case loading
    case error
    case empty
    case populated
}
