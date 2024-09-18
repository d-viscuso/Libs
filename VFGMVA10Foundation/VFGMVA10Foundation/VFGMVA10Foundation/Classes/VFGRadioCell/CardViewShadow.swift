//
//  CardViewShadow.swift
//  VFGMVA10Foundation
//
//  Created by Yasser Soliman on 30/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

class CardViewShadow: UIView {
    override var bounds: CGRect {
        didSet {
            configureShadow(offset: CGSize(width: 0, height: 0), radius: 4, opacity: 0.16, shouldRasterize: true)
        }
    }
}
