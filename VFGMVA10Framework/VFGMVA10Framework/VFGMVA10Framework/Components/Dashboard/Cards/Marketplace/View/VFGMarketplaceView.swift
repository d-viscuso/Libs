//
//  MarketplaceView.swift
//  VFGMVA10Framework
//
//  Created by Giovanni Romaniello on 10/10/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import UIKit
import VFGMVA10Foundation

/// MarketplaceView
public class VFGMarketplaceView: UIView {
    internal let itemSize = CGSize(width: 144, height: 256)
    internal let interItemSpacing: CGFloat = 8
    private let collectionInsets: CGFloat = 17
    internal var viewModel: VFGMarketplaceViewModelProtocol?
    internal var collectionView: UICollectionView?

    /// exposed action for show See All cta
    public var showSeeAllAction: (() -> Void)?

    /// MarketplaceView
    /// - Parameter viewModel: MarketplaceViewModelProtocol implementation
    public init(with viewModel: VFGMarketplaceViewModelProtocol) {
        super.init(frame: .zero)
        self.viewModel = viewModel
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        clipsToBounds = false
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        guard let collectionView = collectionView else {
            return
        }
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(
            VFGMarketplaceProductCollectionViewCell.self,
            forCellWithReuseIdentifier: VFGMarketplaceProductCollectionViewCell.reuseIdentifier)
        addSubview(collectionView)
        collectionView.fresh.makeConstraints { fresh in
            fresh.top == self.fresh.top
            fresh.left == self.fresh.left
            fresh.right == self.fresh.right
            fresh.bottom == self.fresh.bottom
        }
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension VFGMarketplaceView: VFGSeeAllProtocol {
    /// shows see all button if number of products is > 7
    public var shouldShowSeeAll: Bool {
        viewModel?.showSeeAllButton == true
    }
}

extension VFGMarketplaceView: UICollectionViewDelegateFlowLayout {
    /// returns the marketplace product item size inside the marketplaceview's collection
    /// - Parameters:
    ///   - collectionView: the collectionview
    ///   - collectionViewLayout:collectionview layout
    ///   - indexPath: indexPath of the item
    /// - Returns: item's size
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        itemSize
    }
    /// returns the inter item spacing between cells
    /// - Parameters:
    ///   - collectionView: the collectionview
    ///   - collectionViewLayout: collectionview layout
    ///   - section: item's section
    /// - Returns: item's inter item spacing
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        interItemSpacing
    }

    /// returns the collection's edge insets
    /// - Parameters:
    ///   - collectionView: the collectionview
    ///   - collectionViewLayout: collectionview layout
    ///   - section: item's section
    /// - Returns: section edge insets
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: collectionInsets, bottom: 0, right: collectionInsets)
    }
}

extension VFGMarketplaceView: UICollectionViewDelegate { }

extension VFGMarketplaceView: UICollectionViewDataSource {
    /// returns the marketplace product cell
    /// - Parameters:
    ///   - collectionView: the collectionview
    ///   - indexPath: indexPath of the item
    /// - Returns: returns item view cell
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let productCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: VFGMarketplaceProductCollectionViewCell.reuseIdentifier,
            for: indexPath) as? VFGMarketplaceProductCollectionViewCell,
                let productModel = viewModel?.productAtIndex(index: indexPath.row) else {
            return VFGMarketplaceProductCollectionViewCell()
        }
        productCell.configure(
            with: VFGMarketplaceProductViewModel(
                product: productModel,
                wishlist: UserDefaults.standard))
        return productCell
    }
    /// returns the number of prodcuts inside the collection
    /// - Parameters:
    ///   - collectionView: the collectionview
    ///   - section: item's section
    /// - Returns: returns the number of products
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.numberOfProducts ?? 0
    }
}
