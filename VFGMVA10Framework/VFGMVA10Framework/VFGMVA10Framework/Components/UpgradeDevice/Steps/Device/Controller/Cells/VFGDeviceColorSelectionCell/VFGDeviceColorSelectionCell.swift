//
//  VFGDeviceColorSelectionCell.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 23/05/2021.
//

import UIKit

class VFGDeviceColorSelectionCell: UITableViewCell {
    // Outlets
    @IBOutlet weak var colorSelectionView: VFGDeviceColorSelectionView!

    // Attributes
    weak var dataSource: VFGDeviceViewModelColorsDataSource? {
        didSet {
            colorSelectionView.dataSource = dataSource
        }
    }
}
