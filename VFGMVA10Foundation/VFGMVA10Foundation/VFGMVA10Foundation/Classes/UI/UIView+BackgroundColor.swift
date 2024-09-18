//
//  UIView+BackgroundColor.swift
//  VFGMVA10Foundation
//
//  Created by Sandra Morcos on 7/25/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

extension UIView {
    /**
    Add gradient background color to view

    - Parameter colors: Array of colors that will be combined to create the gradient
    - Parameter startPoint: Gradient start point
    - Parameter endPoint: Gradient end point
    */
    public func setGradientBackgroundColor(
    colors: [CGColor],
    startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0),
    endPoint: CGPoint = CGPoint(x: 0.0, y: 1.0)
    ) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.frame = bounds
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
        layer.replaceSublayer(gradientLayer, with: gradientLayer)
    }
}
