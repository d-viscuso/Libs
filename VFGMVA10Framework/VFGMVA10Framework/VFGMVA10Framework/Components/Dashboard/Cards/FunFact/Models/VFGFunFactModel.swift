//
//  VFGFunFactModel.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 09/02/2022.
//

import VFGMVA10Foundation
import UIKit
public struct VFGFunFactModel {
    public let title: String?
    public let description: String?
    public let image: UIImage?

    public init (
        title: String?,
        description: String?,
        image: UIImage?
    ) {
        self.title = title
        self.description = description
        self.image = image
    }
}
