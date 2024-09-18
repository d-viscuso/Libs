//
//  View+segmentedProgressBar.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 23/06/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit


/// this extension to extend View to work like any segmented progress bar
/// all needed just pass colors and thier percentages to the funtions
extension UIView {
    func fillProgressBarColors(_ colors: [UIColor], withPercentage percentages: [Float]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        var colorsArray: [CGColor] = []
        var locationsArray: [NSNumber] = []
        var total: Float = 0.0
        locationsArray.append(0.0)
        for (index, color) in colors.enumerated() {
            // append same color twice
            colorsArray.append(color.cgColor)
            colorsArray.append(color.cgColor)
            // Calculating locations w.r.t Percentage of each
            if index + 1 < percentages.count {
                total += percentages[index]
                let location = NSNumber(value: total / 100)
                locationsArray.append(location)
                locationsArray.append(location)
            }
        }
        locationsArray.append(1.0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.colors = colorsArray
        gradientLayer.locations = locationsArray
        gradientLayer.cornerRadius = layer.cornerRadius
        backgroundColor = .clear
        layer.addSublayer(gradientLayer)
    }
}
