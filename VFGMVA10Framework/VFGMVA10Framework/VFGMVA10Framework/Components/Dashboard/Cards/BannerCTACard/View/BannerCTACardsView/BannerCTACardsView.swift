//
//  BannerCTACardsView.swift
//  VFGMVA10Framework
//
//  Created by İhsan Kahramanoğlu on 12/27/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// A view which holds CTA cards collection view
public class BannerCTACardsView: UIView {
    @IBOutlet weak var cardsCollectionView: UICollectionView!

    var cardHeight: CGFloat {
        guard let layoutType = viewModel?.getLayoutType()
        else { return BannerCTACardCollectionViewCell.largeCardCellHeight }

        switch layoutType {
        case .small:
            return BannerCTACardCollectionViewCell.smallCardCellHeight
        case .large:
            return BannerCTACardCollectionViewCell.largeCardCellHeight
        }
    }
    private var viewModel: BannerCTACardsViewProtocol?
    private let lineSpacing: CGFloat = -8
    private let topPadding = CGFloat(10)
    private let margin: CGFloat = 16

    var currentIndex = -1
    var destinationIndex = -1

    weak var trackingDelegate: HorizontalScrollableCardsTrackingProtocol?

    public override func awakeFromNib() {
        super.awakeFromNib()
        setupCardsCollectionView()
    }

    // MARK: Setup

    private func setupCardsCollectionView() {
        cardsCollectionView.register(
            UINib(
                nibName: BannerCTACardCollectionViewCell.reuseIdentifier,
                bundle: Bundle.mva10Framework),
            forCellWithReuseIdentifier: BannerCTACardCollectionViewCell.reuseIdentifier)
        cardsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cardsCollectionView.clipsToBounds = false
        cardsCollectionView.dataSource = self
        cardsCollectionView.delegate = self

        let collectionLayout = ScrollableCardFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        cardsCollectionView.collectionViewLayout = collectionLayout
        cardsCollectionView.decelerationRate = .fast
        cardsCollectionView.backgroundColor = .clear
    }

    // MARK: Configure

    public func configure(with model: BannerCTACardsViewProtocol) {
        viewModel = model
        cardsCollectionView.reloadData()
    }
}

// MARK: UICollectionViewDelegate
extension BannerCTACardsView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cardModel = viewModel?.getCardModel(for: indexPath) else { return }
        viewModel?.getBannerCTACardDelegate()?.bannerCTACardViewDidPress(cardModel)
    }
}

// MARK: UICollectionViewDataSource
extension BannerCTACardsView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cardModel = viewModel?.getCardModel(for: indexPath),
            let cardType = viewModel?.getLayoutType(),
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BannerCTACardCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? BannerCTACardCollectionViewCell
        else { return UICollectionViewCell() }
        cell.configure(
            model: cardModel,
            type: cardType,
            delegate: viewModel?.getBannerCTACardDelegate()
        )
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getNumberOfCards() ?? 0
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BannerCTACardsView: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellWidth = UIScreen.main.bounds.width - (margin * 2)
        return CGSize(width: max(0, cellWidth), height: cardHeight)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let inset = collectionView.numberOfItems(inSection: 0) == 1 ? 0 : margin
        return UIEdgeInsets(top: topPadding, left: 0, bottom: 15, right: inset)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return lineSpacing
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let midX: CGFloat = scrollView.bounds.midX
        let midY: CGFloat = scrollView.bounds.midY
        let point = CGPoint(x: midX, y: midY)

        guard let indexPath: IndexPath = cardsCollectionView.indexPathForItem(at: point) else { return }
        currentIndex = indexPath.item
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let midX: CGFloat = scrollView.bounds.midX
        let midY: CGFloat = scrollView.bounds.midY
        let point = CGPoint(x: midX, y: midY)

        guard let indexPath: IndexPath = cardsCollectionView.indexPathForItem(at: point) else { return }
        destinationIndex = indexPath.item
        guard destinationIndex != currentIndex else { return }
        trackingDelegate?.trackHorizontalScrolling(
            currentPosition: currentIndex,
            destinationPosition: destinationIndex
        )
    }
}

// MARK: VFGSeeAllProtocol
extension BannerCTACardsView: VFGSeeAllProtocol {
    public var title: String? {
        return viewModel?.seeAllButtonProtocol.title
    }

    public var color: UIColor? {
        return viewModel?.seeAllButtonProtocol.color
    }

    public var shouldShowSeeAll: Bool {
        if let value = viewModel?.seeAllButtonProtocol.shouldShowSeeAll {
            return value
        }
        return false
    }

    public var showSeeAllAction: (() -> Void)? {
        get {
            viewModel?.seeAllButtonProtocol.showSeeAllAction
        }
        set {}
    }
}
