//
//  ShadowView.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 30/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            configureShadow(offset: CGSize(width: 0, height: -2), radius: 3, opacity: 0.1, shouldRasterize: true)
        }
    }
}
