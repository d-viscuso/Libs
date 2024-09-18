//
//  StoryGridItemView.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 18/07/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class StoryGridItemView: UIView {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: VFGImageView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var subtitleLabel: VFGLabel!

    var item: GridItemData?
    var onGridItemDidPress: ((GridItemData) -> Void)?

    func configure(with item: GridItemData) {
        self.item = item
        shadowView.configureShadow()
        containerView.layer.masksToBounds = true
        imageView.image = VFGImage(named: item.imageUrl)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }

    @IBAction func gridItemDidPress(_ sender: Any) {
        guard let item = item else { return }

        onGridItemDidPress?(item)
    }
}
