//
//  GradientView.swift
//  PreviewApp
//
//  Created by Alberto García-Muñoz on 03/07/2019.
//  Copyright © 2019 SoundApp. All rights reserved.
//

import UIKit

/// An array of CGColor objects defining the color of each gradient stop.
typealias GradientColors = [CGColor]
/// An array of NSNumber objects defining the location of each gradient stop.
typealias GradientLocations = [NSNumber]

/// `GradientView` is a UIView class to draw a gradient view.
class GradientView: UIView {
    /// Locations of each gradient stop.
    var locations: GradientLocations {
        didSet { setupView() }
    }
    /// Colors of each gradient stop.
    var colors: GradientColors {
        didSet { setupView() }
    }
    /// The start position of the gradient when drawn in the layer’s coordinate space.
    var startPosition: CGPoint {
        didSet { setupView() }
    }
    /// The end position of the gradient when drawn in the layer’s coordinate space.
    var endPosition: CGPoint {
        didSet { setupView() }
    }

    /// Creates new instance of GradientView by the given parameters.
    /// - Parameters:
    ///    - frame: Frame of the gradient view.
    ///    - colors: Colors of each gradient stop.
    ///    - locations: Locations of each gradient stop.
    ///    - startPosition: The start position of the gradient view.
    ///    - endPosition: The end position of the gradient view.
    init(frame: CGRect, colors: GradientColors, locations: GradientLocations, startPosition: CGPoint = CGPoint(x: 0.5, y: 0), endPosition: CGPoint = CGPoint(x: 0.5, y: 1)) {
        self.colors = colors
        self.locations = locations
        self.startPosition = startPosition
        self.endPosition = endPosition
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        self.colors = []
        self.locations = []
        self.startPosition = CGPoint(x: 0.5, y: 0)
        self.endPosition = CGPoint(x: 0.5, y: 1)
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let layer = self.layer as? CAGradientLayer
        layer?.colors = colors
        layer?.locations = locations
        layer?.frame = self.bounds
        layer?.startPoint = startPosition
        layer?.endPoint = endPosition
    }

    /// A layer that draws a color gradient over its background color.
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}
