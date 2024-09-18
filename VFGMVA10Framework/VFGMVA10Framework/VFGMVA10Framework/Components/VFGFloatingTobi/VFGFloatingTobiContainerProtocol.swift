//
//  VFGFloatingTobiContainerProtocol.swift
//  VFGMVA10Foundation
//
//  Created by Ramy Nasser on 04/07/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
/// Floating Tobi container Protocol
public protocol VFGFloatingTobiContainerProtocol: AnyObject {
    /// container which contain the floating view
    var containerView: UIView? { get }
    /// boundary where floating view is draggable only inside it
    var boundaryView: UIView? { get }
    /// start tobi position in the screen
    var tobiPosition: FloatingTobiPosition { get }
    /// floating view height
    var floatingHeight: CGFloat { get }
    /// floating view width
    var floatingWidth: CGFloat { get }
    /// horizontal dragging padding
    var horizontalDraggingPadding: CGFloat { get }
    /// vertical dragging padding
    var verticalDraggingPadding: CGFloat { get }
    /// tobi face height inside the floating view
    var tobiHeight: CGFloat { get }
    /// tobi face width inside the floating view
    var tobiWidth: CGFloat { get }
}
public extension VFGFloatingTobiContainerProtocol {
    var tobiPosition: FloatingTobiPosition {
        .bottomRight
    }
    var floatingHeight: CGFloat {
        FloatingTobiConstant.floatingHeight
    }
    var floatingWidth: CGFloat {
        FloatingTobiConstant.floatingWidth
    }
    var tobiHeight: CGFloat {
        FloatingTobiConstant.tobiHeight
    }
    var tobiWidth: CGFloat {
        FloatingTobiConstant.tobiWidth
    }
    var boundaryView: UIView? {
        return containerView
    }
    var horizontalDraggingPadding: CGFloat {
        return FloatingTobiConstant.horizontalDraggingPadding
    }
    var verticalDraggingPadding: CGFloat {
        return FloatingTobiConstant.verticalDraggingPadding
    }
}
