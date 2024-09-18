//
//  OtherVodafoneAppsAppearance.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 24/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// An appearance protocol that manages the layout of your other vodafone apps view
/// You can use appearance to customize button styles.
public protocol OtherVodafoneAppsAppearance: AnyObject {
    /// Customize get button style by selecting one of two options *primary* and *outline*
    var getButtonStyle: OtherVodafoneAppsButtonStyle { get }
    /// Customize open button style by selecting one of two options *primary* and *outline*
    var openButtonStyle: OtherVodafoneAppsButtonStyle { get }
}

extension OtherVodafoneAppsAppearance {
    var getButtonStyle: OtherVodafoneAppsButtonStyle {
        return .primary
    }
    var openButtonStyle: OtherVodafoneAppsButtonStyle {
        return .outline
    }
}
