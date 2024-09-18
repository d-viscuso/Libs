//
//  VFGCountdownAppearance.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed AbdElnabi on 19/06/2022.
//

import Foundation
import UIKit

public protocol VFGCountdownAppearance: AnyObject {
    /// Customize countdown separator style.
    /// - Parameters:
    ///   - view: Current countdown view associated with the appearance.
    ///   - separator: Countdown separator view.
    func applyCountdownSeparatorStyle(_ view: VFGCountdownView, for separator: UIView)
    /// Customize time numbers label style.
    /// - Parameters:
    ///   - view: Current countdown view associated with the appearance.
    ///   - label: Time numbers label.
    func applyTimeNumberLabelStyle(_ view: VFGCountdownView, for label: UILabel)
    /// Customize time texts label style.
    /// - Parameters:
    ///   - view: Current countdown view associated with the appearance.
    ///   - label: Time text label.
    func applyTimeTextLabelStyle(_ view: VFGCountdownView, for label: UILabel)
}

extension VFGCountdownAppearance {
    public func applyCountdownSeparatorStyle(_ view: VFGCountdownView, for separator: UIView) {
        separator.backgroundColor = .white
    }

    public func applyTimeNumberLabelStyle(_ view: VFGCountdownView, for label: UILabel) {
        label.textColor = .white
    }

    public func applyTimeTextLabelStyle(_ view: VFGCountdownView, for label: UILabel) {
        label.textColor = .VFGGreyDividerFive
    }
}
