//
//  AddOnsTimelineCollectionViewLayout.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 7/1/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit

class AddOnsTimelineCollectionViewLayout: UICollectionViewLayout {
    var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    weak var delegate: TimelineLayoutDelegate?

    override var collectionViewContentSize: CGSize {
        let numberOfLines = CGFloat(delegate?.getNumberOfDateLines() ?? 0) + 1
        let contentWidth = numberOfLines * CGFloat((Constants.AddOnsTimeline.timelineDateViewsHorizontalSpacing +
        Constants.AddOnsTimeline.timelineDateViewWidth)) + Constants.AddOnsTimeline.timelineDateStartViewXPosition
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        cache.removeAll()
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let cellWidth = delegate?.collectionView(
                collectionView,
                widthForItemAtIndexPath: indexPath) ?? 0
            let cellHeight = delegate?.collectionView(
                collectionView,
                heightForItemAtIndexPath: indexPath) ?? 0
            let yOffset = delegate?.collectionView(
                collectionView,
                yPositionForItemAtIndexPath: indexPath) ?? 0
            let xOffset = delegate?.collectionView(
                collectionView,
                xPositionForItemAtIndexPath: indexPath) ?? 0
            let frame = CGRect(
                x: xOffset,
                y: yOffset,
                width: cellWidth,
                height: cellHeight)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
            contentHeight = max(contentHeight, frame.maxY)
        }
    }

    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
            for attributes in cache where attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
            return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            return cache[indexPath.item]
    }
}
