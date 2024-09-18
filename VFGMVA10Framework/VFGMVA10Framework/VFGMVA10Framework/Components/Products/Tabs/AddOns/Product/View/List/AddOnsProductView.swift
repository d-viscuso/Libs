//
//  AddOnsProductView.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 4/11/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class AddOnsProductView: StackItemView<AddOnsProductModel> {
    typealias ModelType = AddOnsProductModel
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var title: VFGLabel!
    @IBOutlet weak var subTitle: VFGLabel!
    @IBOutlet weak var thumbnail: VFGImageView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .lightBackground
        contentView.configureShadow(
            offset: CGSize(
                width: 0,
                height: 2),
            radius: 6,
            opacity: 0.16)
    }

    override func setupView(with itemVM: AddOnsProductModel) {
        title.text = itemVM.title
        subTitle.text = itemVM.subTitle
        if let imageName = itemVM.imageName {
            thumbnail.image = UIImage(
                named: imageName,
                in: Bundle.mva10Framework,
                compatibleWith: nil)
        }
        setupAccessibilityLabels()
    }
}

extension AddOnsProductView {
    func setupAccessibilityLabels() {
        title.accessibilityLabel = title.text ?? ""
        subTitle.accessibilityLabel = subTitle.text ?? ""
    }
}
