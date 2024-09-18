//
//  FullSpecificationsViewController.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 19/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class FullSpecificationsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var selectedDeviceFileName: String?
    var selectedDevice: String?
    let headerViewHeight: CGFloat = 60
    let footerViewHeight: CGFloat = 100

    lazy var viewModel: FullSpecificationsViewModel = {
        FullSpecificationsViewModel(
            dataProvider: FullSpecificationsDataProvider()
        )
    }()

    init() {
        super.init(nibName: "\(FullSpecificationsViewController.self)", bundle: .mva10Framework)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func initViewModel() {
        viewModel.updateLoadingStatus = { [weak self] in
            guard let self = self else {
                return
            }

            switch self.viewModel.contentState {
            case .loading:
                VFGDebugLog("loading")
            case .populated:
                self.tableView.reloadData()
            case .empty:
                VFGDebugLog("empty")
            case .error:
                VFGDebugLog("error")
            case .filtered:
                VFGDebugLog("filter")
            }
        }

        viewModel.fetchFullSpecs(from: selectedDeviceFileName, with: selectedDevice)
    }
}
