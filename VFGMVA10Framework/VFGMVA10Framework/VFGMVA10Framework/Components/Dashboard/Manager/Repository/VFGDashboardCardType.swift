//
//  VFGDashboardCardType.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 24/06/2021.
//

import Foundation
/// Dashboard displayed card type (dashboard, discover or none)
public enum VFGDashboardCardType: String, CaseIterable {
    case dashboard = "dashboard"
    case discover = "discover"
    case seasonalOffer = "seasonalOffer"
    case scrollableCard = "scrollableCard"
    case productsServicesCard = "productsServicesCard"
    case highlights = "highlights"
    case highlightsTopInset = "highlightsTopInset"
    case marketplace = "marketplace"
    case none = ""
}
