//
//  UIView+VFGStory.swift
//  VFGMVA10Framework
//
//  Created by Abdullah Soylemez on 1.04.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

extension UIView {
    func keepCenterAndApplyAnchorPoint(_ point: CGPoint) {
        guard layer.anchorPoint != point else { return }

        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var layerPosition = layer.position
        layerPosition.x -= oldPoint.x
        layerPosition.x += newPoint.x

        layerPosition.y -= oldPoint.y
        layerPosition.y += newPoint.y

        layer.position = layerPosition
        layer.anchorPoint = point
    }
}
