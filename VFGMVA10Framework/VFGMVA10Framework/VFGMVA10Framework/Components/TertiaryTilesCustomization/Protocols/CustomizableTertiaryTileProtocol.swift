//
//  CustomizableTertiaryTileProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 06/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

protocol CustomizableTertiaryTileProtocol: VFGComponentEntry {
    var componentEntry: VFGComponentEntry? { get set }
    static var getCurrentComponentEntry: (() -> VFGComponentEntry.Type)? { get set }
}

extension CustomizableTertiaryTileProtocol {
    public var cardView: UIView? {
        return componentEntry?.cardView
    }

    public var isLocked: Bool? {
        return componentEntry?.isLocked
    }

    public var lockedCardView: UIView? {
        return componentEntry?.lockedCardView
    }

    public var cardEntryViewController: UIViewController? {
        return componentEntry?.cardEntryViewController
    }

    public func didSelectCard() {
        componentEntry?.didSelectCard()
    }

    public func willDisplay() {
        componentEntry?.willDisplay()
    }

    public func didEndDisplay() {
        componentEntry?.didEndDisplay()
    }

    public func didScroll(percentage: CGFloat) {
        componentEntry?.didScroll(percentage: percentage)
    }
}
