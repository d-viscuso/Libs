//
//  StoryViewModelProtocol.swift
//  VFGStory
//
//  Created by Abdullah Soylemez on 14.01.2021.
//

import Foundation
/// Delegation protocol for  *StoryViewModel*
public protocol StoryViewModelProtocol {
    /// force hide details button in case of empty URL passed
    var forcedDetailsButtonShown: Bool? { get set }
    /// Delegation for *StoryViewModel* actions
    var delegate: StoryViewModelDelegate? { get set }
    /// Array list of stories
    var stories: [Story] { get set }
    /// Responsible for sorting stories
    func sortStories()
    /// Get new list of stories
    func update(stories: [Story])
    /// Duplicate array list of stories to handle sponsored types
    var nonSponsoredStories: [Story] { get }
}
/// Delegation for *StoryViewModel* actions
public protocol StoryViewModelDelegate: AnyObject {
    /// Update stories screen view
    func updateView()
}

// enum defining stories cell layout style
public enum StoriesLayout {
    case card
    case circle
}
