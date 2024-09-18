//
//  VFGStoryDataProviderProtocol.swift
//  VFGStory
//
//  Created by Mithat Samet Kaskara on 10.02.2021.
//

import Foundation
/// Delegation protocol to fetch stories data
public protocol VFGStoryDataProviderProtocol {
    /// Fetch stories data
    /// - Parameters:
    ///    - completion: Completion handler to hold array list of stories data in case fetching succeeded
    func fetchStories(completion: @escaping ([Story]?) -> Void)
}
