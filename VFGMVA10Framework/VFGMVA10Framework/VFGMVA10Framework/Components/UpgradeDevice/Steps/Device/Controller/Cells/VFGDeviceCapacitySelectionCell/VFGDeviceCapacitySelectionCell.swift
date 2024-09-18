//
//  VFGDeviceCapacitySelectionCell.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 23/05/2021.
//

import UIKit

class VFGDeviceCapacitySelectionCell: UITableViewCell {
    @IBOutlet weak var capacitySelectionView: VFGSelectionView!

    weak var dataSource: VFGSelectionViewDataSource? {
        didSet {
            capacitySelectionView.dataSource = dataSource
        }
    }
}
