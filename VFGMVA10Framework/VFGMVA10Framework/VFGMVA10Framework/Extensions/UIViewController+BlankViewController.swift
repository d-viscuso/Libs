//
//  UIViewController+BlankViewController.swift
//  VFGMVA10Group
//
//  Created by Mohamed Abd ElNasser on 9/24/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

public extension UIViewController {
    class func blankViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .lightGray
        let backButton = VFGButton(frame: CGRect(
            x: 0,
            y: UIApplication.shared.statusBarFrameValue?.height ?? 0,
            width: 50,
            height: 50))
        backButton.setImage(
            VFGFrameworkAsset.Image.icArrowLeftWhite,
            for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        viewController.view.addSubview(backButton)

        return viewController
    }

    @objc class func backButtonAction() {
        UIApplication.shared.topMostNavigationController?.popViewController(animated: true)
    }
}
