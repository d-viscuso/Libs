//
//  UIView+PinToSuperview.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 7/15/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
public extension UIView {
    /// Pins current view edges to it's parent view.
    /// - Parameters:
    ///    - insets: Insets  (distances) of current view relevant to it's parent.
    func vfgAutoPinEdgesToSuperviewEdges(with insets: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: superview.leftAnchor, constant: insets.left).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor, constant: insets.right).isActive = true
        topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: insets.bottom).isActive = true
    }
}
