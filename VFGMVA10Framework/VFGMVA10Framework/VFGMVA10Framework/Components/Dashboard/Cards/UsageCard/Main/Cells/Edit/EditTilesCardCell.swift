//
//  EditTilesCardCell.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 10/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// Dashboard usage card collection view edit card
class EditTilesCardCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: VFGLabel!
    /// *EditTilesCardCell* configuration
    public func configure() {
        titleLabel.text = "usage_card_edit_tiles_title".localized(bundle: .mva10Framework)
    }
}
