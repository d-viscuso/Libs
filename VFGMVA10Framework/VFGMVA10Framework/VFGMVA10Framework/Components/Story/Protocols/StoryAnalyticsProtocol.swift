//
//  StoryAnalyticsProtocol.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 08/03/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// A protocol containing all analytics callbacks for the Stories feature.
public protocol StoryAnalyticsProtocol: Any {
    /// A callback that is invoked when the user scrolls over dashboard stories.
    /// - Parameters:
    ///   - data: The analytics initial events data.
    ///   - story: The story which has been fully viewed.
    func onDashboardStoriesScrolled(data: [String: String]?, story: Story?)
    /// A callback that is invoked when the user clicks on story to open it.
    /// - Parameters:
    ///   - data: The analytics initial events data.
    ///   - story: The clicked story object.
    func onStoryClicked(data: [String: String]?, story: Story?)
    /// A callback that is invoked when the user clicks on the story action button.
    /// - Parameters:
    ///   - data: The analytics initial events data.
    ///   - story: The current visible story which the user has clicked its action button.
    func onStoryActionButtonClicked(data: [String: String]?, story: Story?)
    /// A callback that is invoked when any story has been opened and viewed.
    /// - Parameters:
    ///   - data: The analytics initial events data.
    ///   - story: The current appearing story which the user is viewing it.
    func onStoryViewed(data: [String: String]?, story: Story?)
    /// A callback that is invoked when the story has been dismissed via any action like clicking on close button or swiping down.
    /// - Parameters:
    ///   - data: The analytics initial events data.
    ///   - story: The story which the user has dismissed it.
    func onStoryDismissed(data: [String: String]?, story: Story?)
    /// A callback that is invoked when the story has been completely viewed.
    /// - Parameters:
    ///   - data: The analytics initial events data.
    ///   - story: The story which the user has completed viewing it.
    func onStoryCompleted(data: [String: String]?, story: Story?)
    /// A callback that is invoked when the current appearing story has been flipped to another story.
    /// - Parameters:
    ///   - data: The analytics initial events data.
    ///   - currentStory: The story which the user is currently viewing it.
    ///   - nextStory: The story which the user chose to navigate to.
    func onStoryChanged(data: [String: String]?, currentStory: Story?, nextStory: Story?)
    /// A callback that is invoked once the story grid item is pressed.
    /// - Parameters:
    ///   - data: The analytics initial events data.
    ///   - story: The story which contains the grid layout.
    func onStoryGridItemClicked(data: [String: String]?, story: Story?)
}

extension StoryAnalyticsProtocol {
    public func onDashboardStoriesScrolled(data: [String: String]?, story: Story?) {
        let parameters = VFGStoryManager.getFullParameters(data: data)
        VFGStoryManager.trackView(screenName: "Discover with stories (scrolled)", parameters: parameters)
    }

    public func onStoryClicked(data: [String: String]?, story: Story?) {
        let parameters = VFGStoryManager.getFullParameters(data: data)
        VFGStoryManager.trackEvent(screenName: "ui_interaction", parameters: parameters)
    }

    public func onStoryActionButtonClicked(data: [String: String]?, story: Story?) {
        let parameters = VFGStoryManager.getFullParameters(data: data)
        VFGStoryManager.trackEvent(screenName: "ui_interaction", parameters: parameters)
    }

    public func onStoryViewed(data: [String: String]?, story: Story?) {
        let parameters = VFGStoryManager.getFullParameters(data: data)
        VFGStoryManager.trackView(screenName: "Countdown story", parameters: parameters)
    }

    public func onStoryDismissed(data: [String: String]?, story: Story?) {
        let parameters = VFGStoryManager.getFullParameters(data: data)
        VFGStoryManager.trackEvent(screenName: "ui_interaction", parameters: parameters)
    }

    public func onStoryCompleted(data: [String: String]?, story: Story?) {
        let parameters = VFGStoryManager.getFullParameters(data: data)
        VFGStoryManager.trackView(screenName: "Countdown story", parameters: parameters)
    }

    public func onStoryChanged(data: [String: String]?, currentStory: Story?, nextStory: Story?) {
        let parameters = VFGStoryManager.getFullParameters(data: data)
        VFGStoryManager.trackView(screenName: "Discover with stories (scrolled)", parameters: parameters)
        VFGStoryManager.trackEvent(screenName: "ui_interaction", parameters: parameters)
    }

    public func onStoryGridItemClicked(data: [String: String]?, story: Story?) {
        let parameters = VFGStoryManager.getFullParameters(data: data)
        VFGStoryManager.analyticsManager.trackEvent(event: "ui_interaction", parameters: parameters)
    }
}
