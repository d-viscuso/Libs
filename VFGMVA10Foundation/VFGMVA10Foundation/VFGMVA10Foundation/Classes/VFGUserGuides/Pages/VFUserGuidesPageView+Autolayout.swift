//
//  VFFTEPageView+Autolayout.swift
//  MyVodafone
//
//  Created by Alberto Garcia-Muñoz on 24/07/2019.
//  Copyright © 2019 TSSE. All rights reserved.
//

import Foundation
import UIKit

extension VFUserGuidesPageView {
    func configure() {
        addContainerView()
        addTitleLabel()
        addSubtitleLabel()
        addImageView()
        addDescriptionLabel()
    }

    private func addContainerView() {
        self.containerView = UIView(frame: bounds)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        let height = containerView.heightAnchor.constraint(equalTo: heightAnchor)
        height.priority = .defaultLow
        height.isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }

    private func addTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        containerView.addSubview(titleLabel)
        let topAnchor = containerView.topAnchor
        let leadingAnchor = containerView.leadingAnchor
        let trailingAnchor = containerView.trailingAnchor

        titleLabel.topAnchor.constraint(equalTo: topAnchor ).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }

    private func addSubtitleLabel() {
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.numberOfLines = 0
        containerView.addSubview(subtitleLabel)
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
    }

    private func addImageView() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        containerView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16).isActive = true
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        let width = imageView.widthAnchor
        self.imageHeightConstraint = imageView.heightAnchor.constraint(equalTo: width, multiplier: 0.001)
        imageHeightConstraint?.isActive = true
    }

    private func addDescriptionLabel() {
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        containerView.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        let anchor = containerView.bottomAnchor
        let constraint = descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: -16)
        constraint.isActive = true
    }
}
