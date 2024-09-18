//
//  HorizontalCarouselCardsView.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 05/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import UIKit

/// A view which shows a group of type one cards with a carousel scrolling behaviour
public class HorizontalCarouselCardsView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLeadingConstaint: NSLayoutConstraint!

    let largeHeight: CGFloat = 240
    let smallHeight: CGFloat = 140

    var collectionLayout: ScrollableCardFlowLayout?

    private let minimumLineSpacing: CGFloat = 8
    private let collectionLeadingInsets: CGFloat = 16

    /// Horizontal carousel view data source delegate.
    public weak var dataSource: HorizontalCarouselCardsDataSource? {
        didSet {
            reloadData()
        }
    }
    /// Horizontal carousel view appearance delegate.
    public weak var appearance: HorizontalCarouselCardsAppearance?
    /// Height of horizontal carousel cards view.
    public var cardHeight: CGFloat {
        switch appearance?.layout {
        case .small:
            return smallHeight
        case .large:
            return largeHeight
        default:
            return largeHeight
        }
    }
    /// Current state of horizontal scrollable cards view to handle opposite view default is *.loading*
    public var state: VFGContentState = .loading {
        didSet {
            reloadData()
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }

    /// Reload horizontal cards view content.
    public func reloadData() {
        collectionView.reloadData()
    }

    private func setupCollection() {
        setupCollectionViewLayout()
        setupCollectionView()
        setupCollectionViewData()
        setupCollectionViewInset()
    }

    private func setupCollectionView() {
        collectionView.decelerationRate = .fast
    }

    private func setupCollectionViewData() {
        registerCells()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setupCollectionViewLayout() {
        collectionLayout = ScrollableCardFlowLayout()
        guard let collectionLayout = collectionLayout else { return }
        collectionLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = collectionLayout
    }

    private func setupCollectionViewInset() {
        collectionViewLeadingConstaint.constant = collectionLeadingInsets
    }
}

extension HorizontalCarouselCardsView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .loading:
            return 1
        case .populated:
            return dataSource?.numberOfCards(
                self,
                in: collectionView
            ) ?? 0
        default:
            return 0
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let shimmerCell = shimmerCollectionView(
            collectionView,
            cellForItemAt: indexPath
        )
        switch state {
        case .loading:
            shimmerCell.startShimmer()
            return shimmerCell
        case .populated:
            guard let cell = dataSource?.horizontalCarouselView(
                self,
                collectionView,
                cardForItemAt: indexPath
            ) else { return UICollectionViewCell() }
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    private func shimmerCollectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> HorizontalCarouselShimmerCell {
        guard let shimmerCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: HorizontalCarouselShimmerCell.self),
            for: indexPath
        ) as? HorizontalCarouselShimmerCell
        else {
            return HorizontalCarouselShimmerCell()
        }
        return shimmerCell
    }
}

extension HorizontalCarouselCardsView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lineSpacing = collectionView.numberOfItems(inSection: 0) == 1 ? 0 : minimumLineSpacing
        let cellWidth = collectionView.frame.size.width - lineSpacing - collectionLeadingInsets
        return CGSize(width: max(0, cellWidth), height: collectionView.frame.size.height)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = collectionView.numberOfItems(inSection: 0) == 1 ? 0 : (minimumLineSpacing + collectionLeadingInsets)
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: inset)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        minimumLineSpacing
    }
}
