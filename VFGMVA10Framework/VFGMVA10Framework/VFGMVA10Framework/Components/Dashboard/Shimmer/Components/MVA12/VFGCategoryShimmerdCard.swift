//
//  VFGCategoryShimmerdCard.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 09/10/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Dashboard Category card shimmer entry
class VFGCategoryShimmerdCard: NSObject, VFGComponentEntry {
    var view: VFGCategoriesView?
    required init(config: [String: Any]?, error: [String: Any]?) {}

    var cardView: UIView? {
        view = VFGCategoriesView.loadXib(bundle: .mva10Framework)
        view?.state = .loading
        return view
    }

    var cardEntryViewController: UIViewController? {
        nil
    }
}
