//
//  MarketplaceProductCollectionViewCell.swift
//  VFGMVA10Framework
//
//  Created by Giovanni Romaniello on 10/10/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// VFGMarketplaceProductCellInterface to be implemented by marketplace cells
public protocol VFGMarketplaceProductCellInterface: AnyObject {
    /// refresh the cell content
    func refresh()
}

class VFGMarketplaceProductCollectionViewCell: UICollectionViewCell {
    var viewModel: VFGMarketplaceProductViewModelProtocol?
    var wishButton: VFGButton?
    var imageView: VFGImageView?
    var happyStack: UIStackView?
    var happyIcon: VFGImageView?
    var happyLabel: VFGLabel?
    var productLabel: VFGLabel?
    var currentPriceLabel: VFGLabel?
    var formerPriceLabel: VFGLabel?
    var priceStack: UIStackView?
    let wishButtonSize: CGFloat = 13
    let wishButtonMargins: CGFloat = 10
    let imageViewHeight: CGFloat = 96
    let defaultMargins: CGFloat = 8
    let happyWidth: CGFloat = 55
    let happyHeight: CGFloat = 24
    let happyIconSize: CGFloat = 16

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.backgroundColor = .clear
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 6
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        setupWishButton()
        setupImage()
        setupHappyPoints()
        setupLabel()
        setupPrices()
    }

    private func setupWishButton() {
        wishButton = VFGButton()
        wishButton?.addTarget(self, action: #selector(didSelectWishButton), for: .touchUpInside)
        let hearthImage = VFGFrameworkAsset.Image.icHearth
        let hearthImageFull = VFGFrameworkAsset.Image.icHearthFull
        wishButton?.setBackgroundImage(hearthImage, for: .normal)
        wishButton?.setBackgroundImage(hearthImageFull, for: .selected)
        wishButton?.contentMode = .scaleAspectFit
        guard let wishButton = wishButton else {
            return
        }
        contentView.addSubview(wishButton)
        wishButton.fresh.makeConstraints { make in
            make.height == self.wishButtonSize
            make.width == self.wishButtonSize
            make.top == self.contentView.fresh.top + self.wishButtonMargins
            make.right == self.contentView.fresh.right - self.wishButtonMargins
        }
    }

    @objc func didSelectWishButton() {
        viewModel?.toggleWishlist()
    }

    private func setupImage() {
        imageView = VFGImageView()
        imageView?.contentMode = .scaleAspectFit
        guard let imageView = self.imageView, let wishButton = self.wishButton else {
            return
        }
        contentView.addSubview(imageView)
        imageView.fresh.makeConstraints { make in
            make.top == wishButton.fresh.bottom + self.defaultMargins * 2
            make.left == self.contentView.fresh.left + self.defaultMargins
            make.right == self.contentView.fresh.right - self.defaultMargins
            make.height == self.imageViewHeight
        }
    }

    private func setupHappyPoints() {
        happyStack = UIStackView()
        happyStack?.axis = .horizontal
        happyStack?.distribution = .fillEqually
        happyStack?.alignment = .center
        happyStack?.layer.cornerRadius = defaultMargins
        happyStack?.layer.borderWidth = 1
        happyStack?.layer.borderColor = UIColor.VFGDarkGreyBackground.cgColor
        happyIcon = VFGImageView()
        happyIcon?.image = VFGFrameworkAsset.Image.icHappy
        happyIcon?.contentMode = .scaleAspectFit
        happyLabel = VFGLabel()
        happyLabel?.numberOfLines = 1
        happyLabel?.font = UIFont.vodafoneRegular(14)
        happyLabel?.textColor = .redTextColor
        guard let imageView = self.imageView,
            let happyIcon = self.happyIcon,
            let happyLabel = self.happyLabel,
            let happyStack = self.happyStack else {
            return
        }
        contentView.addSubview(happyStack)
        happyStack.fresh.makeConstraints { make in
            make.width == self.happyWidth
            make.height == self.happyHeight
            make.left == self.contentView.fresh.left + self.defaultMargins
            make.top == imageView.fresh.bottom + self.defaultMargins
        }
        happyStack.addArrangedSubview(happyIcon)
        happyIcon.fresh.makeConstraints { make in
            make.width == self.happyIconSize
            make.height == self.happyIconSize
        }
        happyStack.addArrangedSubview(happyLabel)
    }

    private func setupLabel() {
        productLabel = VFGLabel()
        productLabel?.numberOfLines = 2
        productLabel?.font = .vodafoneRegular(14)
        productLabel?.textColor = .VFGPrimaryText
        guard let productLabel = self.productLabel,
            let happyStack = self.happyStack else {
            return
        }
        contentView.addSubview(productLabel)
        productLabel.fresh.makeConstraints { make in
            make.left == self.contentView.fresh.left + self.defaultMargins
            make.right == self.contentView.fresh.right - self.defaultMargins
            make.top == happyStack.fresh.bottom + self.defaultMargins
        }
    }

    private func setupPrices() {
        priceStack = UIStackView()
        priceStack?.axis = .horizontal
        priceStack?.spacing = defaultMargins
        priceStack?.distribution = .fillProportionally
        priceStack?.alignment = .leading
        currentPriceLabel = VFGLabel()
        currentPriceLabel?.font = .vodafoneBold(16)
        currentPriceLabel?.textColor = .VFGDarkerAquaBackground
        formerPriceLabel = VFGLabel()
        formerPriceLabel?.font = .vodafoneRegular(16)
        formerPriceLabel?.textColor = .VFGGreyBorder
        guard let priceStack = priceStack,
        let productLabel = self.productLabel,
        let currentPriceLabel = self.currentPriceLabel,
        let formerPriceLabel = self.formerPriceLabel else {
            return
        }
        contentView.addSubview(priceStack)
        priceStack.fresh.makeConstraints { make in
            make.left == self.contentView.fresh.left + self.defaultMargins
            make.right <= self.contentView.fresh.right - self.defaultMargins
            make.top == productLabel.fresh.bottom + self.defaultMargins
            make.bottom <= self.contentView.fresh.bottom - self.defaultMargins
        }
        priceStack.addArrangedSubview(currentPriceLabel)
        priceStack.addArrangedSubview(formerPriceLabel)
    }

    func configure(with viewModel: VFGMarketplaceProductViewModelProtocol) {
        self.viewModel = viewModel
        self.viewModel?.cellInterface = self
        configureImage()
        configureWishButton()
        configureHappy()
        configureLabel()
        configurePrices()
    }

    private func configureImage() {
        guard let imageUrlString = viewModel?.imageUrl,
            let imageUrl = URL(string: imageUrlString) else {
            return
        }
        imageView?.download(from: imageUrl)
    }

    private func configureWishButton() {
        wishButton?.isHidden = viewModel?.showWishButton == false
        wishButton?.isSelected = viewModel?.isWish == true
    }

    private func configureHappy() {
        happyStack?.isHidden = viewModel?.showHappyPoints == false
        happyLabel?.text = viewModel?.happyPoints
    }

    private func configureLabel() {
        productLabel?.text = viewModel?.productName
    }

    private func configurePrices() {
        currentPriceLabel?.isHidden = viewModel?.showCurrentPrice == false
        currentPriceLabel?.text = viewModel?.currentPrice
        formerPriceLabel?.isHidden = viewModel?.showFormerPrice == false
        formerPriceLabel?.attributedText = viewModel?.formerPrice
        if formerPriceLabel?.isHidden == false {
            currentPriceLabel?.textColor = .VFGDarkerAquaBackground
        } else {
            currentPriceLabel?.textColor = .VFGPrimaryText
        }
    }
}

extension VFGMarketplaceProductCollectionViewCell: VFGMarketplaceProductCellInterface {
    func refresh() {
        configureImage()
        configureWishButton()
        configureHappy()
        configureLabel()
        configurePrices()
    }
}
