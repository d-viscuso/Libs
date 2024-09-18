//
//  VFGCollectionView.swift
//  VFGMVA10Foundation
//
//  Created by Giovanni Romaniello on 02/09/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import UIKit

public protocol DashboardLayoutProtocol {
    var topInset: CGFloat { get set }
}

open class VFGCollectionView: UICollectionView {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        guard let layout = self.collectionViewLayout as? DashboardLayoutProtocol else {
            return view
        }
        if point.y >= layout.topInset {
            return view
        }
        return nil
    }
}
