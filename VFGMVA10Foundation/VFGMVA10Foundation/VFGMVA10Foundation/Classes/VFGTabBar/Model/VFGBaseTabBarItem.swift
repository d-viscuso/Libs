//
//  VFGBaseTabBarItem.swift
//  VFGMVA10Foundation
//
//  Created by Ayman Ata on 02/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// **VFGBaseTabBarItem** is a model used to initialize *UITabBarItem*.
internal struct VFGBaseTabBarItem: VFGBaseTabBarItemProtocol {
    /// Title of the tab bar item.
    public var title: String?
    /// Image of the tab bar item.
    public var image: UIImage?
    /// Selected image of the tab bar item, this image will be shown on selection.
    public var selectedImage: UIImage?
    /// Id for the tab bar item.
    public var id: String?
    /// Value of the badge on the tab bar item.
    public var badgeValue: String?

    /// Creates new instance of VFGBaseTabBarItem depending on the given parameters.
    /// - Parameters:
    ///   - title: Title of the tab bar item.
    ///   - image: Image of the tab bar item.
    ///   - id: Id for the tab bar item.
    ///   - badgeValue: Value of the badge on the tab bar item.
    ///   - selectedImage: Selected image of the tab bar item, this image will be shown on selection.
    public init(title: String?, image: UIImage?, id: String?, badgeValue: String?, selectedImage: UIImage?) {
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
        self.id = id
        self.badgeValue = badgeValue
    }
}
