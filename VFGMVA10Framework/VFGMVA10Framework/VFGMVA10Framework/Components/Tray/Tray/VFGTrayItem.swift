//
//  VFGTrayItem.swift
//  VFGMVA10Group
//
//  Created by Sandra Morcos on 8/8/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

open class VFGTrayItem: VFGTrayItemProtocol {
    /// View model that is responsible for provding the Sub-Tray elements.
    public lazy var subTrayViewModel: VFGSubTrayViewModelProtocol =
        VFGSubTrayViewModel(dataProvider: dataProvider)
    /// Tray Item Model.
    open var itemModel: VFGTrayItemModel
    /// Sub-Tray view.
    lazy public var subtrayView: VFGSubtrayViewProtocol? = {
        let refresh = { [weak self] in
            guard let self = self else {
                return
            }

            self.setupSubTray()
        }

        let subtrayView = VFGSubTrayView(
            itemModel.title ?? "",
            itemModel.subTraySubtitle ?? "",
            refresh
        )
        setupSubTray()
        return subtrayView
    }()
    open var screenForItem: UIViewController?
    var dataProvider: VFGSubTrayDataProviderProtocol?

    public required init(_ trayItem: VFGTrayItemModel) {
        self.itemModel = trayItem
    }

    public init(
        _ trayItem: VFGTrayItemModel,
        dataProvider: VFGSubTrayDataProviderProtocol? = nil
    ) {
        self.itemModel = trayItem
        self.dataProvider = dataProvider
    }

    func setupSubTray() {
        guard
            let subTrayId = itemModel.subTrayID,
            let subTrayTitle = itemModel.subTrayTitle else {
                return
        }

        // The setup is executed asynchronously to avoid infinite recursion,
        // when the subtrayManager executes the setup() synchronously
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }

            let cachedItem =
                self.subTrayViewModel.setup(
                    key: subTrayId,
                    subtrayTitle: subTrayTitle,
                    trayConfigurations: self.itemModel.trayConfigurations
                    ) { [weak self] subTray, error in
                        if subTray == nil,
                            error == nil {
                            self?.subtrayView?.informationText = self?.itemModel.subTrayEmptyTitle ?? ""
                            return
                        } else {
                            self?.subtrayView?.informationText = nil
                        }

                        if let error = error, subTray == nil {
                            self?.subtrayView?.error = error
                            return
                        }

                        self?.subtrayView?.dataModel = subTray
                }

            if let cachedItem = cachedItem {
                self.subtrayView?.dataModel = cachedItem
            }
        }
    }
}
