//
//  UIViewController+Background.swift
//  VFGMVA10Group
//
//  Created by Sandra Morcos on 4/10/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public extension UIViewController {
    /// Method used to set the controller's background image, if the provided image nil, nothing will happen.
    /// - Parameters:
    ///    - image: Image  that will the background of the controller .
    func setBackgroundImage(image: UIImage?) {
        guard let image = image else {
            return
        }
        let imageView = VFGImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
}
