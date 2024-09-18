//
//  UIViewController+Instance.swift
//  VFGCommonUtils
//
//  Created by Tomasz Czyżak on 30/09/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

extension UIViewController {
    /// Generic function that creates and returns instance of the current UIViewController.
    /// - Parameters:
    ///    - name: Name of the resource (nib or storyboard), it is name of the UIViewController class by default.
    ///    - identifier: Identifier of the class (UIViewController) in the stroryboard, it is name of the UIViewController class by default.
    ///    - bundle: The bundle in which to search for the nib file or storyboard. If you specify nil,
    /// this method looks for the nib file or storyboard in the main bundle.
    public class func instance<T: UIViewController>(
        from name: String = String("\(T.self)"),
        with identifier: String = String("\(T.self)"),
        bundle: Bundle? = Bundle(for: T.self)
    ) -> T {
        if bundle?.path(forResource: name, ofType: "storyboardc") != nil {
            // if storyboard with storyboardName doesn't exist or bundle doesn't contain storyboard then init
            // of UIStoryboard will throw NSException
            let storyboard = UIStoryboard(name: name, bundle: bundle)
            guard let storyboardVC = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
                VFGErrorLog("Can't init \(T.self) with storyboard \(name):\(identifier) using \(T.self)()")
                return T()
            }
            return storyboardVC
        }

        if bundle?.path(forResource: name, ofType: "nib") != nil {
            return T(nibName: name, bundle: bundle)
        }

        VFGErrorLog("Can't find storyboard or nib named \(name)")

        return T()
    }
}
