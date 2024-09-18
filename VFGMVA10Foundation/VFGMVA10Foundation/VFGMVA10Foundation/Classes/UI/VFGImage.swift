//
//  VFGImage.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 3/13/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//
/// Search for image in app asset & *VFGMVA10Media* and MVA10 available frameworks
/// - Parameters:
///    - name: Name of the image to get
/// - Returns: *UIImage* for the given name
public func VFGImage(named name: String?) -> UIImage? {
    guard let name = name else {
        return nil
    }

    // 1. Find the image, In the app asset
    // 2. desc is checked to skip react bundle images which is
    // stored in the root of the main bundle
    if let image = UIImage(named: name, in: .main, compatibleWith: nil),
        image.description.contains("main") {
        return image
    } else if Bundle.main.path(forResource: name, ofType: "png") == nil,
        let image = UIImage(named: name, in: .main, compatibleWith: nil) {
            return image
    }

    // Then, in the VFGMVA10Media
    else if let image = UIImage(named: name, in: .foundation, compatibleWith: nil) {
        return image
    }

    // Finally, in remaining MVA10 frameworks
    let remainingBundles = Bundle.allVFGBundles.filter {
        $0.applicationName != "VFGMVA10Group" && $0.applicationName != "VFGMVA10Foundation"
    }

    for bundle in remainingBundles {
        if let image = UIImage(named: name, in: bundle, compatibleWith: nil) {
            return image
        }
    }

    /// Checking Soho bundles
    let sohoBundles = Bundle.sohoBundles
    for bundle in sohoBundles {
        if let image = UIImage(named: name, in: bundle, compatibleWith: nil) {
            return image
        }
    }

    return nil
}
