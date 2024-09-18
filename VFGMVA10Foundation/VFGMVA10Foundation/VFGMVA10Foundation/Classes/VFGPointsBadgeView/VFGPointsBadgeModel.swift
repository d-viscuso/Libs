//
//  VFGPointsBadgeModel.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed AbdElnabi on 17/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

/// A struct which represents points badge model.
public struct VFGPointsBadgeModel: Codable {
    var pointsIcon: String
    var points: String
    var pointsColor: String?

    /// Points badge model constructor.
    /// - Parameters:
    ///   - pointsIcon: A *String* instance which represents points icon.
    ///   - points: A *String* instance which represents points number.
    ///   - pointsColor: A *String* instance which represents points number color.
    public init(
        pointsIcon: String,
        points: String,
        pointsColor: String? = nil
    ) {
        self.pointsIcon = pointsIcon
        self.points = points
        self.pointsColor = pointsColor
    }
}
