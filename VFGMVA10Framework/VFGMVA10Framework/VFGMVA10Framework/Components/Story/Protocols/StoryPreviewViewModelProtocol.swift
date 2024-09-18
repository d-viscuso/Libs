//
//  StoryPreviewViewModelProtocol.swift
//  VFGStory
//
//  Created by Abdullah Soylemez on 22.01.2021.
//

import Foundation
/// Delegation protocol for  *StoryPreviewViewModel*
protocol StoryPreviewViewModelProtocol {
    /// force hide details button in case of empty URL passed
    var forcedDetailsButtonShown: Bool { get }
    /// Array list of stories
	var stories: [Story] { get }
    /// Story index number
	var initialStoryIndex: Int { get }
    /// Number of stories in section
    /// - Parameters:
    ///    - section: Stories section
	func numberOfItemsInSection(_ section: Int) -> Int
    /// Return story to display in cell
    /// - Parameters:
    ///    - indexPath: story index path
	func cellForItemAtIndexPath(_ indexPath: IndexPath) -> Story?
}
