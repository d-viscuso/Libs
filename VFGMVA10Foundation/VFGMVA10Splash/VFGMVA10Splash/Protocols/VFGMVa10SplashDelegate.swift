//
//  VFGMVa10SplashDelegate.swift
//  VFGMVA10Splash
//
//  Created by Hussien Gamal Mohammed on 9/19/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
/// Delegation protocol for splash animation configurations
public protocol VFGMVa10SplashDelegate: AnyObject {
    /// Determine final logo location and dimensions
    var logoFrame: CGRect { get }
    /// If set to true, the splash component will present and animate your next view controller,
    /// If set to false, you should animate your next view controller in *viewDidAppear*
    var useSplashDefaultAnimation: Bool { get }
    /// Set a background color for your next view controller, *nextViewControllerBGImage* should be nil
    var nextViewControllerBGColor: UIColor? { get }
    /// Set a background image for your next view controller, *nextViewControllerBGColor* should be nil
    var nextViewControllerBGImage: UIImage? { get }
    /// Vodafone logo whether it's white or red
    var logo: UIImage? { get }
    /// Use this method to tell next view controller that animations started,
    /// We use this usually to start animating the next view controller content from bottom to top
    /// in case of *useSplashDefaultAnimation = false*
    /// - Parameters:
    ///    - duration: Animation process full time
    ///    - delay: Waiting time before starting animation process
    ///    - completion: A closure to handle actions after animation process is done
    func splashTransitionsWillStart(duration: Double, delay: Double, completion: (() -> Void)?)
    /// Use this method to tell next view controller that animations ended,
    /// We use this usually to show your logo and the background in case you hide them in *splashTransitionsWillStart*
    func splashTransitionsDidFinish()
}
