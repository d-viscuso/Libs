//
//  StoryCircleCellExtensions.swift
//  VFGMVA10Framework
//
//  Created by Giovanni Romaniello on 16/06/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
import UIKit

extension StoryCircleCell {
    func setupContainer() {
        container = UIView()
        guard let container = container else {
            return
        }
        contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        contentView.embed(view: container, top: 0, bottom: 0, leading: 0, trailing: 0)
    }

    func setupImageBackgroundView() {
        imageBackgroundView = UIView()
        guard let imageBackgroundView = imageBackgroundView else {
            return
        }
        container?.addSubview(imageBackgroundView)
        imageBackgroundView.backgroundColor = .white
        imageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        imageBackgroundView.clipsToBounds = true
        let top = NSLayoutConstraint(
            item: imageBackgroundView,
            attribute: .top,
            relatedBy: .equal,
            toItem: container,
            attribute: .top,
            multiplier: 1,
            constant: 8)
        let center = NSLayoutConstraint(
            item: imageBackgroundView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: container,
            attribute: .centerX,
            multiplier: 1,
            constant: 0)
        let height = NSLayoutConstraint(
            item: imageBackgroundView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: imageSize + 8)
        let width = NSLayoutConstraint(
            item: imageBackgroundView,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: imageSize + 8)
        NSLayoutConstraint.activate([top, center, height, width])
        imageBackgroundView.layer.cornerRadius = (imageSize + 8) * 0.5
    }

    func setupImageView() {
        storyImageView = VFGImageView()
        guard let storyImageView = storyImageView, let imageBackgroundView = imageBackgroundView else {
            return
        }
        storyImageView.clipsToBounds = true
        imageBackgroundView.addSubview(storyImageView)
        storyImageView.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(
            item: storyImageView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: imageBackgroundView,
            attribute: .centerX,
            multiplier: 1,
            constant: 0)
        let centerY = NSLayoutConstraint(
            item: storyImageView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: imageBackgroundView,
            attribute: .centerY,
            multiplier: 1,
            constant: 0)
        let height = NSLayoutConstraint(
            item: storyImageView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: imageSize)
        let width = NSLayoutConstraint(
            item: storyImageView,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: imageSize)
        NSLayoutConstraint.activate([centerX, centerY, height, width])
        storyImageView.layer.cornerRadius = imageSize * 0.5
    }


    func setupTitleLabel() {
        titleLabel = VFGLabel()
        guard let titleLabel = titleLabel else {
            return
        }
        titleLabel.textColor = .black
        titleLabel.font = UIFont.vodafoneRegular(14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container?.addSubview(titleLabel)
        let left = NSLayoutConstraint(
            item: titleLabel,
            attribute: .left,
            relatedBy: .equal,
            toItem: storyImageView,
            attribute: .left,
            multiplier: 1,
            constant: 8)
        let right = NSLayoutConstraint(
            item: titleLabel,
            attribute: .right,
            relatedBy: .equal,
            toItem: storyImageView,
            attribute: .right,
            multiplier: 1,
            constant: -8)
        let top = NSLayoutConstraint(
            item: titleLabel,
            attribute: .top,
            relatedBy: .equal,
            toItem: storyImageView,
            attribute: .bottom,
            multiplier: 1,
            constant: 14)
        let bottom = NSLayoutConstraint(
            item: titleLabel,
            attribute: .bottom,
            relatedBy: .lessThanOrEqual,
            toItem: contentView,
            attribute: .bottom,
            multiplier: 1,
            constant: 0)
        NSLayoutConstraint.activate([left, right, top, bottom])
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
    }

    func setupStackView() {
        countdownView = UIView()
        guard let view = countdownView else {
            return
        }
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 13
        view.dropShadow()
        container?.addSubview(view)
        let left = NSLayoutConstraint(
            item: view,
            attribute: .left,
            relatedBy: .equal,
            toItem: imageBackgroundView,
            attribute: .left,
            multiplier: 1,
            constant: 0)
        let right = NSLayoutConstraint(
            item: view,
            attribute: .right,
            relatedBy: .equal,
            toItem: imageBackgroundView,
            attribute: .right,
            multiplier: 1,
            constant: 0)
        let height = NSLayoutConstraint(
            item: view,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: stackHeight)
        let top = NSLayoutConstraint(
            item: view,
            attribute: .top,
            relatedBy: .equal,
            toItem: imageBackgroundView,
            attribute: .bottom,
            multiplier: 1,
            constant: -(stackHeight - 8))
        NSLayoutConstraint.activate([left, right, top, height])
    }

    func addCountdownLabel() {
        guard let story = story, let view = countdownView,
            story.type == .countdown,
            countdownLabel == nil
        else {
            return
        }

        countdownLabel = VFGLabel()
        guard let countdownLabel = countdownLabel else {
            return
        }

        countdownLabel.font = UIFont.vodafoneRegular(12)
        countdownLabel.textAlignment = .center
        view.addSubview(countdownLabel)
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countdownLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            countdownLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func setupStackViewWithIcon() {
        iconView = UIView()
        guard let iconView = iconView else {
            return
        }
        iconView.backgroundColor = .white
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.layer.cornerRadius = 13
        iconView.dropShadow()
        container?.addSubview(iconView)
        let left = NSLayoutConstraint(
            item: iconView,
            attribute: .left,
            relatedBy: .equal,
            toItem: imageBackgroundView,
            attribute: .left,
            multiplier: 1,
            constant: 26)
        let width = NSLayoutConstraint(
            item: iconView,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: stackWidth)
        let height = NSLayoutConstraint(
            item: iconView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: stackHeight)
        let top = NSLayoutConstraint(
            item: iconView,
            attribute: .top,
            relatedBy: .equal,
            toItem: imageBackgroundView,
            attribute: .bottom,
            multiplier: 1,
            constant: -(stackHeight - 8))
        NSLayoutConstraint.activate([left, width, top, height])
        if let storyIcon = storyIcon {
            storyIcon.contentMode = .center
            iconView.addSubview(storyIcon)
            storyIcon.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                storyIcon.heightAnchor.constraint(equalTo: iconView.heightAnchor, multiplier: 1),
                storyIcon.widthAnchor.constraint(equalTo: iconView.widthAnchor, multiplier: 1),
                storyIcon.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
                storyIcon.centerYAnchor.constraint(equalTo: iconView.centerYAnchor)
            ])
        }
    }
}
