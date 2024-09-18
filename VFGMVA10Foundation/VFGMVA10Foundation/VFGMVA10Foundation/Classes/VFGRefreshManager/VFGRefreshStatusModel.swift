//
//  VFGRefreshStatusModel.swift
//  VFGMVA10Foundation
//
//  Created by Moataz Akram on 10/03/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

// A struct that represents a model for refresh label
// This model provides texts for refresh label to show in different status
/// Refresh status model.
public struct VFGRefreshStatusModel {
    var updatingText: String
    var justUpdatedText: String
    var updatedMinText: String
    var updatedMinsText: String
    var timeStampText: String

    /// Refresh status model initializer
    /// - Parameters:
    ///   - updatingText: Represent text while updating, default text is "Updating…"
    ///   - justUpdatedText: Represent text immediately after finish updating, default text is "Just updated"
    ///   - updatedMinText: Represent text after finish updating with a single minute, default text is "Updated %1$@ min ago"
    ///   - updatedMinsText: Represent text after finish updating with more than one minute, default text is "Updated %1$@ mins ago"
    ///   - timeStampText: Represent text after finish updating with time stamp, default text is "Updated %1$@"
    public init(
        updatingText: String = "Updating…",
        justUpdatedText: String = "Just updated",
        updatedMinText: String = "Updated %1$@ min ago",
        updatedMinsText: String = "Updated %1$@ mins ago",
        timeStampText: String = "Updated %1$@"
    ) {
        self.updatingText = updatingText
        self.justUpdatedText = justUpdatedText
        self.updatedMinText = updatedMinText
        self.updatedMinsText = updatedMinsText
        self.timeStampText = timeStampText
    }
}
