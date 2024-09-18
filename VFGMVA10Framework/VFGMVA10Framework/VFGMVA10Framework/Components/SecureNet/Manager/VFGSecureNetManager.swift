//
//  VFGSecureNetManager.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 20/02/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// Manager of secure net journey
public class VFGSecureNetManager {
    /// Static instance of *VFGSecureNetManager*
    public static var shared = VFGSecureNetManager()
    /// An instance of *VFGSecureNetDataProviderProtocol*
    public var dataProvider: VFGSecureNetDataProviderProtocol?
    /// An instance of *VFGDevicesProtectionActionsDelegate*
    public weak var myProductsProtectionDelegate: VFGMyProductsProtectionProtocol?

    private init() { }

    /// An instance of *VFGMyProductsProtectionViewModelProtocol*
    public var myProductsProtectionViewModel: VFGMyProductsProtectionViewModelProtocol?
    /// A method that is used to setup and configure secure net devices view controller
    /// - Returns: An object of type *MyProductsProtectionViewController*
    public func myProductsProtectionViewController() -> MyProductsProtectionViewController {
        let viewModel = myProductsProtectionViewModel ?? MyProductsProtectionViewModel(dataProvider: dataProvider)
        let myProductsProtectionVC = MyProductsProtectionViewController.init(
            nibName: String(describing: MyProductsProtectionViewController.self),
            bundle: .mva10Framework
        )
        myProductsProtectionVC.title = "secure_net_my_products_screen_title".localized(bundle: .mva10Framework)
        myProductsProtectionVC.viewModel = viewModel
        myProductsProtectionVC.delegate = myProductsProtectionDelegate
        return myProductsProtectionVC
    }
}
