//
//  VFGMVA12HeaderMenuItemModelProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ihsan Kahramanoglu on 6.06.2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
/// MVA12 Dashboard header menu item protocol
public protocol VFGMVA12HeaderMenuItemModelProtocol: AnyObject {
    /// Click action for menu item on header view
    var clickAction: () -> Void { get set }
    /// Image identifier for menu item on header view it can be an assets name or URL
    var imageIdentifier: String? { get set }
    /// Badge count
    var badgeCount: Int { get set }
    /// Badge count
    var badgeId: String { get set }
    /// Badge Custom Text
    var badgeCustomText: String? { get set }
}
