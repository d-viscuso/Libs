//
//  VFGTableViewSectionType.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 04/11/2021.
//

import Foundation
/// *SettingsViewController* table view sections types
public enum VFGTableViewSectionType: Equatable {
    case plainText
    case plainTextWithImage(imageHeight: CGFloat, image: String)
    /// *SettingsViewController* table view section image
    var image: String? {
        switch self {
        case .plainTextWithImage(_, let image):
            return image
        default:
            return nil
        }
    }
    /// *SettingsViewController* table view section image height
    var imageHeight: CGFloat {
        switch self {
        case .plainTextWithImage(let height, _):
            return height
        default:
            return 0
        }
    }
    /// *SettingsViewController* table view section image bottom constraint
    var imageBottomConstraint: CGFloat {
        switch self {
        case .plainTextWithImage:
            return 20
        default:
            return 8
        }
    }
    /// *SettingsViewController* table view section image top constraint
    var imageTopConstraint: CGFloat {
        switch self {
        case .plainTextWithImage:
            return 10
        default:
            return 0
        }
    }
}
