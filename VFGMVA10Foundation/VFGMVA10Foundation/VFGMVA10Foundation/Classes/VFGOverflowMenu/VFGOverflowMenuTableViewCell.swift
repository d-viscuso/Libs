//
//  VFGOverflowMenuTableViewCell.swift
//  VFGMVA10Foundation
//
//  Created by Fafoutis, Athinodoros, Vodafone Greece on 25/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

class VFGOverflowMenuTableViewCell: UITableViewCell {
    lazy var leadingImageView: UIImageView = {
        let leadingImageView = UIImageView()
        leadingImageView.isAccessibilityElement = true
        leadingImageView.accessibilityTraits = .image
        leadingImageView.translatesAutoresizingMaskIntoConstraints = false
        leadingImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        leadingImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true

        return leadingImageView
    }()

    let textsContainer: UIView = {
        let textsContainer = UIView()
        textsContainer.translatesAutoresizingMaskIntoConstraints = false
        textsContainer.backgroundColor = .clear

        return textsContainer
    }()

    let primaryLabel: VFGLabel = {
        let primaryLabel = VFGLabel()
        primaryLabel.isAccessibilityElement = true
        primaryLabel.translatesAutoresizingMaskIntoConstraints = false
        primaryLabel.textColor = UIColor.VFGPrimaryText
        primaryLabel.numberOfLines = 0
        primaryLabel.lineBreakMode = .byWordWrapping

        return primaryLabel
    }()

    lazy var secondaryLabel: VFGLabel = {
        let secondaryLabel = VFGLabel()
        secondaryLabel.isAccessibilityElement = true
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.font = .vodafoneRegular(14)
        secondaryLabel.textColor = UIColor.VFGPrimaryText
        secondaryLabel.numberOfLines = 0
        secondaryLabel.lineBreakMode = .byWordWrapping

        return secondaryLabel
    }()

    let separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.backgroundColor = UIColor.VFGOverflowMenuSeparator

        return separatorView
    }()

    required init?(coder aDecoder: NSCoder) {
        // init(coder:) has not been implemented
        return nil
    }

    init(
        with model: VFGOverflowMenuItem,
        shouldHideSeparator: Bool,
        isHashingTextEnabled: Bool = false,
        isSelected: Bool,
        accessibilityModel: VFGOverflowMenuAccessibilityModel = VFGOverflowMenuAccessibilityModel()
    ) {
        super.init(style: .default, reuseIdentifier: "VFGOverflowMenuTableViewCell")
        configure(
            with: model,
            shouldHideSeparator: shouldHideSeparator,
            isHashingTextEnabled: isHashingTextEnabled,
            isSelected: isSelected)

        selectionStyle = .none
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true

        addLeadingImageIfNeeded()
        addTexts()
        addSeparator()
        setupAccessibility(accessibilityModel: accessibilityModel)
    }

    private func addLeadingImageIfNeeded() {
        if leadingImageView.image != nil {
            contentView.addSubview(leadingImageView)
            setupLeadingImageViewConstraints()
        }
    }
    private func setupLeadingImageViewConstraints() {
        let leadingImageViewTopAnchor = leadingImageView
            .topAnchor
            .constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8)
        leadingImageViewTopAnchor.priority = .defaultLow
        let leadingImageViewBottomAnchor = leadingImageView
            .bottomAnchor
            .constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        leadingImageViewBottomAnchor.priority = .defaultLow

        NSLayoutConstraint.activate([
            leadingImageViewTopAnchor,
            leadingImageViewBottomAnchor,
            leadingImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leadingImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }

    private func addTexts() {
        contentView.addSubview(textsContainer)
        setupTextsContainerConstraints()

        if secondaryLabel.text != nil {
            textsContainer.addSubview(secondaryLabel)
            setupSecondaryLabelConstraints()
        }

        textsContainer.addSubview(primaryLabel)
        setupPrimaryLabelConstraints()
    }
    private func setupTextsContainerConstraints() {
        let textsContainerTopAnchor = textsContainer
            .topAnchor
            .constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8)
        textsContainerTopAnchor.priority = .defaultLow
        let textsContainerBottomAnchor = textsContainer
            .bottomAnchor
            .constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        textsContainerBottomAnchor.priority = .defaultLow
        let textsContainerLeadingAnchor = leadingImageView.image != nil
            ? textsContainer.leadingAnchor.constraint(equalTo: leadingImageView.trailingAnchor, constant: 8)
            : textsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)

        NSLayoutConstraint.activate([
            textsContainerTopAnchor,
            textsContainerBottomAnchor,
            textsContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textsContainerLeadingAnchor,
            textsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    private func setupPrimaryLabelConstraints() {
        let primaryLabelBottomConstraint = secondaryLabel.text != nil
            ? primaryLabel.bottomAnchor.constraint(equalTo: secondaryLabel.topAnchor)
            : primaryLabel.bottomAnchor.constraint(equalTo: textsContainer.bottomAnchor)
        NSLayoutConstraint.activate([
            primaryLabel.topAnchor.constraint(equalTo: textsContainer.topAnchor),
            primaryLabelBottomConstraint,
            primaryLabel.trailingAnchor.constraint(equalTo: textsContainer.trailingAnchor),
            primaryLabel.leadingAnchor.constraint(equalTo: textsContainer.leadingAnchor)
        ])
    }

    private func setupSecondaryLabelConstraints() {
        NSLayoutConstraint.activate([
            secondaryLabel.trailingAnchor.constraint(equalTo: textsContainer.trailingAnchor),
            secondaryLabel.leadingAnchor.constraint(equalTo: textsContainer.leadingAnchor),
            secondaryLabel.bottomAnchor.constraint(equalTo: textsContainer.bottomAnchor)
        ])
    }

    private func addSeparator() {
        contentView.addSubview(separatorView)
        setupSeparatorConstraints()
    }

    private func setupSeparatorConstraints() {
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func configure(
        with model: VFGOverflowMenuItem,
        shouldHideSeparator: Bool,
        isHashingTextEnabled: Bool = false,
        isSelected: Bool,
        accessibilityModel: VFGOverflowMenuAccessibilityModel = VFGOverflowMenuAccessibilityModel()
    ) {
        backgroundColor = isSelected ? UIColor.VFGOverflowMenuSelectedCell : UIColor.VFGOverflowMenuBackground
        primaryLabel.text = isHashingTextEnabled ? model.primaryText.hashWithAsterisk() : model.primaryText
        primaryLabel.accessibilityLabel = primaryLabel.text ?? ""
        if let secondaryText = model.secondaryText {
            secondaryLabel.text = secondaryText
            secondaryLabel.accessibilityLabel = secondaryLabel.text ?? ""
            primaryLabel.font = .vodafoneBold(14)
        } else {
            primaryLabel.font = .vodafoneRegular(18)
        }

        if let leadingImage = model.leadingImage {
            leadingImageView.image = leadingImage
            leadingImageView.accessibilityLabel = model.leadingImageDesc ?? ""
        }

        separatorView.isHidden = shouldHideSeparator
        setupAccessibility(accessibilityModel: accessibilityModel)
    }

    private func setupAccessibility(accessibilityModel: VFGOverflowMenuAccessibilityModel) {
        primaryLabel.accessibilityIdentifier = accessibilityModel.primaryText
        secondaryLabel.accessibilityIdentifier = accessibilityModel.secondaryText
        leadingImageView.accessibilityIdentifier = accessibilityModel.leadingImage
    }
}
