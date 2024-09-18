//
//  UIView+LoadFromNib.swift
//  VFGMVA10Malta
//
//  Created by Mohamed Abd ElNasser on 6/25/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

extension UIView {
    /// Loads view from it's nib file.
    /// - Parameters:
    ///    - nibName: Name of the view nib file.
    ///    - bundle: The bundle in which to search for the nib file. If you specify nil, this method looks for the nib file in the main bundle.
    /// - Returns: A *UIView?* of the nib file (name) provided.
    @discardableResult
    public func loadViewFromNib(nibName: String, in bundle: Bundle? = nil) -> UIView? {
        let nib = UINib(nibName: nibName, bundle: bundle ?? Bundle(for: type(of: self)))
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view
    }

    /// Sets up the given view into the current UIView object.
    ///
    /// Usually use this function after you load view from it's nib file and want to set it up in current view.
    /// - Parameters:
    ///    - contentView: View that will be set up inside the current view.
    public func xibSetup(contentView: UIView) {
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
}
