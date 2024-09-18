//
//  VFGTrayItemProtocol.swift
//  VFGMVA10Group
//
//  Created by Sandra Morcos on 8/8/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
public protocol VFGTrayItemProtocol: AnyObject {
    var subTrayViewModel: VFGSubTrayViewModelProtocol { get }
    var itemModel: VFGTrayItemModel { get }
    var subtrayView: VFGSubtrayViewProtocol? { get }
    var screenForItem: UIViewController? { get }

    init(_ trayItem: VFGTrayItemModel)
}
