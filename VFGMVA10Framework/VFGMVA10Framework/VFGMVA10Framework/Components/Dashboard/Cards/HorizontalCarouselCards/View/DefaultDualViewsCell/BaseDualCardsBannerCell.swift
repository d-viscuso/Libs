//
//  BaseDualCardsBannerCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 02/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// A cell which represents base dual cards banner under type three cards.
/// It holds banner card which represents the base view for the whole subtypes of type three.
open class BaseDualCardsBannerCell: UICollectionViewCell {
    var topBannerCard: BannerCard?
    var bottomBannerCard: BannerCard?
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
    /// Top banner delegate.
    public weak var topBannerDelegate: BannerCardDelegate? {
        didSet {
            topBannerCard?.delegate = topBannerDelegate
        }
    }
    /// Bottom banner delegate.
    public weak var bottomBannerDelegate: BannerCardDelegate? {
        didSet {
            bottomBannerCard?.delegate = bottomBannerDelegate
        }
    }
    /// Top card action closure.
    public var topCardDidPress: (() -> Void)? {
        didSet {
            topBannerCard?.bannerAction = topCardDidPress
        }
    }
    /// Bottom card action closure.
    public var bottomCardDidPress: (() -> Void)? {
        didSet {
            bottomBannerCard?.bannerAction = bottomCardDidPress
        }
    }

    let cardsSpacing: CGFloat = 8

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupTopView()
        setupBottomView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupTopView() {
        topBannerCard = BannerCard()
        contentView.addSubview(topBannerCard ?? UIView())
        topBannerCard?.fresh.makeConstraints { make in
            make.top == self.contentView.fresh.top
            make.left == self.contentView.fresh.left
            make.right == self.contentView.fresh.right
        }
        setupCardShadow(topBannerCard ?? UIView())
    }

    private func setupBottomView() {
        bottomBannerCard = BannerCard()
        guard let topBannerCard = topBannerCard else { return }
        contentView.addSubview(bottomBannerCard ?? UIView())
        bottomBannerCard?.fresh.makeConstraints { make in
            make.top == topBannerCard.fresh.bottom + cardsSpacing
            make.bottom == self.contentView.fresh.bottom
            make.left == self.contentView.fresh.left
            make.right == self.contentView.fresh.right
            make.height == topBannerCard.fresh.height
        }
        setupCardShadow(bottomBannerCard ?? UIView())
    }

    private func setupCardShadow(_ view: UIView) {
        view.dropShadow(
            color: UIColor.VFGVeryLightGreyDarkBackground,
            alpha: 0.16,
            x: 0,
            y: 2,
            blur: 6,
            spread: 0)
    }

    /// A method used to add content view to top banner card.
    /// - Parameter view: An instance which represents the added view.
    public func addTopContentView(_ view: UIView) {
        topBannerCard?.setup(contentView: view)
    }

    /// A method used to add content view to bottom banner card.
    /// - Parameter view: An instance which represents the added view.
    public func addBottomContentView(_ view: UIView) {
        bottomBannerCard?.setup(contentView: view)
    }

    /// A method used to configure top card with data model.
    /// - Parameter model: A model of type *HorizontalDualCardModel* which holds top card data.
    public func configureTopCard(with model: HorizontalDualCardModel) {
        topBannerCard?.configure(with: BannerCardModel(
            bgImage: model.bgImage,
            showGradientOverlay: model.showGradientOverlay,
            gradientDirection: model.gradientDirection
        ))
    }

    /// A method used to configure bottom card with data model.
    /// - Parameter model: A model of type *HorizontalDualCardModel* which holds bottom card data.
    open func configureBottomCard(with model: HorizontalDualCardModel) {
        bottomBannerCard?.configure(with: BannerCardModel(
            bgImage: model.bgImage,
            showGradientOverlay: model.showGradientOverlay,
            gradientDirection: model.gradientDirection
        ))
    }
}

extension BaseDualCardsBannerCell: BaseDualCardsBannerCellProtocol {
    /// A callback which is used to configure cell.
    /// - Parameter data: A dictionary which represents the cell data.
    public func configure(with model: HorizontalCardModel) {
        guard
            let dataDictionary = model.data,
            let response = try? JSONDecoder.decode(dataDictionary, to: HorizontalDualCardsModel.self)
        else {
            return
        }
        configureTopCard(with: response.topCard)
        configureBottomCard(with: response.bottomCard)
        topCardDidPress = { [weak self] in
            guard let self else { return }
            self.actionsDelegate?.didSelectTopCard(for: model, with: response.topCard)
            let action = self.bannerActions?[response.topCard.actionId ?? ""]
            action?(model)
        }
        bottomCardDidPress = { [weak self] in
            guard let self else { return }
            self.actionsDelegate?.didSelectBottomCard(for: model, with: response.bottomCard)
            let action = self.bannerActions?[response.bottomCard.actionId ?? ""]
            action?(model)
        }
    }
}
