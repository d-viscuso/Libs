//
//  UIView+LogoLoadingAnimation.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 12/31/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import Lottie

public extension UIView {
    /// Starts loading Vodafone logo animations.
    /// - Parameters:
    ///    - style: Style of the logo, it's automatic by default (ie: depends on the device status light or dark)
    ///    - backgroundColor: The loading view background color.
    ///    - title: Title of the loading view, default is nil and it will be hidden.
    ///    - titleFont: Font of the title, default is nil.
    ///    - titleTextColor: Color of the title text, default is nil.
    ///    - subtitle: Subtitle of the loading view, default is nil and it will be hidden.
    func startLoadingAnimation(
        style: VFGLoadingStyle? = .automatic,
        backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.6),
        title: String? = nil,
        titleFont: UIFont? = nil,
        titleTextColor: UIColor? = nil,
        subtitle: String? = nil
    ) {
        VFGLoadingLogoView.loadingLogoView = VFGLoadingLogoView.loadXib(bundle: .foundation)
        VFGLoadingLogoView.loadingLogoView?.configure(
            style: style,
            view: self,
            backgroundColor: backgroundColor,
            title: title,
            titleFont: titleFont,
            titleTextColor: titleTextColor,
            subtitle: subtitle
        )
        VFGLoadingLogoView.loadingLogoView?.startLoading()
    }

    /// Ends Vodafone logo animations.
    func endLoadingAnimation() {
        VFGLoadingLogoView.loadingLogoView?.endLoading()
        VFGLoadingLogoView.loadingLogoView = nil
    }
}
