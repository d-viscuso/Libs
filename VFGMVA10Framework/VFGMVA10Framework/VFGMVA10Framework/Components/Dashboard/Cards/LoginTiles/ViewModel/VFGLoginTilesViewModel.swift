//
//  VFGLoginTilesViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 09/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// Login tiles view model.
public class VFGLoginTilesViewModel {
    public let loginTiles: VFGLoginTilesModel

    /// Login tiles view model constructor.
    /// - Parameter loginTiles: Login tiles data.
    public init(loginTiles: VFGLoginTilesModel) {
        self.loginTiles = loginTiles
    }
}

extension VFGLoginTilesViewModel: VFGLoginTilesDataSource {
    public func loginTiles(_ view: VFGLoginTilesView) -> VFGLoginTilesModel {
        return loginTiles
    }
}
