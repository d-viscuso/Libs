//
//  VFGSubTrayDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 7/14/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Protocol for fetching sub tray data
public protocol VFGSubTrayDataProviderProtocol: AnyObject {
    /// Perform API request to fetch sub tray data
    /// - Parameters:
    ///    - subTrayID: Id for sub tray to fetch its data
    ///    - completion: A closure for sub tray view data fetch whether it succeeded or not
    func requestData(
        with subTrayID: String,
        completion: @escaping (Result<VFGSubTrayModel, Error>) -> Void
    )
}
