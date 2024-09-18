//
//  UserDefaults+VFGStory.swift
//  VFGStory
//
//  Created by Abdullah Soylemez on 3.02.2021.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let storySeenList = "storySeenList"
    }

    var storySeenList: [String: Date] {
        get {
            return dictionary(forKey: Keys.storySeenList) as? [String: Date] ?? [:]
        }
        set {
            set(newValue, forKey: Keys.storySeenList)
        }
    }
}
