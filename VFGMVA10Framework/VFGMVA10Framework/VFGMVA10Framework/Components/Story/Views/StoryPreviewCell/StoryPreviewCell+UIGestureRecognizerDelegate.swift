//
//  StoryPreviewCell+StoryPreviewHeaderViewProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 12/05/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

extension StoryPreviewCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return gestureRecognizer is UISwipeGestureRecognizer
    }
}

// MARK: - Gesture Handling
extension StoryPreviewCell {
    @objc func didTapStory(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(ofTouch: 0, in: mediaView)
        var isGoingNext = false
        if touchLocation.x >= (frame.width / 2) {
            isGoingNext = true
        }
        handleNavigation(isGoingNext: isGoingNext)
    }

    func handleNavigation(isGoingNext: Bool) {
        guard let story = story else { return }
        switch story.storyPreviewType {
        case .single:
            if isGoingNext {
                stopProgress()
                delegate?.storyPreviewCell(self, moveToNextFrom: storyIndex)
            } else {
                delegate?.storyPreviewCell(self, moveToPreviousFrom: storyIndex)
            }
        case .multiple:
            if isGoingNext {
                if story.lastViewedMultipleStoryIndex == story.stories.count - 1 {
                    stopProgress()
                    delegate?.storyPreviewCell(self, moveToNextFrom: storyIndex)
                } else {
                    story.lastViewedMultipleStoryIndex += 1
                    configureForDisplayedStory()
                }
            } else if isGoingNext == false {
                if story.lastViewedMultipleStoryIndex == 0 {
                    delegate?.storyPreviewCell(self, moveToPreviousFrom: storyIndex)
                } else {
                    story.lastViewedMultipleStoryIndex -= 1
                    configureForDisplayedStory()
                }
            }
        }
    }

    private func configureForDisplayedStory() {
        setStoryAsViewed()
        setupGridLayout()
        setupDetailButton()
        setupVoiceOverAccessibility()
        willDisplayCell()
    }

    /// Handle long press gesture action
    /// - Parameters:
    ///    - sender: Long press gesture recognizer
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        longPressGestureState = sender.state
        if sender.state == .began || sender.state == .ended {
            if sender.state == .began {
                pauseSnap()
            } else {
                resumeSnap()
            }
        }
    }

    private func pauseSnap() {
        guard let index = story?.lastViewedMultipleStoryIndex,
            let story = getDisplayedStory()
        else { return }

        headerView?.getProgressView(for: index)?.pause()

        if story.mediaType == .video, !videoView.isHidden {
            videoView.pause()
        } else if story.mediaType == .gif, !imageView.isHidden {
            imageView.stopAnimating()
        }
    }

    private func resumeSnap() {
        guard let index = story?.lastViewedMultipleStoryIndex,
            let story = getDisplayedStory()
        else { return }

        headerView?.getProgressView(for: index)?.resume()

        if story.mediaType == .video, !videoView.isHidden {
            videoView.play()
        } else if story.mediaType == .gif, !imageView.isHidden {
            imageView.startAnimating()
        }
    }
}
