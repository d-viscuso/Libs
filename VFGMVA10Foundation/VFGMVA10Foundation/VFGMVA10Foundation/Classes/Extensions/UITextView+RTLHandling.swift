//
//  UITextView+RTLHandling.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 07/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

extension UITextView {
    /// Awakes current UITextView from nib and adjust it's text alignment to right if it's parent view's semantics is right to left.
    open override func awakeFromNib() {
        super.awakeFromNib()
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft, textAlignment != .center {
            textAlignment = .right
        }
    }
}
