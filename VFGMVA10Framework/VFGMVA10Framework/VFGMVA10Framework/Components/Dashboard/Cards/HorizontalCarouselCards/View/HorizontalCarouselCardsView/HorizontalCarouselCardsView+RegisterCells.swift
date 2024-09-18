//
//  HorizontalCarouselCardsView+RegisterCells.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 05/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

/// Cells registration
extension HorizontalCarouselCardsView {
    /// A method used to register a cell class.
    /// - Parameters:
    ///   - cellClass: An instance of type *UICollectionViewCell* and conforms to *BaseBannerCellProtocol*.
    ///   - identifier: A *String* instance which represent the cell identifier.
    public func registerCell(
        _ cellClass: BaseBannerCellProtocol.Type,
        forCellWithReuseIdentifier identifier: String
    ) {
        collectionView.register(
            cellClass.self,
            forCellWithReuseIdentifier: identifier
        )
    }

    /// A method used to register nib cell.
    /// You must make sure that your created cell conforms to *BaseBannerCellProtocol*.
    /// - Parameters:
    ///   - nib: An object that contains Interface Builder nib files.
    ///   - identifier: A *String* instance which represent the cell identifier.
    public func registerCell(
        _ nib: UINib,
        forCellWithReuseIdentifier identifier: String
    ) {
        collectionView.register(
            nib,
            forCellWithReuseIdentifier: identifier
        )
    }

    func registerCells() {
        collectionView.register(
            UINib(
                nibName: String(describing: HorizontalCarouselShimmerCell.self),
                bundle: .mva10Framework
            ),
            forCellWithReuseIdentifier: String(describing: HorizontalCarouselShimmerCell.self)
        )
        collectionView.register(
            LargeNormalStandardBannerCell.self,
            forCellWithReuseIdentifier: LargeNormalStandardBannerCell.reuseIdentifier
        )
        collectionView.register(
            LargeNormalTitleOnlyBannerCell.self,
            forCellWithReuseIdentifier: LargeNormalTitleOnlyBannerCell.reuseIdentifier
        )
        collectionView.register(
            LargeNormalLogoBannerCell.self,
            forCellWithReuseIdentifier: LargeNormalLogoBannerCell.reuseIdentifier
        )
        collectionView.register(
            LargeServiceStandardBannerCell.self,
            forCellWithReuseIdentifier: LargeServiceStandardBannerCell.reuseIdentifier
        )
        collectionView.register(
            LargeServiceLogoBannerCell.self,
            forCellWithReuseIdentifier: LargeServiceLogoBannerCell.reuseIdentifier
        )
        collectionView.register(
            LargeServiceBottomTitleBannerCell.self,
            forCellWithReuseIdentifier: LargeServiceBottomTitleBannerCell.reuseIdentifier
        )
        collectionView.register(
            SmallNormalStandardBannerCell.self,
            forCellWithReuseIdentifier: SmallNormalStandardBannerCell.reuseIdentifier
        )
        collectionView.register(
            SmallNormalLogoBannerCell.self,
            forCellWithReuseIdentifier: SmallNormalLogoBannerCell.reuseIdentifier)
        collectionView.register(
            SmallServiceStandardBannerCell.self,
            forCellWithReuseIdentifier: SmallServiceStandardBannerCell.reuseIdentifier)
    }
}
