//
//  ShopAddOnsViewController+VFGTrayContainerProtocol.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Zaki on 03/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension ShopAddOnsViewController: VFGTrayContainerProtocol {
    public var tobiKey: String {
        "ShopAddOnsViewController"
    }

    public var trayStyle: VFGTrayStyle {
        .TOBI
    }

    public var tobiContainerVC: UIViewController? {
        return VFGManagerFramework.tobiDelegate?.helpViewController(for:
            "\(ShopAddOnsViewController.self)")
    }
}
