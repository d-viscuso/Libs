//
//  BaseLargeWidthBannerCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 24/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// A cell which represents base banner cell which is the parent of the subtypes of type one card.
/// It holds banner card which represents the base view for the whole subtypes of type one.
open class BaseLargeWidthBannerCell: UICollectionViewCell {
    var bannerCard: BannerCard?
    var dataDictionary: [String: Any]?

    public var collectionInset: CGFloat?
    public var minimumLineSpacing: CGFloat?
    public var cellHeight: CGFloat?
    public var bannerActions: [String: (HorizontalCardModel) -> Void]?
    public var actionsDelegate: HorizontalBannersActionsDelegate?
    public weak var bannerDelegate: BannerCardDelegate? {
        didSet {
            bannerCard?.delegate = bannerDelegate
        }
    }
    public var cardDidPress: (() -> Void)? {
        didSet {
            bannerCard?.bannerAction = cardDidPress
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupView() {
        bannerCard = BannerCard()
        contentView.addSubview(bannerCard ?? BannerCard())
        bannerCard?.frame = contentView.bounds
        bannerCard?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.dropShadow(
            color: UIColor.VFGVeryLightGreyDarkBackground,
            alpha: 0.16,
            x: 0,
            y: 2,
            blur: 6,
            spread: 0)
    }

    open func addContentView(_ view: UIView) {
        bannerCard?.setup(contentView: view)
    }

    /// A method used to configure cell with data model.
    /// - Parameter model: A model of type *HorizontalCardItem* which holds cell data.
    public func configure(with model: HorizontalLargeWidthCardModel) {
        bannerCard?.configure(with: BannerCardModel(
            bgImage: model.bgImage,
            points: model.points,
            link: model.link,
            showGradientOverlay: model.showGradientOverlay,
            gradientDirection: model.gradientDirection))
    }
}

extension BaseLargeWidthBannerCell: BaseLargeWidthBannerCellProtocol {
    /// A callback which is used to configure cell.
    /// - Parameter data: A dictionary which represents the cell data.
    public func configure(with model: HorizontalCardModel) {
        guard
            let dataDictionary = model.data,
            let response = try? JSONDecoder.decode(dataDictionary, to: HorizontalLargeWidthCardModel.self)
        else {
            return
        }
        configure(with: response)
        cardDidPress = { [weak self] in
            guard let self else { return }
            self.actionsDelegate?.didSelectCard(for: model, with: response)
            let action = self.bannerActions?[response.actionId ?? ""]
            action?(model)
        }
    }
}
