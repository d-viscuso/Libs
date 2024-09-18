//
//  VFGTooltipsDelegate.swift
//  VFGMVA10Group
//
//  Created by Yahya Saddiq on 14/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// The methods adopted by the object you use to manage user interactions with items in a Tooltips view.
protocol VFGTooltipsDelegate: AnyObject {
    /// Triggered when a tooltip view is pressed.
    func tooltipViewDidTap(_ tipView: VFGTooltips)

    /// Triggered when a tooltip view is dismissed.
    func tooltipViewDidDismiss(_ tipView: VFGTooltips)
}
