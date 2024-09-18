//
//  VFGAddressDataSource.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 6/4/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

class VFGAddressDataSource: VFGSelectionViewDataSource {
    var addresses: [VFGAddressModel] = []
    var selectedIndex: Int = 0

    init() {
        if let myAddress = VFGMyAddressManager.myAddress {
            addresses = [myAddress]
        }
    }

    func headerTitle() -> String {
        "device_upgrade_summary_step_delivery_address".localized(bundle: .mva10Framework)
    }

    func numberOfSelections() -> Int {
        addresses.count
    }

    func titleForSelection(at index: Int) -> String {
        "Home"
    }

    func subtitleForSelection(at index: Int) -> String {
        addresses[index].streetName
    }

    func selectedItemSubtitleText() -> String? {
        nil
    }
}
