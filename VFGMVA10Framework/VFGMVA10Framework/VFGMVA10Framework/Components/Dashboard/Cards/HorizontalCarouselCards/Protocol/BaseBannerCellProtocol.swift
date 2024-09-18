//
//  BaseBannerCellProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 02/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import Foundation

/// An enum which represents the gallery card width type.
public enum GalleryCardWidthType {
    case largeWidth(collectionInset: CGFloat)
    case mediumSquared(cellHeight: CGFloat)
    case dualViews(cellHeight: CGFloat)
    case custom(width: CGFloat)
    case defaultType

    var value: CGFloat {
        switch self {
        case .largeWidth(let collectionInset):
            return UIScreen.main.bounds.size.width - collectionInset
        case .mediumSquared(let cellHeight):
            return cellHeight + 20
        case .dualViews(let cellHeight):
            return cellHeight + 20
        case .custom(let width):
            return width
        case .defaultType:
            return 0
        }
    }
}


/// A protocol which holds the whole cell types and used to configure gallery list section.
public protocol BaseBannerCellProtocol where Self: UICollectionViewCell {
    /// An instance of type *CGFloat* which represents any inset that affect collection view width.
    var collectionInset: CGFloat? { get set }
    /// An instance of type *CGFloat* which represents the space between each cell.
    var minimumLineSpacing: CGFloat? { get set }
    /// An instance of type *CGFloat* which represents the cell height.
    var cellHeight: CGFloat? { get set }
    /// An enum instance of type *GallaryCardWidthType* which represnt the cell width type.
    var cellWidthType: GalleryCardWidthType? { get }
    /// A dictionary which represents a list of keys and actions.
    var bannerActions: [String: (HorizontalCardModel) -> Void]? { get set }
    /// An instance of type *HorizontalBannersActionsDelegate* which represents the delegate for each view action in horizontal carousel.
    var actionsDelegate: HorizontalBannersActionsDelegate? { get set }

    /// A callback which is used to configure cell.
    /// - Parameter data: A dictionary which represents the cell data.
    func configure(with model: HorizontalCardModel)
}

/// A protocol which represnts the dual cards cell.
public protocol BaseDualCardsBannerCellProtocol where Self: BaseBannerCellProtocol {}

extension BaseDualCardsBannerCellProtocol {
    /// An enum instance of type *GallaryCardWidthType* which represnt the cell width type.
    public var cellWidthType: GalleryCardWidthType? {
        .dualViews(cellHeight: cellHeight ?? 0)
    }
}

/// A protocol which represnts the medium squared cell.
public protocol BaseMediumSquaredBannerCellProtocol where Self: BaseBannerCellProtocol {}

extension BaseMediumSquaredBannerCellProtocol {
    /// An enum instance of type *GallaryCardWidthType* which represnt the cell width type.
    public var cellWidthType: GalleryCardWidthType? {
        .mediumSquared(cellHeight: cellHeight ?? 0)
    }
}

/// A protocol which represnts the large width cell.
public protocol BaseLargeWidthBannerCellProtocol where Self: BaseBannerCellProtocol {}

extension BaseLargeWidthBannerCellProtocol {
    /// An enum instance of type *GallaryCardWidthType* which represnt the cell width type.
    public var cellWidthType: GalleryCardWidthType? {
        .largeWidth(collectionInset: (collectionInset ?? 0) * 2 + (minimumLineSpacing ?? 0))
    }
}
