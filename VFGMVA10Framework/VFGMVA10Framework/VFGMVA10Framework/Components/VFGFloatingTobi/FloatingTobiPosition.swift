//
//  FloatingTobiPosition.swift
//  VFGMVA10Foundation
//
//  Created by Ramy Nasser on 04/07/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
public enum FloatingTobiPosition: Equatable {
    case bottomRight
    case bottomLeft
    case custom(x: CGFloat, y: CGFloat)
}

public extension FloatingTobiPosition {
    var xPostion: CGFloat {
        let padding = FloatingTobiConstant.padding
        switch self {
        case .bottomRight:
            return UIScreen.main.bounds.maxX - padding
        case .bottomLeft:
            return UIScreen.main.bounds.minX + padding
        case .custom(let x, _):
            return x
        }
    }
    var yPosition: CGFloat {
        let margin = FloatingTobiConstant.margin
        switch self {
        case .bottomRight, .bottomLeft:
            return UIScreen.main.bounds.maxY - margin
        case .custom(_, let y):
            return y
        }
    }
}
