//
//  Bundle+Init.swift
//  VFGMVA10Foundation
//
//  Created by Tomasz Czyżak on 16/05/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension Bundle {
    private class VFGExample {}

    public class var foundation: Bundle {
        return Bundle(for: VFGExample.self)
    }

    /// Returns VFGMVA10Media bundle.
    public class var media: Bundle? {
        Bundle.allFrameworks.first {
            $0.applicationName.contains("VFGMVA10Media")
        }
    }

    /// Returns all VFGMVA10 bundles.
    public class var allVFGBundles: [Bundle] {
        Bundle.allFrameworks.filter { $0.applicationName.contains("VFGMVA10") }
    }

    /// return all Soho bundles.
    public class var sohoBundles: [Bundle] {
        Bundle.allFrameworks.filter { $0.applicationName.contains("VFGSOHO") }
    }
}
