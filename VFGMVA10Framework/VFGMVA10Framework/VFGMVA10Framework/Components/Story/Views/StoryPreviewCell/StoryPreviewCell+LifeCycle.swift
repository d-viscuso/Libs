//
//  StoryPreviewCell+LifeCycle.swift
//  VFGMVA10Framework
//
//  Created by Ihsan Kahramanoglu on 29.07.2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

extension StoryPreviewCell {
    func willDisplayCell() {
        VFGDebugLog("\(story?.title ?? "") willDisplayCell")
        guard let story = story,
            let displayedStory = getDisplayedStory()
        else { return }

        headerView?.updateProgressViews(for: story.lastViewedMultipleStoryIndex)
        headerView?.updateHeaderLabels(for: displayedStory)

        if displayedStory.mediaType != .video {
            imageView.image = nil
            imageView.isHidden = false
            videoView.isHidden = true
            startRequest()
        } else {
            imageView.isHidden = true
            videoView.isHidden = false
            startPlayer()
        }
    }

    func startRequest() {
        imageView.stopAnimating()
        guard let story = getDisplayedStory(),
            let mediaURL = story.mediaURL
        else { return }

        if story.mediaType == .gif {
            imageView.loadGIF(from: mediaURL) { [weak self] gifImage in
                guard let self = self, let gifImage = gifImage else { return }
                self.imageView.animationImages = gifImage.images
                self.imageView.animationDuration = gifImage.duration
                self.imageView.animationRepeatCount = 0
                self.imageView.image = gifImage.images?.last
                self.startProgress()
            }
        } else if story.mediaType == .image {
            imageView.download(from: mediaURL) { [weak self] image in
                guard let self = self, image != nil else { return }
                self.startProgress()
            }
        }
    }
}
