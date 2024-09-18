//
//  VFGTextFieldDataSource.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 5/25/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
/// Delegation protocol to change text field attributes and UI configuration
public protocol VFGTextFieldDataSource: AnyObject {
    /// Set the background color for text field
    var customBackgroundColor: UIColor? { get }
}
