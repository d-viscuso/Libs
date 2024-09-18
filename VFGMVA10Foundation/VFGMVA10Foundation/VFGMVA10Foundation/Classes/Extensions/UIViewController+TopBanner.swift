//
//  UIViewController+TopBanner.swift
//  VFGMVA10Foundation
//
//  Created by Atta Ahmed on 12/17/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
extension UIViewController {
    /// Shows top banner on the current UIViewController.
    /// - Parameters:
    ///    - message: Message displayed in the banner.
    ///    - imageName: Name of image that presented in the banner.
    ///    - duration: Duration of the banner presented on the screen.
    ///    - defaultBannerViewHight: Height of the banner, it is 73.0 by default.
    public func showTopBanner(
        message: String,
        imageName: String,
        duration: Double,
        defaultBannerViewHight: CGFloat = 73.0
    ) {
        guard let bannerView: VFGTopBannerView =
        VFGTopBannerView.loadXib(bundle: Bundle.foundation, nibName: "VFGTopBannerView") else {
            return
        }
        bannerView.frame = CGRect(
            x: .zero,
            y: .zero,
            width: view.frame.width,
            height: defaultBannerViewHight
        )
        var viewDisplacementFromTop = defaultBannerViewHight
        if UIScreen.screenHasNotch {
            viewDisplacementFromTop -= UIApplication.shared.statusBarFrame.height
        }
        view.addSubview(bannerView)
        view.bounds.origin.y -= viewDisplacementFromTop
        bannerView.frame.origin.y -= viewDisplacementFromTop
        bannerView.bringSubviewToFront(view)
        bannerView.configure(message: message, imageName: imageName)

        DispatchQueue.main.asyncAfter(deadline: .now() + duration ) { [weak self] in
            bannerView.removeFromSuperview()
            self?.view.bounds.origin.y = .zero
        }
    }
}
