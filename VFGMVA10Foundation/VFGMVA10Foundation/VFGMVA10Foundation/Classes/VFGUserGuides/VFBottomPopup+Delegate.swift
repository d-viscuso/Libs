//
//  VFBottomPopup+Delegate.swift
//  MyVodafone
//
//  Created by Ramy Nasser on 6/18/19.
//  Copyright © 2019 TSSE. All rights reserved.
//

import UIKit

typealias VFBottomPresentableViewController = VFBottomPopupAttributesDelegate & UIViewController

public protocol VFBottomPopupAttributesDelegate: AnyObject {
    func getPopupHeight() -> CGFloat
    func getPopupTopCornerRadius() -> CGFloat
    func getPopupPresentDuration() -> Double
    func getPopupDismissDuration() -> Double
    func shouldPopupDismissInteractivelty() -> Bool
    func shouldPopupViewDismissInteractivelty() -> Bool
    func getDimmingViewAlpha() -> CGFloat
}

enum NavigationMode {
    case normal(controller: UIViewController)
}
extension NavigationMode {
    var controller: UIViewController {
        switch self {
        case .normal(let controller):
            return controller
        }
    }
}
