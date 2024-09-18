//
//  VFGScrollDelegate.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 3/29/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

/// A delegate protocol that manages user interactions with the overflow menu,
/// including scroll view.
public class VFGScrollDelegate: NSObject, UIScrollViewDelegate {
    /// An object of type *VFGPageControl*.
    public let pageControl: VFGPageControl

    /// Scroll delegate initializer.
    /// - Parameter pageControl: An object of type *VFGPageControl* that displays an instagram style dot indicator pagination.
    public init(pageControl: VFGPageControl) {
        self.pageControl = pageControl
    }

    /// Inherited from UIScrollViewDelegate.scrollViewDidScroll(_:).
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(page)
    }
}
