//
//  VFGTutorialItemView.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 6/7/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

/// Single Item view in tutorial
class VFGTutorialItemView: UIView {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    @IBOutlet weak var titleToSubTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var tutorialImageView: VFGImageView!
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var dividerView: UIView!
    var video = VFGVideoViewController()

    /// A method used to configure tutorial item view.
    /// - Parameters:
    ///   - titleText: A string object represents tutorial view title.
    ///   - titleFont: An object of type *UIFont* that represents the title font.
    ///   - descriptionText: A string object represents tutorial view description..
    ///   - descriptionFont: An object of type *UIFont* that represents the description font.
    ///   - titleToSubTitleMargin: An object of type *CGFloat* that represents the margin between title and subtitle.
    ///   - image: An object of type *UIImage* that represents tutorial image view, default value is `nil`.
    ///   - imageBackgroundColor: An object of type *UIColor* that represents the background color of tutorial image.
    func configure(
        titleText: String?,
        titleFont: UIFont,
        descriptionText: String?,
        descriptionFont: UIFont,
        titleToSubTitleMargin: CGFloat,
        image: UIImage? = nil,
        imageBackgroundColor: UIColor? = nil,
        showDividerView: Bool? = false,
        imageCotentMode: ContentMode = .scaleAspectFit
    ) {
        titleLabel.text = titleText
        titleLabel.font = titleFont
        descriptionLabel.text = descriptionText
        descriptionLabel.font = descriptionFont
        titleToSubTitleConstraint.constant = titleToSubTitleMargin
        tutorialImageView.image = image
        tutorialImageView.contentMode = imageCotentMode
        tutorialImageView.backgroundColor = imageBackgroundColor
        setupVideoView()
        self.shouldGroupAccessibilityChildren = true
        titleLabel.accessibilityLabel = titleLabel.text
        descriptionLabel.accessibilityLabel = descriptionLabel.text
        dividerView.isHidden = !(showDividerView ?? false)
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        frame = bounds
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        // accessibility identifier
        setLabelsAccessibilityIdentifiers()
        setImageAccessibilityIdentifier()
        isUserInteractionEnabled = false
    }

    /// A method used to setup video view and adding it in video container view.
    func setupVideoView() {
        guard let videoView = video.view else {
            return
        }
        video.videoGravity = .resizeAspect
        video.showsPlaybackControls = false
        videoView.frame = video.videoBounds
        videoContainerView.embed(view: videoView)
    }
}
// MARK: - Configurations
private extension VFGTutorialItemView {
    /// Set accessibility identifiers for title and  description labels
    func setLabelsAccessibilityIdentifiers() {
        // title label
        titleLabel.accessibilityIdentifier = "tutorialTitleLabel"
        // description label
        descriptionLabel.accessibilityIdentifier = "tutorialDescriptionLabel"
    }
    /// Set accessibility identifier for tutorial image
    func setImageAccessibilityIdentifier() {
        tutorialImageView.isAccessibilityElement = true
        tutorialImageView.accessibilityIdentifier = "tutorialImageView"
    }
}
