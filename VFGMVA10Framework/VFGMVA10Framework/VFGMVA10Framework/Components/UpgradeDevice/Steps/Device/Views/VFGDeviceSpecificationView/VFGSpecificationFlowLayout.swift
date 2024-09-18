//
//  VFGSpecificationFlowLayout.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 15/07/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

class VFGSpecificationFlowLayout: UICollectionViewFlowLayout {
    private var contentWidth: CGFloat? {
        guard let collectionViewWidth = collectionView?.frame.size.width else {
            return nil
        }
        return collectionViewWidth - sectionInset.left - sectionInset.right
    }

    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard
            let layoutAttributes =
                super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }

        alignVertically(layoutAttributes: layoutAttributes)
        return layoutAttributes
    }

    func alignVertically(layoutAttributes: UICollectionViewLayoutAttributes) {
        if let alignmentAxis = verticalAlignmentAxis(for: layoutAttributes) {
            layoutAttributes.frame.origin.y = alignmentAxis
        }
    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesObjects = copy(super.layoutAttributesForElements(in: rect))
        layoutAttributesObjects?.forEach {
            setFrame(forLayoutAttributes: $0)
        }
        return layoutAttributesObjects
    }

    private func setFrame(forLayoutAttributes layoutAttributes: UICollectionViewLayoutAttributes) {
        if layoutAttributes.representedElementCategory == .cell {
            let indexPath = layoutAttributes.indexPath
            if let newFrame = layoutAttributesForItem(at: indexPath)?.frame {
                layoutAttributes.frame = newFrame
            }
        }
    }

    fileprivate func layoutAttributes(forItemsInLineWith layoutAttributes: UICollectionViewLayoutAttributes) -> [UICollectionViewLayoutAttributes] {
        guard let lineWidth = contentWidth else {
            return [layoutAttributes]
        }
        var lineFrame = layoutAttributes.frame
        lineFrame.origin.x = sectionInset.left
        lineFrame.size.width = lineWidth
        return super.layoutAttributesForElements(in: lineFrame) ?? []
    }

    fileprivate func verticalAlignmentAxis(for currentLayoutAttributes: UICollectionViewLayoutAttributes) -> CGFloat? {
        let layoutAttributesInLine = layoutAttributes(forItemsInLineWith: currentLayoutAttributes)
        let minY = layoutAttributesInLine.reduce(CGFloat.greatestFiniteMagnitude) { min($0, $1.frame.minY) }
        return minY
    }

    private func copy(_ layoutAttributesArray: [UICollectionViewLayoutAttributes]?) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributesArray?.map { $0.copy() } as? [UICollectionViewLayoutAttributes]
    }
}
