//
//  VFGManageAddOnsDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 5/8/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// Data provider protocol used by container to update or remove addOn
public typealias ManageAddOnCompletion = (Error?) -> Void

/// Manage data provider protocol.
public protocol VFGManageAddOnDataProviderProtocol {
    /// A model that fills the VFGResultView
    var resultModel: VFGResultModelConfig? { get }
    /// Method to fetch all products for addOns Shop.
    /// - Parameters:
    ///     - addOn: AddOns item model.
    ///     - completion: *ManageAddOnCompletion* is atypealias for *(Error?) -> Void*
    func updateAddOnDetails(addOn: AddOnsProductModel, completion: @escaping ManageAddOnCompletion)
    /// Method to remove a specific addOn.
    /// - Parameters:
    ///     - addOnId: Chosen addOn Id.
    ///     - completion: *ManageAddOnCompletion* is atypealias for *(Error?) -> Void*
    func removeAddOn(addOnId: String, completion: @escaping ManageAddOnCompletion)
    /// Method to buy a specific addOn.
    /// - Parameters:
    ///     - addOnId: Chosen addOn Id.
    ///     - completion: *ManageAddOnCompletion* is atypealias for *(Error?) -> Void*
    func buyAddOn(addOnId: String, completion: @escaping ManageAddOnCompletion)
}

public extension VFGManageAddOnDataProviderProtocol {
    var resultModel: VFGResultModelConfig? { nil }
}

public protocol VFGResultModelConfig {
    /// Title of the result view
    var title: String { get }
    /// Desciption that is under the title
    var descriptionText: String { get }
    /// Primary button's name
    var primaryButtonTitle: String { get }
    /// Secondary button's name
    var secondaryButtonTitle: String? { get }
}
