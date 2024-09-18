//
//  VFGDashboardMyProductsHeaderModel.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 03/12/2020.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// Dashboard products header model.
public class VFGDashboardMyProductsHeaderModel {
    /// Image of my products button in *SectionHeader*.
    var image: UIImage?
    /// Action of my products button in *SectionHeader*.
    var buttonAction: (() -> Void)?
    /// *VFGDashboardMyProductsHeaderModel* initializer
    /// - Parameters:
    ///    - image: Image of my products button in *SectionHeader*.
    ///    - buttonAction: Action of my products button in *SectionHeader*.
    public init(image: UIImage, buttonAction: @escaping (() -> Void)) {
        self.image = image
        self.buttonAction = buttonAction
    }
}
