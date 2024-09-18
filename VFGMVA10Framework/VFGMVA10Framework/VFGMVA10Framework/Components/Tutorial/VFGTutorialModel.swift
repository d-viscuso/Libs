//
//  VFGTutorialModel.swift
//  VFGMVA10Framework
//
//  Created by Hussien Gamal Mohammed on 4/14/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

struct VFGTutorialModel: VFGTutorialProtocol {
    var shouldShowCloseButton: Bool?
    var item: [VFGTutorialItemProtocol]?
    var firstButtonTitle: String?
    var secondButtonTitle: String?
    var animationFileBundle: Bundle?
    var containsVideo: Bool?
}

struct VFGTutorialItem: VFGTutorialItemProtocol {
    var title: String?
    var titleFont: UIFont?
    var description: String?
    var descriptionFont: UIFont?
    var customButtonsTitles: (primary: String?, secondary: String?)?
    var fileName: String?
    var image: UIImage?
    var startingFrame: CGFloat?
    var endingFrame: CGFloat?
}
