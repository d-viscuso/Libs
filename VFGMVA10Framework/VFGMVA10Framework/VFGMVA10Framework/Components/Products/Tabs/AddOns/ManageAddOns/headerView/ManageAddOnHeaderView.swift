//
//  ManageAddOnHeaderView.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 5/8/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class ManageAddOnHeaderView: UIView {
    // MARK: IBoutlet
    @IBOutlet var contentView: UIView!
    @IBOutlet var gradientView: UIView!
    @IBOutlet var imageBackGroundView: VFGImageView!
    var backGroundImage: UIImage? {
        didSet {
            imageBackGroundView?.image = backGroundImage
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        contentView.frame = frame
    }

    func xibSetup() {
        if let view = loadViewFromNib(
            nibName: String("\(ManageAddOnHeaderView.self)"),
            in: Bundle.mva10Framework) {
            contentView = view
            xibSetup(contentView: contentView)
        }
    }
}
