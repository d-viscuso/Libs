//
//  AddOnsViewController+AddOnsCVMProtocol.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 8/26/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension AddOnsViewController: AddOnsCVMProtocol {
    func addAction(itemVM: AddOnsCVMModelProtocol?) {
        navigateToBuyAddOn(with: itemVM)
    }
}
