//
//  MultiTabsHeaderViewProtocol.swift
//  VFGMVA10Foundation
//
//  Created by Moataz Akram on 05/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Conform this protocol when you want to provide your *customHeaderView* in *VFGMultiTabsViewController* 
public protocol MultiTabsHeaderViewProtocol: VFGRefreshViewProtocol {
    var refreshManager: VFGRefreshManager? { get set }
    var delegate: (MultiTabsHeaderViewDelegate & VFGRefreshViewDelegate)? { get set }
    func configure(with viewModel: MultiTabsHeaderViewModel?)
    func updateSubtitle(text: String)
    func refreshButtonPressed(_ sender: Any)
    func topUpButtonPressed(_ sender: Any)
}

extension MultiTabsHeaderViewProtocol {
    func configure(with viewModel: MultiTabsHeaderViewModel?) {}
    func refreshButtonPressed(_ sender: Any) {}
    func topUpButtonPressed(_ sender: Any) {}
}
