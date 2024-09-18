//
//  StoryPreviewCell+ProgressBar.swift
//  VFGMVA10Framework
//
//  Created by Ihsan Kahramanoglu on 5.07.2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

// MARK: - Progress bar
extension StoryPreviewCell {
    func gearUpProgress(queue: DispatchQueue = DispatchQueue.main) {
        guard let displayedStory = getDisplayedStory(),
            displayedStory.mediaType != .video,
            let headerView = headerView,
            let progressViewIndex = story?.lastViewedMultipleStoryIndex
        else {
            return
        }

        queue.async { [weak self] in
            guard let self = self else { return }
            let completion: (_ didFail: Bool) -> Void = { [weak self] didFail in
                guard let self = self, !didFail else {
                    return
                }
                VFGDebugLog("\(displayedStory.title) gearUpProgress completion")
                self.stopPlayer()
                self.handleNavigation(isGoingNext: true)
            }

            guard let progressView = headerView.getProgressView(for: progressViewIndex),
                let progressHolderView = progressView.superview
            else { return }
            progressView.start(
                with: 5,
                holderView: progressHolderView,
                completion: completion
            )
        }
    }
    /// Handle starting story display progress
    func startProgress() {
        guard let story = story,
            story.isCompletelyVisible,
            let displayedStory = getDisplayedStory()
        else { return }
        VFGDebugLog("\(displayedStory.title) start progress")
        if displayedStory.mediaType == .video, !videoView.isHidden {
            startPlayer()
        } else if !imageView.isHidden, imageView.image != nil {
            gearUpProgress()
            if displayedStory.mediaType == .gif {
                imageView.startAnimating()
            }
        }
    }
    /// Handle pausing story display progress
    func pauseProgress() {
        guard let progressViewIndex = story?.lastViewedMultipleStoryIndex else { return }
        VFGDebugLog("\(story?.title ?? "") pause progress")
        story?.isCompletelyVisible = false
        headerView?.getProgressView(for: progressViewIndex)?.pause()
        if story?.mediaType == .gif {
            imageView.stopAnimating()
        }
    }
    /// Handle resuming story display progress
    func resumeProgress() {
        guard let progressViewIndex = story?.lastViewedMultipleStoryIndex else { return }
        VFGDebugLog("\(story?.title ?? "") resume progress")
        headerView?.getProgressView(for: progressViewIndex)?.resume()
        if story?.mediaType == .gif {
            imageView.startAnimating()
        }
    }
    /// Handle reseting story display progress
    func resetProgress() {
        guard let progressViewIndex = story?.lastViewedMultipleStoryIndex else { return }
        VFGDebugLog("\(story?.title ?? "") reset progress")
        headerView?.getProgressView(for: progressViewIndex)?.reset()
        if story?.mediaType == .gif {
            imageView.stopAnimating()
        }
    }

    func stopProgress() {
        guard let progressViewIndex = story?.lastViewedMultipleStoryIndex else { return }
        VFGDebugLog("\(story?.title ?? "") stop progress")
        headerView?.getProgressView(for: progressViewIndex)?.stop()
        if story?.mediaType == .gif {
            imageView.stopAnimating()
        }
    }
}

// MARK: - StoryPreviewHeaderViewProtocol
extension StoryPreviewCell: StoryPreviewHeaderViewDelegate {
    func didTapCloseButton() {
        updateViewedIndexBeforeClose()
        delegate?.storyPreviewCellDidTapCloseButton(self)
    }

    func updateViewedIndexBeforeClose() {
        guard let story = story,
            story.storyPreviewType == .multiple
        else { return }
        // Next time user opens the multiple story it should continue from the next story
        story.lastViewedMultipleStoryIndex += 1
        if story.lastViewedMultipleStoryIndex >= story.stories.count {
            story.lastViewedMultipleStoryIndex = story.stories.count - 1
        }
    }
}

// MARK: - StoryPlayerViewDelegate
extension StoryPreviewCell: StoryVideoViewDelegate {
    func storyVideoViewDidStartPlaying(_ storyVideoView: StoryVideoView) {
        guard
            let videoView = videoView,
            videoView.currentTime <= 0,
            videoView.error == nil,
            story?.isCompletelyVisible == true,
            let duration = videoView.currentItem?.asset.duration,
            Float(duration.value) > 0,
            let headerView = headerView,
            let progressViewIndex = story?.lastViewedMultipleStoryIndex
        else {
            VFGErrorLog("Unable to play the video")
            return
        }

        let seconds = min(duration.seconds, 15)
        let completion: (_ didFail: Bool) -> Void = { [weak self] didFail in
            guard let self = self else {
                return
            }

            self.stopPlayer()
            if !didFail {
                self.handleNavigation(isGoingNext: true)
            }
        }
        guard let progressView = headerView.getProgressView(for: progressViewIndex),
            let progressHolderView = progressView.superview
        else { return }
        progressView.start(
            with: seconds,
            holderView: progressHolderView,
            completion: completion
        )
    }

    func storyVideoViewDidCompletePlay(_ storyVideoView: StoryVideoView) {}

    func storyVideoView(_ storyVideoView: StoryVideoView, didTrack progress: Float) {}

    func storyVideoView(_ storyVideoView: StoryVideoView, didFailedWith error: String, for url: URL?) {
        VFGDebugLog(error)
        // maybe show retry button
    }
}
