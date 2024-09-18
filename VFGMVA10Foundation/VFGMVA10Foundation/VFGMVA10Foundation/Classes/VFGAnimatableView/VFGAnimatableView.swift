//
//  VFGAnimatableView.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 3/6/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//
import Lottie

/// A view which holds the animation view
open class VFGAnimatableView: UIView {
    /// A weak variable of type *AnimationView* which holds the animation object and anumber of utilities to handle the lifecycle of that animation.
    @IBOutlet public weak var animationView: AnimationView!

    /// An overriden method used to stop current animation when moving to the superview.
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()

        guard superview != nil, !animationView.isHidden else {
            return
        }

        animationView.play()
    }
}
