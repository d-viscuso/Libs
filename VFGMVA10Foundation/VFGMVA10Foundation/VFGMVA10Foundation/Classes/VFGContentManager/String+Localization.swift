//
//  String+Localization.swift
//  mva10
//
//  Created by Mahmoud Amer on 12/25/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

extension String {
    /// Method used to retrieve value for given string from given bundle
    /// - Parameters:
    ///    - manager: Static instance of *VFGContentManager*
    ///    - bundle: Bundle of string value to get
    /// - Returns: String value in given bundle
    public func localized(
        manager: VFGContentManager = VFGContentManager.shared,
        bundle: Bundle? = nil
    ) -> String {
        return manager.value(for: self, in: bundle)
    }
}
