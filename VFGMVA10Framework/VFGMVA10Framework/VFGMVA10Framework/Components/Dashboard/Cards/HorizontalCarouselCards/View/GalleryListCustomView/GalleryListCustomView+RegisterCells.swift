//
//  GalleryListCustomView+RegisterCells.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 05/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

extension GalleryListCustomView {
    /// A method used to register a cell class.
    /// - Parameters:
    ///   - cellClass: An instance of type *UICollectionViewCell* and conforms to *LargeWidthBannerCellProtocol*.
    ///   - identifier: A *String* instance which represent the cell identifier.
    public func registerCell(
        _ cellClass: BaseBannerCellProtocol.Type,
        forCellWithReuseIdentifier identifier: String
    ) {
        galleryCollectionView.register(
            cellClass,
            forCellWithReuseIdentifier: identifier
        )
    }

    /// A method used to register nib cell.
    /// You must make sure that your created cell conforms to *LargeWidthBannerCellProtocol*.
    /// - Parameters:
    ///   - nib: An object that contains Interface Builder nib files.
    ///   - identifier: A *String* instance which represent the cell identifier.
    public func registerCell(
        _ nib: UINib,
        forCellWithReuseIdentifier identifier: String
    ) {
        galleryCollectionView.register(
            nib,
            forCellWithReuseIdentifier: identifier
        )
    }

    func registerCells() {
        galleryCollectionView.register(
            LargeNormalStandardBannerCell.self,
            forCellWithReuseIdentifier: LargeNormalStandardBannerCell.reuseIdentifier
        )
        galleryCollectionView.register(
            LargeNormalTitleOnlyBannerCell.self,
            forCellWithReuseIdentifier: LargeNormalTitleOnlyBannerCell.reuseIdentifier
        )
        galleryCollectionView.register(
            LargeNormalLogoBannerCell.self,
            forCellWithReuseIdentifier: LargeNormalLogoBannerCell.reuseIdentifier
        )
        galleryCollectionView.register(
            LargeServiceStandardBannerCell.self,
            forCellWithReuseIdentifier: LargeServiceStandardBannerCell.reuseIdentifier
        )
        galleryCollectionView.register(
            LargeServiceLogoBannerCell.self,
            forCellWithReuseIdentifier: LargeServiceLogoBannerCell.reuseIdentifier
        )
        galleryCollectionView.register(
            LargeServiceBottomTitleBannerCell.self,
            forCellWithReuseIdentifier: LargeServiceBottomTitleBannerCell.reuseIdentifier
        )
        galleryCollectionView.register(
            SmallNormalStandardBannerCell.self,
            forCellWithReuseIdentifier: SmallNormalStandardBannerCell.reuseIdentifier
        )
        galleryCollectionView.register(
            SmallNormalLogoBannerCell.self,
            forCellWithReuseIdentifier: SmallNormalLogoBannerCell.reuseIdentifier)
        galleryCollectionView.register(
            SmallServiceStandardBannerCell.self,
            forCellWithReuseIdentifier: SmallServiceStandardBannerCell.reuseIdentifier)
        galleryCollectionView.register(
            LogoStandardMediumBannerCell.self,
            forCellWithReuseIdentifier: LogoStandardMediumBannerCell.reuseIdentifier)
        galleryCollectionView.register(
            LogoStandardDualCardsCell.self,
            forCellWithReuseIdentifier: LogoStandardDualCardsCell.reuseIdentifier)
    }
}
