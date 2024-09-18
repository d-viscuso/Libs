//
//  VFGCVMOverlayDataSourceProtocol.swift
//  VFGMVA10Foundation
//
//  Created by Moamen Abd Elgawad on 20/02/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import UIKit

/// CVMOverlay delegate protocol.
public protocol VFGCVMOverlayDataSourceProtocol: AnyObject {
    /// your CVMOverlay custom view.
    var customView: UIView? { get }
}

public extension VFGCVMOverlayDataSourceProtocol {
    var customView: UIView? { nil }
}
