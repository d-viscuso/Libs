//
//  LayoutAttributesAnimator.swift
//  AnimatedCollectionViewLayout
//
//  Created by Jin Wang on 8/2/17.
//  Copyright © 2017 Uthoft. All rights reserved.
//

import UIKit
/// Protocol for actions of custom transitions between cells.
public protocol LayoutAttributesAnimator {
    /// Cube transition effect animation process.
    /// - Parameters:
    ///    - collectionView: Collection view which its content will be animated.
    ///    - attributes: Animated collection view layout attributes.
    func animate(collectionView: UICollectionView, attributes: AnimatedCollectionViewLayoutAttributes)
}
