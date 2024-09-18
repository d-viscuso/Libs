//
//  VFGMyOrdersManager.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 02/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Manager of my orders journey
public class VFGMyOrdersManager {
    /// Static instance of *VFGMyOrdersManager*
    public static var shared = VFGMyOrdersManager()
    /// An instance of *VFGMyOrdersDataProviderProtocol*
    public var dataProvider: VFGMyOrdersDataProviderProtocol?
    /// An instance of *StepsCardModel*
    public var stepModel: StepsCardModel?
    /// Logged in account name
    public var accountName: String?

    private init() { }
    /// Return *InProgressOrdersViewController*
    public func inProgressOrdersController() -> InProgressOrdersViewController {
        let viewModel = InProgressOrdersViewModel(dataProvider: dataProvider)
        let inProgressOrdersViewController = InProgressOrdersViewController.init(
            nibName: String(describing: InProgressOrdersViewController.self),
            bundle: .mva10Framework)
        inProgressOrdersViewController.viewModel = viewModel
        inProgressOrdersViewController.title = "my_orders_inprogress".localized(bundle: .mva10Framework)
        return inProgressOrdersViewController
    }
    /// Return *PastOrdersViewController*
    public func pastOrdersViewController() -> PastOrdersViewController {
        let viewModel = PastOrdersViewModel(dataProvider: dataProvider)
        let pastOrdersViewController = PastOrdersViewController.init(
            nibName: String(describing: PastOrdersViewController.self),
            bundle: .mva10Framework)
        pastOrdersViewController.viewModel = viewModel
        pastOrdersViewController.title = "my_orders_pastorders".localized(bundle: .mva10Framework)
        return pastOrdersViewController
    }
}
