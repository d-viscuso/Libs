//
//  VFDashboardItemLayout.swift
//  testCollection
//
//  Created by Tomasz Czyżak on 19/12/2018.
//  Copyright © 2018 Tomasz Czyżak. All rights reserved.
//
import UIKit
import VFGMVA10Foundation
/// *VFDashboardViewController* item layout
class VFDashboardItemLayout: UICollectionViewFlowLayout, DashboardLayoutProtocol {
    /// An instance of *VFGTileLayoutDelegate*
    weak var delegate: VFGTileLayoutDelegate?
    var topInset: CGFloat = 0
    private var oldBounds = CGRect.zero
    fileprivate var numberOfColumns = 2
    fileprivate var cache: [UICollectionViewLayoutAttributes] = []
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var mainHeaderHeight: CGFloat { return VFGUISetup.dashboardMainHeaderHeight }
    fileprivate var mainFooterHeight: CGFloat {
        if delegate?.refreshManger == nil {
            return 0
        } else {
            return VFGUISetup.dashboardDefaultFooterHeight
        }
    }
    fileprivate let defaultHeaderHeight = VFGUISetup.dashboardDefaultHeaderHeight
    fileprivate let defaultFooterHeight = VFGUISetup.dashboardDefaultFooterHeight

    fileprivate var insets: UIEdgeInsets {
        guard let collectionView = collectionView else {
            return UIEdgeInsets.zero
        }
        return collectionView.contentInset
    }

    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll()
        contentHeight = 0
    }

    override func prepare() {
        guard cache.isEmpty == true,
            let collectionView = collectionView,
            let delegate = delegate,
            collectionView.numberOfSections > 0 else {
                return
        }
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var cellsXOffset: [CGFloat] = []
        for column in 0 ..< numberOfColumns {
            cellsXOffset.append(CGFloat(column) * columnWidth)
        }
        var cellsYOffset = [CGFloat](repeating: mainHeaderHeight, count: numberOfColumns)
        var headersYOffset: CGFloat = topInset
        var footerYOffset: CGFloat = 0

        for section in 0..<collectionView.numberOfSections {
            if delegate.checkSectionHasTitle(IndexPath(row: 0, section: section)) || section == 0 {
                prepareHeaderAttributes(
                    section: section,
                    collectionView: collectionView,
                    headerYOffset: headersYOffset
                )
            }
            // Update items Y contentOffset after header attrs update
            cellsYOffset = cellsYOffset.compactMap { _ -> CGFloat? in
                return contentHeight
            }
            /* Header Attrs */
            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let tile = delegate.collectionView(collectionView, tileLayoutIndex: indexPath)
                let cellColumn = tile.column
                let frame = CGRect(
                    x: cellsXOffset[cellColumn],
                    y: cellsYOffset[cellColumn],
                    width: tile.size.width,
                    height: tile.size.height)
                // item padding
                let itemInsets = delegate.collectionView(
                    collectionView,
                    insetByAtIndex: indexPath,
                    position: tile.position
                )
                let insetFrame = frame.inset(by: itemInsets)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                if frame.height != 0 {
                    attributes.frame = insetFrame
                } else {
                    attributes.frame = frame
                }
                cache.append(attributes)
                contentHeight = max(contentHeight, frame.maxY)
                cellsYOffset[cellColumn] += tile.size.height
                if tile.size.width > columnWidth {
                    cellsYOffset[1] += tile.size.height
                }
            }
            footerYOffset = contentHeight
            prepareFooterAttributes(section: section, collectionView: collectionView, footerYOffset: footerYOffset)
            headersYOffset = contentHeight - Constants.dashboardCollectionPadding
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[safe: indexPath.item]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

        // Loop through the cache and look for items in the rect
        for attributes in cache where attributes.frame.intersects(rect) {
            visibleLayoutAttributes.append(attributes)
        }
        return visibleLayoutAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        defer {
            oldBounds = newBounds
        }
        return oldBounds.size != newBounds.size
    }

    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // Fixes inconsistent animation behavior when deleting cell or section
        // specifically when the type of the cell is VFEditorialView
        nil
    }
}

// MARK: - Sections Headers Layout
extension VFDashboardItemLayout {
    fileprivate func prepareHeaderAttributes(section: Int, collectionView: UICollectionView, headerYOffset: CGFloat) {
        let indexPath = IndexPath(item: 0, section: section)
        let headerWidth = collectionView.frame.width - (insets.left + insets.right)
        var sectionHeaderHeight = section > 0 ? defaultHeaderHeight : mainHeaderHeight
        if !(delegate?.enableHeaderForSection(at: section) ?? true) {
            sectionHeaderHeight = 0
        }
        let discoverSection = delegate?.discoverIndexInSections()
        let headerY = (section == discoverSection && section > 0) ?
        Constants.DashboardDiscoverSnap.discoverTopMargin + headerYOffset : headerYOffset

        let headerFrame = CGRect(x: 0, y: headerY, width: headerWidth, height: sectionHeaderHeight)
        addHeaderAttributes(section: section, frame: headerFrame, indexPath: indexPath)
        contentHeight = max(contentHeight, headerFrame.maxY)
        if section == discoverSection && section > 0 {
            delegate?.discoverSnapThreshold = headerFrame.origin.y
        }
    }

    fileprivate func prepareFooterAttributes(section: Int, collectionView: UICollectionView, footerYOffset: CGFloat) {
        let indexPath = IndexPath(item: 0, section: section)
        let footerWidth = collectionView.frame.width - (insets.left + insets.right)
        var sectionFooterHeight = section > 0 ? defaultFooterHeight : mainFooterHeight
        if !(delegate?.enableFooterForSection(at: section) ?? true) {
            sectionFooterHeight = 0
        }
        let extraPadding: CGFloat = 7
        let footerY = section == 0 ? footerYOffset + extraPadding : footerYOffset
        let footerFrame = CGRect(x: 0, y: footerY, width: footerWidth, height: sectionFooterHeight)
        addFooterAttributes(section: section, frame: footerFrame, indexPath: indexPath)
        contentHeight = max(contentHeight, footerFrame.maxY)
    }

    fileprivate func addHeaderAttributes(section: Int, frame: CGRect, indexPath: IndexPath) {
        let headerAttr = UICollectionViewLayoutAttributes(
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            with: indexPath)
        // item padding
        let yInset: CGFloat = delegate?.enableHeaderForSection(at: section) ?? true ? 5 : 0
        let insetFrame = frame.insetBy(dx: 0, dy: yInset)
        headerAttr.frame = insetFrame
        cache.append(headerAttr)
    }

    fileprivate func addFooterAttributes(section: Int, frame: CGRect, indexPath: IndexPath) {
        if section == 0,
        delegate?.enableFooterForSection(at: section) == true {
            let footerAttr = UICollectionViewLayoutAttributes(
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                with: indexPath)
            // item padding
            let insetFrame = frame.insetBy(dx: 0, dy: 0)
            footerAttr.frame = insetFrame
            cache.append(footerAttr)
        }
    }
}
