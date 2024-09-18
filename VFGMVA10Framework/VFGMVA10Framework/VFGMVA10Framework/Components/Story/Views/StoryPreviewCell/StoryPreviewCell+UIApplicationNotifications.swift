//
//  StoryPreviewCell+UIApplicationNotifications.swift
//  VFGMVA10Framework
//
//  Created by Ihsan Kahramanoglu on 29.07.2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

extension StoryPreviewCell {
    func registerForUIApplicationStates() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }


    @objc func didEnterForeground() {
        guard let story = getDisplayedStory() else { return }

        if story.mediaType == .video {
            startPlayer()
        } else {
            startProgress()
        }
    }

    @objc func didEnterBackground() {
        guard let story = getDisplayedStory() else { return }

        if story.mediaType == .video {
            stopPlayer()
        }
        resetProgress()
    }
}
