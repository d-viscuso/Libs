//
//  MVA10BottomPopupViewConstants.swift
//  VFGMVA10Foundation
//
//  Created by jguticon on 3/12/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public enum BottomPopupViewConstants {
    /// Default value for bottom popup height. 400pt
    public static let kPopupHeight: CGFloat = 400.0
    /// Default value for bottom popup width. Screen width
    public static let kPopupWidth: CGFloat = UIScreen.main.bounds.width
    /// Default value for bottom popup corner radius. 10pt
    public static let kPopupCornerRadius: CGFloat = 10.0
    ///  value for bottom popup present animation. 0.5seg
    public static let kPopupPresentDuration = 0.5
    /// Default value for bottom popup dismiss animation. 0.5seg
    public static let kPopupDismissDuration = 0.35
    /// Default value for bottom popup dismiss drag interaction. True
    public static let kPopupDismissInteractively = true
    /// Default value for bottom popup dismiss tap interaction. True
    public static let kPopupShouldPopupViewDismiss = true
    /// Default value for dimmed view alpha value. 0.6
    public static let kPopupDefaultAlphaValue: CGFloat = 0.6
    /// Default value for dimmed view background color black
    public static let kPopupDefaultBackgroundColorValue: UIColor = .black
}
