//
//  VFGCollectionAndDeliveryDataSource.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 6/4/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

class VFGCollectionAndDeliveryDataSource: VFGSelectionViewDataSource {
    var collectionAndDelivery: [VFGDeviceModel.CollectionAndDelivery]
    var selectedIndex: Int = 0

    init(_ collectionAndDelivery: [VFGDeviceModel.CollectionAndDelivery]) {
        self.collectionAndDelivery = collectionAndDelivery
    }

    func headerTitle() -> String {
        "device_upgrade_summary_step_delivery_options".localized(bundle: .mva10Framework)
    }

    func numberOfSelections() -> Int {
        collectionAndDelivery.count
    }

    func titleForSelection(at index: Int) -> String {
        collectionAndDelivery[index].title ?? ""
    }

    func subtitleForSelection(at index: Int) -> String {
        collectionAndDelivery[index].duration ?? ""
    }

    func selectedItemSubtitleText() -> String? {
        nil
    }
}
