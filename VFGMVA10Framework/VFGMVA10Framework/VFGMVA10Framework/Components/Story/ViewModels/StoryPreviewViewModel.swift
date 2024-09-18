//
//  StoryPreviewViewModel.swift
//  VFGStory
//
//  Created by Mithat Samet Kaskara on 22.01.2021.
//

import Foundation
/// Story preview view model
public class StoryPreviewViewModel: StoryPreviewViewModelProtocol {
    // MARK: - Constants
	let stories: [Story]
	let initialStoryIndex: Int
    let forcedDetailsButtonShown: Bool

    // MARK: - Initializers
    /// *StoryPreviewViewModel* initializer
    /// - Parameters:
    ///    - stories: Array list of stories
    ///    - initialStoryIndex: Story index number
    ///    - forcedDetailsButtonShown: force hide details button in case of empty URL passed
    init(_ stories: [Story], _ initialStoryIndex: Int, _ forcedDetailsButtonShown: Bool = false) {
        self.stories = stories
        self.initialStoryIndex = initialStoryIndex
        self.forcedDetailsButtonShown = forcedDetailsButtonShown
    }

	func numberOfItemsInSection(_ section: Int) -> Int {
		stories.count
	}

    func cellForItemAtIndexPath(_ indexPath: IndexPath) -> Story? {
        if indexPath.item < stories.count {
            return stories[indexPath.item]
        }
        return nil
    }
}
