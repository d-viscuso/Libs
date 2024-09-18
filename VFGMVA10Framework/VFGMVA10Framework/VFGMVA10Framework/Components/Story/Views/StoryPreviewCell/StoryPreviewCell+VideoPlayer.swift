//
//  StoryPreviewCell+VideoPlayer.swift
//  VFGMVA10Framework
//
//  Created by Ihsan Kahramanoglu on 29.07.2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

extension StoryPreviewCell {
    func startPlayer() {
        guard let story = story,
            story.isCompletelyVisible,
            let displayedStorye = getDisplayedStory(),
            let mediaURL = displayedStorye.mediaURL
        else {
            return
        }

        videoView.startAnimating()
        StoryVideoCacheManager.shared.getFile(for: mediaURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let videoURL):
                self.videoView.play(with: videoURL.absoluteString)
            case .failure(let error):
                self.videoView.stopAnimating()
                VFGErrorLog(error.localizedDescription)
            }
        }
    }
    /// Handle pausing story video display progress
    func pausePlayer() {
        videoView.pause()
    }
    /// Handle resuming story video display progress
    func resumePlayer() {
        videoView.play()
    }
    /// Handle stopping story video display progress
    func stopPlayer() {
        if videoView.player?.timeControlStatus != .playing {
            videoView.player?.replaceCurrentItem(with: nil)
        }
        videoView.stop()
    }
}
