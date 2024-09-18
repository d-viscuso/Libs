//
//  VFEditorialView.swift
//  VFGMVA10Framework
//
//  Created by Hamsa Hassan on 10/31/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// Editorial View 
public class VFEditorialView: UIView {
    @IBOutlet weak var editorialImageView: VFGImageView!
    @IBOutlet weak var editorialTitleLabel: VFGLabel!
    @IBOutlet weak var editorialDescriptionLabel: VFGLabel!
    @IBOutlet weak var editorialImageHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var editorialSubView: UIView!
    @IBOutlet weak var editorialSubViewWidth: NSLayoutConstraint!

    /// Video View Controller Object
    public var video = VFGVideoViewController()
    /// Action for the Item
    public var itemAction: (() -> Void)?
    /// Array of dashboard actions 
    let actions = VFGManagerFramework.dashboardDelegate?.dashboardActions()
    /// Accessiblity description of the image view.
    private var imageViewAXDescription: String?

    public var item: VFGDashboardItem? {
        didSet {
            setup()
            setNeedsLayout()
            layoutIfNeeded()
            setupVoiceoverAccessibility()
        }
    }

    private func setup() {
        editorialSubViewWidth.constant = UIScreen.main.bounds.width - Constants.Dashboard.Layout.margin
        guard let item = item, let itemData = item.metaData else {
            return
        }
        if itemData[VFEditorialItemMetaDataKeys.title] != nil &&
            itemData[VFEditorialItemMetaDataKeys.videoURLString] == nil {
            setupImageView()
        } else {
            setupVideoView()
        }
        let title = itemData[VFEditorialItemMetaDataKeys.title] as? String
        let description = itemData[VFEditorialItemMetaDataKeys.description] as? String
        editorialTitleLabel.text = title?.localized()
        editorialDescriptionLabel.text = description?.localized()
        if let itemId = item.itemActionId {
            itemAction = actions?[itemId]
        }
    }

    private func setupVideoView() {
        let videoViewContainer = UIView()
        let url = item?.metaData?[VFEditorialItemMetaDataKeys.videoURLString]
        video.videoURLString = url as? String
        guard let videoView = video.view else {
            return
        }

        videoViewContainer.translatesAutoresizingMaskIntoConstraints = false
        video.videoGravity = .resizeAspectFill
        videoView.frame = video.videoBounds
        videoViewContainer.addSubview(videoView)
        editorialSubView.addSubview(videoViewContainer)
        videoViewContainer.topAnchor.constraint(equalTo: editorialImageView.topAnchor).isActive = true
        videoViewContainer.bottomAnchor.constraint(equalTo: editorialImageView.bottomAnchor).isActive = true
        videoViewContainer.trailingAnchor.constraint(equalTo: editorialImageView.trailingAnchor).isActive = true
        videoViewContainer.leadingAnchor.constraint(equalTo: editorialImageView.leadingAnchor).isActive = true
        videoViewContainer.isAccessibilityElement = false
        imageViewAXDescription = "Video Preview"
    }

    private func setupImageView() {
        guard let editorialImage = item?.metaData?[VFEditorialItemMetaDataKeys.image] as? String else {
            return
        }
        editorialImageView.image = UIImage(named: editorialImage)
        editorialImageView.translatesAutoresizingMaskIntoConstraints = false
        let imageHeight = UIImage.image(named: editorialImage)?.size.height
        let imageWidth = UIImage.image(named: editorialImage)?.size.width
        if imageWidth == imageHeight {
            // if the image has equal width and height ratio will be 1:1
            let newConstraint = NSLayoutConstraint(
                item: editorialImageView as Any,
                attribute: .width,
                relatedBy: .equal,
                toItem: editorialImageView,
                attribute: .height,
                multiplier: 1.0,
                constant: 0)
            newConstraint.isActive = true
            editorialImageView.addConstraint(newConstraint)
        } else {
            //    if width is greater than the height ratio will be 16:9
            let newConstraint = NSLayoutConstraint(
                item: editorialImageView as Any,
                attribute: .width,
                relatedBy: .equal,
                toItem: editorialImageView,
                attribute: .height,
                multiplier: 16.0 / 9.0,
                constant: 0)
            newConstraint.isActive = true
            editorialImageView.addConstraint(newConstraint)
        }
        imageViewAXDescription = "Image Preview"
    }

    private func setupVoiceoverAccessibility() {
        isAccessibilityElement = false
        video.isAccessibilityElement = false
        editorialImageView.isAccessibilityElement = true
        editorialImageView.accessibilityValue = imageViewAXDescription
        editorialTitleLabel.isAccessibilityElement = true
        editorialTitleLabel.accessibilityLabel = editorialTitleLabel.text?.replacingOccurrences(of: "#", with: "")
        editorialDescriptionLabel.isAccessibilityElement = true
        editorialDescriptionLabel.accessibilityLabel = editorialDescriptionLabel.text
    }
}
