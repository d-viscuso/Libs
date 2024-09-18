//
//  VFGLoginTilesAppearance.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 08/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// An appearance protocol that manages the layout of your login tiles
/// You can customize gradient overlay, background color, title, description and CTA label font styles
public protocol VFGLoginTilesAppearance: AnyObject {
    /// Customize tiles background appearance by showing or hiding a gradient overlay over over it.
    /// - Parameters:
    ///   - view: Current login tiles view associated with the appearance.
    ///   - type: An enum of type *VFGLoginTilesType* which represents the tile type.
    /// - Returns: A boolean value which represents a flag to show or hide gradient overlay.
    func showGradientOverlay(_ view: VFGLoginTilesView, forTile type: VFGLoginTilesType) -> Bool
    /// Customize tiles background style.
    /// - Parameters:
    ///   - type: An enum of type *VFGLoginTilesType* which represents the tile type.
    ///   - view: An object of type *UIView* which represents the background for a specific tile.
    func applyBackgroundStyle(forTile type: VFGLoginTilesType, background view: UIView)
    /// Customize tile title font style.
    /// - Parameters:
    ///   - type: An enum of type *VFGLoginTilesType* which represents the tile type.
    ///   - label: An object of type *VFGLabel* which represnets the tile title.
    func applyFontStyle(forTile type: VFGLoginTilesType, withTitle label: VFGLabel)
    /// Customize tile description font style.
    /// - Parameters:
    ///   - type: An enum of type *VFGLoginTilesType* which represents the tile type.
    ///   - label: An object of type *VFGLabel* which represnets the tile description.
    func applyFontStyle(forTile type: VFGLoginTilesType, withDescription label: VFGLabel)
    /// Customize tiles button style
    /// - Parameters:
    ///   - type: An enum of type *VFGLoginTilesType* which represents the tile type.
    ///   - button: An object of type *VFGButton* which represnets the tile description.
    func applyStyle(forTile type: VFGLoginTilesType, withButton button: VFGButton)
}

public extension VFGLoginTilesAppearance {
    func showGradientOverlay(_ view: VFGLoginTilesView, forTile type: VFGLoginTilesType) -> Bool {
        return type == .first ? true : false
    }

    func applyBackgroundStyle(forTile type: VFGLoginTilesType, background view: UIView) {
        view.backgroundColor = type == .first ? .VFGVodafoneRed : .VFGWhiteBackground
    }

    func applyFontStyle(forTile type: VFGLoginTilesType, withTitle label: VFGLabel) {
        label.font = .vodafoneBold(18)
        label.textColor = type == .first ? .VFGWhiteText : .VFGPrimaryText
    }

    func applyFontStyle(forTile type: VFGLoginTilesType, withDescription label: VFGLabel) {
        label.font = .vodafoneRegular(14)
        label.textColor = type == .first ? .VFGWhiteText : .VFGPrimaryText
    }

    func applyStyle(forTile type: VFGLoginTilesType, withButton button: VFGButton) {
        button.setTitleColor(.VFGPrimaryText, for: .normal)
    }
}
