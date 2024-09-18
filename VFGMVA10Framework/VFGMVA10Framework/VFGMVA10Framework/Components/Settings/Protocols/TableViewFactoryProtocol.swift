//
//  TableViewFactoryProtocol.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 06/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// Protocol for settings table view section actions
protocol TableViewFactoryProtocol {
    /// Return array list of settings table view sections constructors
    func buildSections() -> [TableViewSectionProtocol]
}
