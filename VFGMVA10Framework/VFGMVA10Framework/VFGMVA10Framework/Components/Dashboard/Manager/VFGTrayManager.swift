//
//  VFGTrayManager.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 1/8/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// Tray manager.
open class VFGTrayManager {
    /// Delegate that is responsible for opening a controller with tray items.
    public weak var delegate: VFGTrayNavigationProtocol?
    /// This model is responsible for all data of the Tray & Sub-Tray elements.
    var trayModel: VFGTrayModelProtocol?
    /// View controller of type *VFGTrayViewController*.
    var trayController: VFGTrayViewController?
    /// Delegate that is responsible for Tray actions.
    weak var trayDelegate: VFGTrayDelegate?
    /// *VFGTrayManager* intializer
    /// - Parameters:
    ///    - trayModel: This model is responsible for all data of the Tray & Sub-Tray elements
    ///    - delegate: Delegate that is responsible for opening a controller with tray items
    public init(trayModel: VFGTrayModelProtocol?, delegate: VFGTrayDelegate? = nil) {
        self.trayModel = trayModel
        trayDelegate = delegate
    }
    /// This setup method is responsible for navigating to a *VFGTrayViewController* by calling *open* method from the controller that conforms *VFGTrayNavigationProtocol*.
    open func setup(completion: ((VFGTrayModelProtocol?) -> Void)?) {
        if (trayModel is UITabBarController) == false {
            guard let trayModel = trayModel else {
                delegate?.open(with: nil, error: nil)
                completion?(nil)
                return
            }
            trayModel.trayDelegate = self
            trayController = VFGTrayViewController.instantiate(fromAppStoryboard: .trayStoryboard)
            if let tabController = trayModel as? UITabBarController {
                trayController?.embedRootController(tabController)
            }
            trayController?.trayDelegate = trayDelegate
            trayController?.subTrayItemScale = trayModel.subTrayItemScale
            trayModel.setup()
            delegate?.open(with: trayController, error: nil)
            completion?(trayModel)
        } else {
            traySetupFinished(error: nil)
            completion?(nil)
        }
    }
}

extension VFGTrayManager: VFGTrayManagerProtocol {
    public func traySetupFinished(error: Error?) {
        trayController?.trayModel = trayModel
        trayController?.trayDelegate = trayDelegate
    }

    public func updateTrayImage(with image: UIImage, at index: Int) {
        guard let trayController = trayController else { return }
        if trayController.trayItemsView.indices.contains(index) {
            trayController.trayItemsView[index].iconImageView.image = image
        }
    }
}
