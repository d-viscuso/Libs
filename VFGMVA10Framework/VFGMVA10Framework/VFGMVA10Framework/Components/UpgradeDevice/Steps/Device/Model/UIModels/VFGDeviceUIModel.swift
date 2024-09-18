//
//  VFGDeviceUIModel.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 19/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

enum VFGDeviceUIModel {
    case deviceImage
    case colorSelection
    case capcitySelection
    case deviceOverview
    case moreInformation
    case collectionAndDelivery
    case specifications
    case continueToNextStep
}

extension VFGDeviceUIModel: Equatable {
    static func == (lhs: VFGDeviceUIModel, rhs: VFGDeviceUIModel) -> Bool {
        switch (lhs, rhs) {
        case (.deviceImage, .deviceImage):
            return true
        case (.colorSelection, .colorSelection):
            return true
        case (.capcitySelection, .capcitySelection):
            return true
        case (.deviceOverview, .deviceOverview):
            return true
        case (.moreInformation, .moreInformation):
            return true
        case (.collectionAndDelivery, .collectionAndDelivery):
            return true
        case (.specifications, .specifications):
            return true
        case (.continueToNextStep, .continueToNextStep):
            return true
        default:
            return false
        }
    }
}

struct VFGDeviceSectionUIModel {
    var header: VFGDeviceSectionHeaderUIModel?
    var items: [VFGDeviceUIModel]

    var numberOfItems: Int {
        return items.count
    }

    subscript(index: Int) -> VFGDeviceUIModel {
        return items[index]
    }
}

extension VFGDeviceSectionUIModel {
    init(header: VFGDeviceSectionHeaderUIModel? = nil, items: VFGDeviceUIModel...) {
        self.header = header
        self.items = items
    }
}

struct VFGDeviceSectionHeaderUIModel {
    var title: String
    var logo: String
    var isCellsCollapsed = false
}
