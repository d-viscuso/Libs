//
//  UIScrollView+Synchronize.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 25/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public extension UIScrollView {
    /// Synchronizes the given scroll view with the current UIScrollView object.
    /// - Parameters:
    ///    - scrollView: UIScrollView that will be synchronized with the current UIScrollView.
    ///    - animated: A boolean value to tell if the scroll will be animated or not.
    func synchronize(with scrollView: UIScrollView?, animated: Bool = false) {
        guard let scrollView = scrollView else { return }
        setContentOffset(scrollView.contentOffset, animated: animated)
    }
}
