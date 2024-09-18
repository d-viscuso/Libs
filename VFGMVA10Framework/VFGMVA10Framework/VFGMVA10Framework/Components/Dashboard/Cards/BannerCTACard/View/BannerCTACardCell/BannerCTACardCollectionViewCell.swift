//
//  BannerCTACardCollectionViewCell.swift
//  VFGMVA10Framework
//
//  Created by İhsan Kahramanoğlu on 12/27/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class BannerCTACardCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var holderView: UIView!
    @IBOutlet private weak var bannerImageView: VFGImageView!
    @IBOutlet private weak var pointsBadgeView: VFGPointsBadgeView!
    @IBOutlet private weak var titleLabel: VFGLabel!
    @IBOutlet private weak var ctaButtonsStackView: UIStackView!
    @IBOutlet private weak var firstCTAButton: VFGButton!
    @IBOutlet private weak var secondCTAButton: VFGButton!
    @IBOutlet private weak var bannerImageViewHeightConstraint: NSLayoutConstraint!

    static let smallCardCellHeight: CGFloat = 215
    static let largeCardCellHeight: CGFloat = 310
    private var model: BannerCTACardItemModel?
    private weak var delegate: BannerCTACardDelegate?
    private let smallBannerImageHeight: CGFloat = 85
    private let largeBannerImageHeight: CGFloat = 160

    override func awakeFromNib() {
        super.awakeFromNib()
        setupHolderView()
        setupCTAButtons()
        setupImageView()
    }

    private func setupHolderView() {
        holderView.roundCorners()
        holderView.dropShadow(
            color: UIColor.VFGVeryLightGreyDarkBackground,
            alpha: 0.16,
            x: 0,
            y: 2,
            blur: 6,
            spread: 0)
    }

    private func setupCTAButtons() {
        firstCTAButton.buttonStyle = VFGButton.ButtonStyle.secondary.rawValue
        secondCTAButton.buttonStyle = VFGButton.ButtonStyle.alt1.rawValue
    }

    private func setupImageView() {
        bannerImageView.roundUpperCorners(cornerRadius: 6)
    }

    func configure(
        model: BannerCTACardItemModel,
        type: BannerCTACardType,
        delegate: BannerCTACardDelegate?
    ) {
        self.model = model
        self.delegate = delegate

        switch type {
        case .small:
            bannerImageViewHeightConstraint.constant = smallBannerImageHeight
            titleLabel.numberOfLines = 1
        case .large:
            bannerImageViewHeightConstraint.constant = largeBannerImageHeight
            titleLabel.numberOfLines = 2
        }
        layoutIfNeeded()

        let attributedString = NSMutableAttributedString(
            string: model.title ?? "",
            attributes: [NSAttributedString.Key.font: UIFont.vodafoneLite(20)])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        paragraphStyle.alignment = .left
        attributedString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        titleLabel.attributedText = attributedString

        if let image = model.image {
            bannerImageView.download(by: image, placeholder: VFGImage(named: model.placeholderImage))
        }
        titleLabel.text = model.title
        firstCTAButton.setTitle(model.firstCTAButtonTitle, for: .normal)

        if let isEmpty = model.secondCTAButtonTitle?.isEmpty, !isEmpty {
            secondCTAButton.setTitle(model.secondCTAButtonTitle, for: .normal)
            secondCTAButton.isHidden = false
        } else {
            secondCTAButton.isHidden = true
        }
        if let points = model.points {
            pointsBadgeView.isHidden = false
            pointsBadgeView.configure(with: points)
        } else {
            pointsBadgeView.isHidden = true
        }
    }

    @IBAction func firstCTAButtonClicked(_ sender: Any) {
        guard let model = model else { return }
        delegate?.bannerFirstCTAButtonDidPress(model)
    }

    @IBAction func secondCTAButtonClicked(_ sender: Any) {
        guard let model = model else { return }
        delegate?.bannerSecondCTAButtonDidPress(model)
    }
}
