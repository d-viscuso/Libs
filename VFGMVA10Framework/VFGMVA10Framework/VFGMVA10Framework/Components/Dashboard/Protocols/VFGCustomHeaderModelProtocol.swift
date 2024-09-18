//
//  VFGCustomHeaderModelProtocol.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 21/06/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// Custom header model protocol.
public protocol VFGCustomHeaderModelProtocol: AnyObject {
    /// Container for the main view above the dashboard cards.
    var headerViewContainer: UIView { get set }
    /// Container for the floating view over dashboard cards.
    var floatingViewContainer: UIView? { get set }
    /// Height for the main view.
    var headerContainerHeight: CGFloat { get set }
    /// Minimum height for the main view.
    var minHeaderContainerHeight: CGFloat { get set }
    /// Height for the floating bar view.
    var floatingContainerHeight: CGFloat? { get set }
}
