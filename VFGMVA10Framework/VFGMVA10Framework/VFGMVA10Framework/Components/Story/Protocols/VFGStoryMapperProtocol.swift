//
//  VFGStoryMapperProtocol.swift
//  VFGMVA10Framework
//
//  Created by Abdullah Soylemez on 12.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Delegate protocol for *VFGStoryMapper*
public protocol VFGStoryMapperProtocol {
    /// Fetch stories data
    /// - Parameters:
    ///    - dxlResponse: Stories data holder
    ///    - cmsResponse: Stories CMS data holder
    func createStories(
        using dxlResponse: StoriesDXLResponse?,
        cmsResponse: [StoryCMSData]?
    ) -> [Story]?
}
