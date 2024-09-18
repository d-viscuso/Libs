//
//  VFGBarringDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Trachani, Vasiliki, Vodafone on 18/5/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
/// Barring data provider protocol.
public protocol VFGBarringDataProviderProtocol {
    /// Responsible for handling the result of fetching permissions data
    /// - Parameters:
    ///    - completion: Optional closure to perform actions after fetching data is finished
    func fetchBarringDetails(completion: @escaping ([VFGBarringItemViewModel]?, Error?) -> Void)
}
