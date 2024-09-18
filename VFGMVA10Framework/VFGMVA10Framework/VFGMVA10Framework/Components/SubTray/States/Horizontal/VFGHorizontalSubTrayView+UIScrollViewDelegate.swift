//
//  VFGHorizontalSubTrayView+UIScrollViewDelegate.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 22/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

enum HorizontalSubTrayScrollType {
    case itemsCollectionView
    case expandedScrollView
}

extension VFGHorizontalSubTrayView: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollType = scrollView == collectionView ? .itemsCollectionView : .expandedScrollView
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollType == .itemsCollectionView {
            expandedScrollView?.synchronize(with: collectionView)
        } else {
            collectionView?.synchronize(with: scrollView)
        }
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollDidFinishAction?()
        scrollDidFinishAction = nil
    }
}
