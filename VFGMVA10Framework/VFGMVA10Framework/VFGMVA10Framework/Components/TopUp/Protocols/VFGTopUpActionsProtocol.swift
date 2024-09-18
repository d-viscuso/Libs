//
//  VFGTopUpActionsProtocol.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 11/04/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

public protocol VFGTopUpActionsProtocol: AnyObject {
    func reloadTopUp()
    func updateState(_ newState: InitialTopUpState)
}
