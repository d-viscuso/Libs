//
//  ProductSwitchErrorCell.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 07/02/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class ProductSwitchErrorCell: UICollectionViewCell {
    @IBOutlet weak var errorContainer: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        roundCorners(cornerRadius: 6)
    }

    func configure(errorModel: VFGErrorModel, tryAgainClosure: (() -> Void)?) {
        let errorView = VFGErrorView(error: errorModel)
        errorView.errorImageView.image = VFGFrameworkAsset.Image.warning
        errorView.configureErrorViewConstraints(imageViewTop: 72, stackSpace: 40)
        errorView.refreshingClosure = tryAgainClosure
        errorContainer.embed(view: errorView)
    }
}
