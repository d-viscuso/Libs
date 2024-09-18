//
//  ScrollableCardFlowLayout.swift
//  VFGMVA10Framework
//
//  Created by Giovanni Romaniello on 12/07/22.
//

import UIKit

class ScrollableCardFlowLayout: UICollectionViewFlowLayout {
    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }

        let targetRect = CGRect(origin: proposedContentOffset, size: collectionView.bounds.size)
        let visibleCellsLayoutAttributes = layoutAttributesForElements(in: targetRect)

        let candidateOffsets: [CGFloat]? = visibleCellsLayoutAttributes?.map { cellLayoutAttributes in
            if #available(iOS 11.0, *) {
                return cellLayoutAttributes.frame.origin.x -
                collectionView.contentInset.left -
                collectionView.safeAreaInsets.left -
                sectionInset.left
            } else {
                return cellLayoutAttributes.frame.origin.x - collectionView.contentInset.left - sectionInset.left
            }
        }

        let bestCandidateOffset: CGFloat

        if velocity.x > 0 {
            let candidateOffsetsToRight = candidateOffsets?.toRight(ofProposedOffset: proposedContentOffset.x)
            let nearestCandidateOffsetToRight = candidateOffsetsToRight?
                .nearest(toProposedOffset: proposedContentOffset.x)

            bestCandidateOffset = nearestCandidateOffsetToRight ?? candidateOffsets?.last ?? proposedContentOffset.x
        } else if velocity.x < 0 {
            let candidateOffsetsToLeft = candidateOffsets?.toLeft(ofProposedOffset: proposedContentOffset.x)
            let nearestCandidateOffsetToLeft =
            candidateOffsetsToLeft?.nearest(toProposedOffset: proposedContentOffset.x)

            bestCandidateOffset = nearestCandidateOffsetToLeft ?? candidateOffsets?.first ?? proposedContentOffset.x
        } else {
            let nearestCandidateOffset = candidateOffsets?.nearest(toProposedOffset: proposedContentOffset.x)
            bestCandidateOffset = nearestCandidateOffset ?? proposedContentOffset.x
        }

        return CGPoint(x: bestCandidateOffset, y: proposedContentOffset.y)
    }
}

fileprivate extension Sequence where Iterator.Element == CGFloat {
    func toLeft(ofProposedOffset proposedOffset: CGFloat) -> [CGFloat] {
        return filter { candidateOffset in
            return candidateOffset < proposedOffset
        }
    }

    func toRight(ofProposedOffset proposedOffset: CGFloat) -> [CGFloat] {
        return filter { candidateOffset in
            return candidateOffset > proposedOffset
        }
    }

    func nearest(toProposedOffset proposedOffset: CGFloat) -> CGFloat? {
        guard let firstCandidateOffset = first(where: { _ in true }) else {
            return nil
        }

        return reduce(firstCandidateOffset) { (bestCandidateOffset: CGFloat, candidateOffset: CGFloat) -> CGFloat in
            let candidateOffsetDistanceFromProposed = abs(candidateOffset - proposedOffset)
            let bestCandidateOffsetDistancFromProposed = abs(bestCandidateOffset - proposedOffset)

            if candidateOffsetDistanceFromProposed < bestCandidateOffsetDistancFromProposed {
                return candidateOffset
            }

            return bestCandidateOffset
        }
    }
}
