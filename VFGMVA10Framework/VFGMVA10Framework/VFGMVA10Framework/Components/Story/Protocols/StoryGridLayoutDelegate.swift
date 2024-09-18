//
//  StoryGridLayoutDelegate.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 07/07/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

protocol StoryGridLayoutDelegate: AnyObject {
    func gridLayout(itemDidPress item: GridItemData)
}
