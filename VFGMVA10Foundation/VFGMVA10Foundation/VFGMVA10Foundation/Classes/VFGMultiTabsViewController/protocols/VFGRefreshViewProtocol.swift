//
//  VFGRefreshViewProtocol.swift
//  VFGMVA10Foundation
//
//  Created by Moataz Akram on 05/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// A protocol that manages the labels and the refresh button of the refresh view
public protocol VFGRefreshViewProtocol: UIView {
    /// A button that executes the refresh action in response to user interactions
    var refreshButton: VFGButton? { get }
    /// A label that shows the time of last update triggered
    var lastUpdatedLabel: VFGLabel? { get }
}

extension VFGRefreshViewProtocol {
    public var refreshButton: VFGButton? {
        VFGButton()
    }
    public var lastUpdatedLabel: VFGLabel? {
        VFGLabel()
    }
}

/// A delegate protocol manages user interactions with the refresh view's contents,
/// including refresh button press
public protocol VFGRefreshViewDelegate: AnyObject {
    /// A method invoked after the refresh button pressed
    func refreshButtonDidPress()
}
