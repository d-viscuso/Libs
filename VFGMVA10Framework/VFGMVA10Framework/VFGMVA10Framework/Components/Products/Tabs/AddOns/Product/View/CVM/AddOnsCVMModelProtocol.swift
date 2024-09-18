//
//  AddOnsCVMModelProtocol.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 9/9/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// AddOns CVM model protocol
public protocol AddOnsCVMModelProtocol {
    /// CVM title
    var title: String? { get }
    /// CVM identifier
    var identifier: String? { get }
    /// CVM subtitle
    var subTitle: String? { get }
    /// Thumbnail image name in assents.
    var imageName: String? { get }
    /// Type
    var type: String? { get }
    /// Card name name in assents.
    var addOnCardName: String? { get }
    /// Card button title.
    var addOnButtonTitle: String? { get }
    /// CVM card description.
    var addOnDescription: String? { get }
    /// AddOns details model.
    var addOnDetails: AddOnPlanDetails? { get }
    /// Computed property returns the *type* of the model.
    var addonType: String? { get }
}

extension AddOnsCVMModelProtocol {
    /// Initial implementation of *addonType*.
    var addonType: String? {
        return type
    }
}
