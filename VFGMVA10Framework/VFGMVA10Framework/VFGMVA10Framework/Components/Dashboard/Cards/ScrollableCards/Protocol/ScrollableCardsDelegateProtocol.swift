//
//  ScrollableCardsDelegateProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 04/08/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// Scrollable card delegate protocol
public protocol ScrollableCardsDelegateProtocol {
    /// A method used to return a dictionary of each action key and its action
    func bannersActions() -> [String: () -> Void]
}
