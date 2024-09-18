//
//  VFGTrayViewController+NavigationDelegate.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 2/13/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension VFGTrayViewController: UINavigationControllerDelegate {
    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        guard let backItem = navigationController.navigationBar.backItem else {
            tobiHelpTitleLable.text = ""
            tobiBackButton.alpha = 0
            return
        }
        tobiHelpTitleLable.text = backItem.title
        tobiBackButton.alpha = 1
    }
}
