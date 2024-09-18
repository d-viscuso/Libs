//
//  TabAccessibilityCustomAction.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 12/04/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

class TabAccessibilityCustomAction: UIAccessibilityCustomAction {
    let indexPath: IndexPath

    init(name: String, indexPath: IndexPath, target: Any, selector: Selector) {
        self.indexPath = indexPath
        super.init(name: name, target: target, selector: selector)
    }
}
