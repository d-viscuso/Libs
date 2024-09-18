//
//  VFCheckItemViewModel.swift
//  VFGMVA10Group
//
//  Created by Sandra Morcos on 3/24/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
class VFCheckItemViewModel {
    var willExpand = false
    var wasExpanded = false
    var status: EIOStatus {
        didSet {
            if status == .failed, subItems != nil {
                willExpand = true
            }
        }
    }
    var title: String?
    var subItems: [EverythingIsOkSubItem]?
    var checkId: String?
    var icon: String?
    var oldStatus: EIOStatus?
    var isClicked: Bool?

    init(checkModel: CheckItem) {
        checkId = checkModel.itemId
        subItems = checkModel.subItems
        title = checkModel.title
        status = checkModel.status ?? EIOStatus.inProgress
        willExpand = status == .failed
        icon = checkModel.icon
    }
}
