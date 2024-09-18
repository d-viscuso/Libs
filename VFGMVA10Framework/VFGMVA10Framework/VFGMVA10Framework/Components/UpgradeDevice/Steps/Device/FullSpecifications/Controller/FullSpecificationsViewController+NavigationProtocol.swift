//
//  FullSpecificationsViewController+NavigationProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 22/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

extension FullSpecificationsViewController: VFGNavigationControllerProtocol {
    func closeButtonDidPress() {}
    func backButtonDidPress() {
        navigationController?.dismiss(animated: true)
    }
}
