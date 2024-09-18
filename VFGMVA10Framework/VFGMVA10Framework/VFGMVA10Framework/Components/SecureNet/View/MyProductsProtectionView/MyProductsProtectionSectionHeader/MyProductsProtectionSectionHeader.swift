//
//  MyProductsProtectionSectionHeader.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 13/03/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class MyProductsProtectionSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var headerTitle: VFGLabel!
    @IBOutlet weak var headerSubTitle: VFGLabel!

    public func setup(title: String?, subTitle: String?) {
        headerTitle.text = title ?? ""
        headerSubTitle.text = subTitle ?? ""
    }
}
