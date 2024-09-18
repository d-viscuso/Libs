//
//  VFGBarringViewModelProtocol.swift
//  VFGMVA10Framework
//
//  Created by Trachani, Vasiliki, Vodafone on 18/5/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
/// Barring view model protocol.
public protocol VFGBarringViewModelProtocol {
    /// Completion called when view starts loading.
    var updateLoadingStatus: (() -> Void)? { get set }
    /// Content state *empty, loading, etc*.
    var contentState: VFGContentState { get }
    /// Barring details model.
    var barringDetails: [VFGBarringItemViewModel]? { get }

    /// Method to fetch barring details.
    func fetchBarringDetails()
    /// Method to calculate the number of barring list.
    func numberOfBarrings() -> Int
}
