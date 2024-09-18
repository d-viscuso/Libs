//
//  StoryViewModel.swift
//  VFGStory
//
//  Created by Mithat Samet Kaskara on 12.01.2021.
//

import Foundation
/// Story view model
public class StoryViewModel: StoryViewModelProtocol {
    // MARK: - Public properties
    public var forcedDetailsButtonShown: Bool?
    public var stories: [Story]
    public weak var delegate: StoryViewModelDelegate?

    // MARK: - Custom Initializer
    /// *StoryViewModel* initializer
    /// - Parameters:
    ///    - stories: Array list of stories
    ///    - forcedDetailsButtonShown: Foce hide details button in case of empty URL passed
    public init(stories: [Story], forcedDetailsButtonShown: Bool? = false) {
        self.stories = stories
        self.forcedDetailsButtonShown = forcedDetailsButtonShown
        sortStories()
    }

    // MARK: - StoryViewModelProtocol Methods

    public func update(stories: [Story]) {
        self.stories = stories
        sortStories()
        delegate?.updateView()
    }

    public func sortStories() {
        self.stories = self.stories.sorted()
    }

    public var nonSponsoredStories: [Story] {
        return stories.filter { story in
            story.type != .sponsored
        }
    }
}
