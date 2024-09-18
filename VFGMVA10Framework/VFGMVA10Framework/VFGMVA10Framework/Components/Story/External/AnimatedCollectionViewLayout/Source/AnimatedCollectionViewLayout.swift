//
//  AnimatedCollectionViewLayout.swift
//  AnimatedCollectionViewLayout
//
//  Created by Jin Wang on Feb 8, 2017.
//  Copyright © 2017 Uthoft. All rights reserved.
//

import Foundation
import UIKit

/// A `UICollectionViewFlowLayout` subclass enables custom transitions between cells.
open class AnimatedCollectionViewLayout: UICollectionViewFlowLayout {
    /// The animator that would actually handle the transitions.
    open var animator: LayoutAttributesAnimator?

    /// Overrided so that we can store extra information in the layout attributes.
    open override class var layoutAttributesClass: AnyClass { return AnimatedCollectionViewLayoutAttributes.self }
    /// Overrided so that we can do more animation attributes on the collection view layout.
    /// - Parameters:
    ///    - rect: Element location and dimensions.
	open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
		return attributes
			.compactMap { $0.copy() as? AnimatedCollectionViewLayoutAttributes }
			.map { self.transformLayoutAttributes($0) }
	}
    /// Overrided to always return true
    /// so that the layout attributes would be recalculated everytime we scroll the collection view.
    /// - Parameters:
    ///    - newBounds: Element new location and dimensions.
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // We have to return true here so that the layout attributes would be recalculated
        // everytime we scroll the collection view.
        return true
    }
    /// Return transform animation attributes for collection view layout.
    /// - Parameters:
    ///    - attributes: Animated collection view layout attributes.
    func transformLayoutAttributes(
		_ attributes: AnimatedCollectionViewLayoutAttributes
	) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }

        let atr = attributes

        // The position for each cell is defined as the ratio of the distance between
        // the center of the cell and the center of the collectionView and the collectionView width/height
        // depending on the scroll direction. It can be negative if the cell is, for instance,
        // on the left of the screen if you're scrolling horizontally.

        let distance: CGFloat
        let itemOffset: CGFloat

        if scrollDirection == .horizontal {
            distance = collectionView.frame.width
            itemOffset = atr.center.x - collectionView.contentOffset.x
            atr.startOffset = (atr.frame.origin.x - collectionView.contentOffset.x) / atr.frame.width
            let endOffset = (atr.frame.origin.x - collectionView.contentOffset.x - collectionView.frame.width)
            atr.endOffset = endOffset / atr.frame.width
        } else {
            distance = collectionView.frame.height
            itemOffset = atr.center.y - collectionView.contentOffset.y
            atr.startOffset = (atr.frame.origin.y - collectionView.contentOffset.y) / atr.frame.height
            let endOffset = (atr.frame.origin.y - collectionView.contentOffset.y - collectionView.frame.height)
            atr.endOffset = endOffset / atr.frame.height
        }

        atr.scrollDirection = scrollDirection
        atr.middleOffset = itemOffset / distance - 0.5

        // Cache the contentView since we're going to use it a lot.
        let contentView = collectionView.cellForItem(at: attributes.indexPath)?.contentView
        if atr.contentView == nil, let contentView = contentView {
            atr.contentView = contentView
        }

        animator?.animate(collectionView: collectionView, attributes: atr)

        return atr
    }
}

/// A custom layout attributes that contains extra information.
open class AnimatedCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    /// Collection view content view
    public var contentView: UIView?
    /// Collection view scroll direction. Vertical by default
    public var scrollDirection: UICollectionView.ScrollDirection = .vertical

    // The ratio of the distance between the start of the cell and the start of the collectionView and the height
    // width of the cell depending on the scrollDirection. It's 0 when the start of the cell aligns the start of the
    // collectionView. It gets positive when the cell moves towards the scrolling direction (right/down) while
    // getting negative when moves opposite.
    /// Ratio distance between the start of the cell and the start of the collection view width or height
    /// based on scroll direction.
    public var startOffset: CGFloat = 0
    /// Ratio distance between the center of the cell and the start of the collection view width or height
    /// based on scroll direction.
    public var middleOffset: CGFloat = 0
    /// Ratio distance between the start of the cell and the end of the collection view width or height
    /// based on scroll direction.
    public var endOffset: CGFloat = 0
    /// Overrided to add new copy of the collection view layout animation attributes.
    /// - Parameters:
    ///    - zone: This parameter is ignored. Memory zones are no longer used by Objective-C.
    open override func copy(with zone: NSZone? = nil) -> Any {
        guard let copy = super.copy(with: zone) as? AnimatedCollectionViewLayoutAttributes else { return self }
        copy.contentView = contentView
        copy.scrollDirection = scrollDirection
        copy.startOffset = startOffset
        copy.middleOffset = middleOffset
        copy.endOffset = endOffset
        return copy
    }
    /// Overrided to do more comparison between the receiver and a given object.
    /// - Parameters:
    ///    - object: Given object to compare with the receiver.
    open override func isEqual(_ object: Any?) -> Bool {
        guard let obj = object as? AnimatedCollectionViewLayoutAttributes else { return false }

        return super.isEqual(obj)
            && obj.contentView == contentView
            && obj.scrollDirection == scrollDirection
            && obj.startOffset == startOffset
            && obj.middleOffset == middleOffset
            && obj.endOffset == endOffset
    }
}
