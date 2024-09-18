//
//  VFGDeviceViewModelProtocol.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 20/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

protocol VFGDeviceViewModelDeviceDataSource: AnyObject {
    var selectedDevice: ChooseDeviceModel.Device? { get }
}

protocol VFGDeviceViewModelColorsDataSource: VFGDeviceViewModelDeviceDataSource {
    var selectedColor: ChooseDeviceModel.Device.Color? { get set }
    func numberOfColors() -> Int
    func color(at index: Int) -> ChooseDeviceModel.Device.Color
}

protocol VFGSelectionViewDataSource: AnyObject {
    var selectedIndex: Int { get set }

    func headerTitle() -> String
    func numberOfSelections() -> Int
    func titleForSelection(at index: Int) -> String
    func subtitleForSelection(at index: Int) -> String
    func selectedItemSubtitleText() -> String?
}

protocol VFGViewModelCollectionAndDeliveryDataSource: AnyObject {
    var selectedCollectionAndDelivery: VFGDeviceModel.CollectionAndDelivery? { get set }
    func numberOfCollectionAndDelivery() -> Int
    func collectionAndDelivery(at index: Int) -> VFGDeviceModel.CollectionAndDelivery
}

protocol VFGDeviceViewModelSpecificationsDataSource: AnyObject {
    var boxDetails: [String]? { get }
    func numberOfSpecifications() -> Int
    func specification(at index: Int) -> ChooseDeviceModel.Device.Specifications.QuickSpec?
}
