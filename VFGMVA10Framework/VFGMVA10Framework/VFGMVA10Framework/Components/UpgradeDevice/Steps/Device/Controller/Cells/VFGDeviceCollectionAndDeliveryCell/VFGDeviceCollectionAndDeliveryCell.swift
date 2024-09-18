//
//  VFGDeviceCollectionAndDeliveryCell.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 22/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

class VFGDeviceCollectionAndDeliveryCell: UITableViewCell {
    @IBOutlet weak var collectionAndDeliveryView: VFGDeviceCollectionAndDeliveryView!
    weak var dataSource: VFGViewModelCollectionAndDeliveryDataSource? {
        didSet {
            collectionAndDeliveryView.dataSource = dataSource
        }
    }
}
