//
//  SeeAllProtocol.swift
//  VFGMVA10Framework
//
//  Created by Giovanni Romaniello on 07/10/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

public protocol VFGSeeAllProtocol {
    var title: String? { get }
    var color: UIColor? { get }
    var shouldShowSeeAll: Bool { get }
    var showSeeAllAction: (() -> Void)? { get set }
}

extension VFGSeeAllProtocol {
    public var title: String? {
        "dashboard_discover_section_see_all_text".localized(bundle: .mva10Framework)
    }

    public var color: UIColor? {
        .VFGRedOrangeTextMva12
    }
}
