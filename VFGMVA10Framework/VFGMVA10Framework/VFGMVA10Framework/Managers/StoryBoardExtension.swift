//
//  AppStoryboards.swift
//  AppStoryboards
//
//  Created by Gurdeep on 15/12/16.
//  Copyright © 2016 Gurdeep. All rights reserved.
//

import Foundation
import UIKit

/// Application Storyboard.
public enum AppStoryboard: String {
    case main = "Main"
    case trayStoryboard = "TrayStoryboard"
    case addMore = "AddMore"
    case discovery = "Discovery"
    case onboarding = "OnboardingStoryboard"
    case everythingIsOK = "EverythingIsOK"

    /// Returns an instance *UIStoryboard* of the current storyboard.
    public var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.mva10Framework)
    }

    func viewController<T: UIViewController>(
        viewControllerClass: T.Type,
        function: String = #function,
        line: Int = #line,
        file: String = #file
    ) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID

        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID)," +
                "not found in \(self.rawValue) Storyboard.\nFile :" +
                "\(file) \nLine Number : \(line) \nFunction : \(function)")
        }

        return scene
    }

    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID: String {
        return "\(self)"
    }

    /// Method used to initialize *UIViewController* from a an application storyboard *AppStoryboard*.
    /// - Parameters:
    ///    - fromAppStoryboard: Storyboard that contains the *UIViewController* we want to initialize.
    /// - Returns: Initialized view controller *UIViewController*.
    public static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
