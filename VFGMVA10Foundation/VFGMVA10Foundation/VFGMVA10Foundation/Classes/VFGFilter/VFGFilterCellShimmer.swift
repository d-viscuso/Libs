//
//  VFGFilterCellShimmer.swift
//  VFGMVA10Foundation
//
//  Created by Hussien Gamal Mohammed on 18/11/2020.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// A cell that used to show loading filter item
class VFGFilterCellShimmer: UICollectionViewCell {
    @IBOutlet var shimmerdView: VFGShimmerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        roundCorners(cornerRadius: 17)
    }
    /// show loading
    func startShimmer() {
        shimmerdView.startAnimation()
    }
    /// hide loading 
    func stopShimmer() {
        removeFromSuperview()
    }
}
