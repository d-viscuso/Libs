//
//  HorizontalBannersActionsDelegate.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 23/03/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import Foundation

/// A protocol which represents the horizontal banners actions delegate.
/// You can use the suitable action method for specific type to provide a suitable implementation.
public protocol HorizontalBannersActionsDelegate: AnyObject {
    /// A callback which is used to provide an action for banners of type *HorizontalLargeWidthCardModel*.
    /// - Parameters:
    ///   - item: An instance of type *HorizontalCardModel* which holds cell id, type and a data dictionary.
    ///   - data: An instance of type *HorizontalLargeWidthCardModel* which represents the model for horizontal large width card.
    func didSelectCard(for item: HorizontalCardModel, with data: HorizontalLargeWidthCardModel)
    /// A callback which is used to provide an action for banners of type *HorizontalMediumSquaredCardModel*.
    /// - Parameters:
    ///   - item: An instance of type *HorizontalCardModel* which holds cell id, type and a data dictionary.
    ///   - data: An instance of type *HorizontalMediumSquaredCardModel* which represents the model for horizontal medium square card.
    func didSelectCard(for item: HorizontalCardModel, with data: HorizontalMediumSquaredCardModel)
    /// A callback which is used to provide an action for top view in banners of type *HorizontalDualCardModel* .
    /// - Parameters:
    ///   - item: An instance of type *HorizontalCardModel* which holds cell id, type and a data dictionary.
    ///   - data: An instance of type *HorizontalMediumSquaredCardModel* which represents the model for horizontal dual card.
    func didSelectTopCard(for item: HorizontalCardModel, with data: HorizontalDualCardModel)
    /// A callback which is used to provide an action for bottom view in banners of type *HorizontalDualCardModel* .
    /// - Parameters:
    ///   - item: An instance of type *HorizontalCardModel* which holds cell id, type and a data dictionary.
    ///   - data: An instance of type *HorizontalMediumSquaredCardModel* which represents the model for horizontal dual card.
    func didSelectBottomCard(for item: HorizontalCardModel, with data: HorizontalDualCardModel)
}

extension HorizontalBannersActionsDelegate {
    public func didSelectCard(for item: HorizontalCardModel, with data: HorizontalLargeWidthCardModel) {}
    public func didSelectCard(for item: HorizontalCardModel, with data: HorizontalMediumSquaredCardModel) {}
    public func didSelectTopCard(for item: HorizontalCardModel, with data: HorizontalDualCardModel) {}
    public func didSelectBottomCard(for item: HorizontalCardModel, with data: HorizontalDualCardModel) {}
}
