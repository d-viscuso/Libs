//
//  BaseMediumSquaredBannerCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 02/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// A cell which represents base medium squared banner under type two cards.
/// It holds banner card which represents the base view for the whole subtypes of type two.
open class BaseMediumSquaredBannerCell: UICollectionViewCell {
    var bannerCard: BannerCard?
    var dataDictionary: [String: Any]?

    /// An instance of type *CGFloat* which represents any inset that affect collection view width.
    public var collectionInset: CGFloat?
    /// An instance of type *CGFloat* which represents the space between each cell.
    public var minimumLineSpacing: CGFloat?
    /// An instance of type *CGFloat* which represents the cell height.
    public var cellHeight: CGFloat?
    /// A dictionary which represents a list of keys and actions.
    public var bannerActions: [String: (HorizontalCardModel) -> Void]?
    public var actionsDelegate: HorizontalBannersActionsDelegate?
    /// Banner delegate.
    public weak var bannerDelegate: BannerCardDelegate? {
        didSet {
            bannerCard?.delegate = bannerDelegate
        }
    }
    /// Card action closure.
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

    private func setupContentView() {
        guard let cellHeight = cellHeight else { return }
        contentView.fresh.makeConstraints { make in
            make.width == cellHeight + 20
            make.height == cellHeight
        }
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

    /// A method used to add content view to banner card.
    /// - Parameter view: An instance which represents the added view.
    public func addContentView(_ view: UIView) {
        bannerCard?.setup(contentView: view)
    }

    /// A method used to configure cell with data model.
    /// - Parameter model: A model of type *HorizontalCardItem* which holds cell data.
    public func configure(with model: HorizontalMediumSquaredCardModel) {
        bannerCard?.configure(with: BannerCardModel(
            bgImage: model.bgImage,
            link: model.link,
            showGradientOverlay: model.showGradientOverlay,
            gradientDirection: model.gradientDirection
        ))
    }
}

extension BaseMediumSquaredBannerCell: BaseMediumSquaredBannerCellProtocol {
    /// A callback which is used to configure cell.
    /// - Parameter data: A dictionary which represents the cell data.
    public func configure(with model: HorizontalCardModel) {
        guard
            let dataDictionary = model.data,
            let response = try? JSONDecoder.decode(dataDictionary, to: HorizontalMediumSquaredCardModel.self)
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
