//
//  ScrollableCardView.swift
//  VFGMVA10Framework
//
//  Created by Giovanni Romaniello on 11/07/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

/// Scrollable card view state which handles the loaded view when fetching data or after data is populated or even in error state
public enum VFGScrollableCardState {
    case loading
    case populated
    case populatedNotTitle
    case error
}

/// horizontal scrollable card container implementation
public class ScrollableCardView: UIView {
    /// Constants for small, medium and large cards size
    let smallHeight: CGFloat = 200
    let mediumHeight: CGFloat = 290
    let largeHeight: CGFloat = 300
    /// default card margin constant
    let cardMargin: CGFloat = 16
    let titleShimmerHeight: CGFloat = 28
    let titleTrailingConstraint: CGFloat = 86

    internal var viewModel: ScrollableCardViewModel?

    /// reference to title label view
    var titleView: UIView?
    /// reference to collection and layout
    var cardsCollection: UICollectionView?
    var collectionLayout: ScrollableCardFlowLayout?
    var delegate: ScrollableCardsDelegateProtocol?

    var cellWidth: CGFloat = 0

    public var state: VFGScrollableCardState = .loading {
        didSet {
            setupTitleView()
            cardsCollection?.reloadData()
        }
    }

    public init(
        with viewModel: ScrollableCardViewModel,
        and delegate: ScrollableCardsDelegateProtocol? = nil
    ) {
        super.init(frame: .zero)
        self.viewModel = viewModel
        self.delegate = delegate
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        setupTitleView()
        setupCollection()
        setupCollectionData()
    }

    private func setupTitleView() {
        switch state {
        case .populatedNotTitle:
            setupPopulatedNotTitle()
        case .loading:
            setupTitleShimmering()
        case .populated:
            setupTitle()
        case .error:
            setupTitle()
        }
    }

    private func setupPopulatedNotTitle() {
        guard let titleLabel = titleView as? VFGShimmerView else {
            return
        }
        titleLabel.theme = .mva12
        self.addSubview(titleLabel)
        titleLabel.fresh.makeConstraints { make in
            make.top == self.fresh.top
            make.left == self.fresh.left + cardMargin
            make.right == self.fresh.right - ( titleTrailingConstraint + cardMargin )
            make.height == 0.0
        }
    }

    private func setupTitle() {
        titleView = VFGLabel()
        guard let title = viewModel?.title?.localized(),
            let titleLabel = titleView as? VFGLabel
        else {
            return
        }
        self.addSubview(titleLabel)
        titleLabel.fresh.makeConstraints { make in
            make.top == self.fresh.top
            make.left == self.fresh.left + cardMargin
            make.right == self.fresh.right
        }
        titleLabel.font = UIFont.vodafoneBold(24)
        titleLabel.textColor = .black
        titleLabel.text = title
    }

    private func setupTitleShimmering() {
        titleView = VFGShimmerView()
        guard let titleLabel = titleView as? VFGShimmerView else {
            return
        }
        titleLabel.theme = .mva12
        self.addSubview(titleLabel)
        titleLabel.fresh.makeConstraints { make in
            make.top == self.fresh.top
            make.left == self.fresh.left + cardMargin
            make.right == self.fresh.right - ( titleTrailingConstraint + cardMargin )
            make.height == titleShimmerHeight
        }
    }

    private func setupCollection() {
        collectionLayout = ScrollableCardFlowLayout()
        collectionLayout?.scrollDirection = .horizontal
        if let collectionLayout = collectionLayout {
            cardsCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionLayout)
        }
        cardsCollection?.decelerationRate = .fast
        cardsCollection?.backgroundColor = .clear
        cardsCollection?.showsVerticalScrollIndicator = false
        cardsCollection?.showsHorizontalScrollIndicator = false
        guard let cardsCollection = cardsCollection,
    let titleLabel = titleView else {
    return
        }
        self.addSubview(cardsCollection)
        cardsCollection.fresh.makeConstraints { make in
            make.top == titleLabel.fresh.bottom
            make.left == self.fresh.left
            make.right == self.fresh.right
            make.bottom == self.fresh.bottom
        }
    }

    private func setupCollectionData() {
        cardsCollection?.delegate = self
        cardsCollection?.dataSource = self
        cardsCollection?.register(
            ScrollableCardItemCollectionViewCell.self,
            forCellWithReuseIdentifier: ScrollableCardItemCollectionViewCell.reuseId)
        cardsCollection?.register(
            UINib(
                nibName: String(describing: ScrollableCardItemShimmerCollectionCell.self),
                bundle: Bundle.mva10Framework
            ),
            forCellWithReuseIdentifier: String(describing: ScrollableCardItemShimmerCollectionCell.self))
    }

    public var cardHeight: CGFloat {
        switch viewModel?.layout {
        case .small:
            return smallHeight
        case .large:
            return largeHeight
        case .medium:
            return mediumHeight
        default:
            return 0
        }
    }
}

extension ScrollableCardView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel,
            let delegate = delegate,
            let actionId = viewModel.cardAtIndex(index: UInt(indexPath.item))?.actionId
        else { return }
        let actions = delegate.bannersActions()
        let bannerAction = actions[actionId]
        bannerAction?()
    }
}

extension ScrollableCardView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .loading:
            return 1
        case .populated, .populatedNotTitle:
            return viewModel?.numberOfCards ?? 0
        case .error:
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
            if let titleLabel = titleView as? VFGShimmerView {
                titleLabel.startAnimation()
            }
            shimmerCell.startShimmer()
            return shimmerCell
        case .populated, .populatedNotTitle:
            shimmerCell.stopShimmer()
            let cardCell = cardCollectionView(
                collectionView,
                cellForItemAt: indexPath
            )
            return cardCell
        case .error:
            return UICollectionViewCell()
        }
    }

    private func shimmerCollectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> ScrollableCardItemShimmerCollectionCell {
        guard let shimmerCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ScrollableCardItemShimmerCollectionCell.self),
            for: indexPath
        ) as? ScrollableCardItemShimmerCollectionCell
        else {
            return ScrollableCardItemShimmerCollectionCell()
        }
        return shimmerCell
    }

    private func cardCollectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> ScrollableCardItemCollectionViewCell {
        guard let cardCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ScrollableCardItemCollectionViewCell.reuseId,
            for: indexPath) as? ScrollableCardItemCollectionViewCell,
            let itemModel = viewModel?.cardAtIndex(index: UInt(indexPath.item))
        else {
            return ScrollableCardItemCollectionViewCell()
        }
        if let configurator = viewModel?.scrollableCardConfigurator {
            configurator.configure(cardCell: cardCell, model: itemModel)
        }
        return cardCell
    }
}

extension ScrollableCardView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewModel?.layout == .medium {
            cellWidth = UIScreen.main.bounds.size.width - (8 * cardMargin)
        } else {
            cellWidth = max(0, collectionView.frame.size.width - (2 * cardMargin))
        }
        return CGSize(width: cellWidth, height: collectionView.frame.size.height)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = 2 * cardMargin
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: inset)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        cardMargin
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
