//
//  VFGSeeAllButtonViewModel.swift
//  VFGMVA10Framework
//
//  Created by Mayar Soliman, Vodafone on 21/11/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

public class VFGSeeAllButtonViewModel: VFGSeeAllProtocol {
    public var title: String?
    public var color: UIColor?
    public var shouldShowSeeAll: Bool
    public var showSeeAllAction: (() -> Void)?

    public init(
        title: String = "dashboard_discover_section_see_all_text".localized(bundle: .mva10Framework),
        color: UIColor = .VFGRedOrangeTextMva12,
        shouldShowSeeAll: Bool,
        showSeeAllAction: (() -> Void)? = nil
        ) {
        self.title = title
        self.color = color
        self.shouldShowSeeAll = shouldShowSeeAll
        self.showSeeAllAction = showSeeAllAction
    }
}
