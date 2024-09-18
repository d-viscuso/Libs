//
//  VFGTOBIFace.swift
//  TOBI
//
//  Created by Ehab Amer on 10/1/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import Lottie

/// Animation callbacks
/// Conform to this protocol VFGTOBIFaceDelegate in order to receive callbacks from the tobiFace object when the animation starts or finishes:
/// animationName is the current animation which you used when calling the begin method, in our case this will be wink.
public protocol VFGTOBIFaceDelegate: AnyObject {
    func animationStarted(_ animationName: VFGTOBIAnimationNames)
    func animationFinished(_ animationName: VFGTOBIAnimationNames)
}

/// VFGTOBIFace
open class VFGTOBIFace: UIView {
    public var animationToDo: VFGTOBIAnimationNames?
    public var lastAnimationObject: VFGTOBIAnimationNames?
    var animationView: AnimationView
    var tobiImageView: UIImageView
    public weak var delegate: VFGTOBIFaceDelegate?
    @IBInspectable public var useLongIdles: Bool = false
    /**
    Change idle types
     
    TOBi automatically performs idle animations. there are two idle types:

    Long makes TOBi use continuous idle animations, each is four seconds long. This is intended for the large TOBi face
     
    Short makes TOBi use idle animations that are two seconds long and waits for a few seconds (defined in shortIdleWaitDuration).
    This is intended for the small TOBi face, like in a tray or a small icon that is constantly visible and shouldn't cause a distraction.
     
    For example to set a short idle animation of 1 second:


    tobiFace.shortIdleWaitDuration = 1
    */
    @IBInspectable public var shortIdleWaitDuration: Double = 5.0
    private var isIdle = false
    /**
    To change the default set across the app you can change the static property public static var defaultSet to any of the four sets.
     
    This will change any TOBi face being initialized to start with this defined set anywhere in the app.
    For example to change the default set to Santa across the app:


    VFGTOBIFace.defaultSet = VFGTOBISet.santa
    Or to keep the default set:

    VFGTOBIFace.defaultSet = VFGTOBISet.default */
    public static var defaultSet = VFGTOBISet.default

    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutAnimationView()
    }

    private func layoutAnimationView() {
        var frame = self.frame
        let originalFrame = self.frame
        frame.origin = CGPoint(x: -0.75 * originalFrame.width, y: -0.75 * originalFrame.height)
        frame.size.width += 1.5 * originalFrame.width
        frame.size.height += 1.5 * originalFrame.height
        animationView.frame = frame
    }
    
    private func layoutImageView() {
        var frame = self.frame
        let originalFrame = self.frame
        frame.origin = CGPoint(x: -0.75 * originalFrame.width, y: -0.75 * originalFrame.height)
        frame.size.width += 1.5 * originalFrame.width
        frame.size.height += 1.5 * originalFrame.height
        tobiImageView.frame = CGRect(x: originalFrame.origin.x + 5, y: originalFrame.origin.y, width: originalFrame.width - 10, height: originalFrame.height)
        tobiImageView.layer.cornerRadius = tobiImageView.frame.width / 2
    }

    private func animate(_ animationName: VFGTOBIAnimation) {
        isIdle = false
        lastAnimationObject = animationName
        animationView.play(
            fromMarker: animationName.marker.start,
            toMarker: animationName.marker.end,
            loopMode: .playOnce
        ) { [weak self] _  in
            guard let self = self else { return }
            if self.lastAnimationNotIdle() {
                if let lastAnimationObject = self.lastAnimationObject {
                    self.delegate?.animationFinished(lastAnimationObject)
                }
            }
            self.finishedAnimation()
        }
    }

    public override init(frame: CGRect) {
        animationView = AnimationView(name: VFGTOBIFace.defaultSet.rawValue, bundle: Bundle(for: VFGTOBIFace.self))
        tobiImageView = UIImageView()
        super.init(frame: frame)
        animationView.accessibilityIdentifier = "loginTobiIcon"
        layoutAnimationView()
        animationView.contentMode = .scaleAspectFit
        addSubview(animationView)

        startIdle()
    }

    public required init?(coder aDecoder: NSCoder) {
        animationView = AnimationView(name: VFGTOBIFace.defaultSet.rawValue, bundle: Bundle(for: VFGTOBIFace.self))
        tobiImageView = UIImageView()
        super.init(coder: aDecoder)
        animationView.accessibilityIdentifier = "loginTobiIcon"
        layoutAnimationView()
        animationView.contentMode = .scaleAspectFit
        addSubview(animationView)

        startIdle()
    }
    
    public convenience init(frame: CGRect, tobiRemoteImageURL: URL) {
        self.init(frame: frame)
        animationView.removeFromSuperview()
        tobiImageView.clipsToBounds = true
        layoutImageView()
        tobiImageView.contentMode = .scaleToFill
        addSubview(tobiImageView)
        tobiImageView.downloaded(from: tobiRemoteImageURL)
    }

    public convenience init(frame: CGRect, tobiImageName: String) {
        self.init(frame: frame)
        animationView.removeFromSuperview()
        tobiImageView.clipsToBounds = true
        layoutImageView()
        tobiImageView.contentMode = .scaleToFill
        addSubview(tobiImageView)
        tobiImageView.image = UIImage(named: tobiImageName)
    }

    /**
    Start an animation

    There are a total number of 21 animations that TOBi can render. Use the enum VFGTOBIAnimationNames to select the desired one.

    For example to begin the wink animation:

    tobiFace.begin(.wink)
    */
    open func begin(_ animationName: VFGTOBIAnimation, animateNow: Bool = false) {
        if isIdle {
            animate(animationName)
        } else {
            delegate?.animationStarted(animationName)
            animationToDo = animationName
            if animateNow {
                animationView.stop()
            }
        }
    }

    open func finishedAnimation() {
        guard !isHidden else {
            return
        }
        if let animationToDo = animationToDo {
            animate(animationToDo)
            self.animationToDo = nil
            return
        }
        if useLongIdles == false {
            isIdle = true
            DispatchQueue.main.asyncAfter(deadline: .now() + shortIdleWaitDuration) {
                if self.isIdle == true {
                    self.isIdle = false
                    self.nextIdle()
                }
            }
        } else {
            nextIdle()
        }
    }

    private func lastAnimationNotIdle() -> Bool {
        let idleAnimations: [VFGTOBIAnimation?] = [
            .idle1,
            .idle1Long,
            .idle2,
            .idle2Long,
            .idle3,
            .idle3Long,
            .idle4,
            .idle4Long
        ]

        return !idleAnimations.contains(lastAnimationObject)
    }

    private func startIdle() {
        animationToDo = nil
        if useLongIdles {
            animate(.idle1Long)
        } else {
            animate(.idle1)
        }
    }

    private func nextIdle() {
        let idleStep = Int.random(in: 1...4)
        switch (idleStep, useLongIdles) {
        case (1, false):
            animate(.idle1)
        case (1, true):
            animate(.idle1Long)
        case (2, false):
            animate(.idle2)
        case (2, true):
            animate(.idle2Long)
        case (3, false):
            animate(.idle3)
        case (3, true):
            animate(.idle3Long)
        case (4, false):
            animate(.idle4)
        case (4, true):
            animate(.idle4Long)
        default:
            animate(.idle1)
        }
    }

    /// Change animation sets
    /// There are 4 different sets of animations TOBi can use, these are (Default - Birthday - Pride - Santa).
    /// To change the set, use the VFGTOBIFace.switchTo(set:) method to change with one of the values of VFGTOBISet enum.
    public func switchTo(set: VFGTOBISet) {
        animationView.stop()
        animationView.removeFromSuperview()
        animationView = AnimationView(name: set.rawValue, bundle: Bundle(for: VFGTOBIFace.self))
        animationView.accessibilityIdentifier = "loginTobiIcon"
        layoutAnimationView()
        animationView.contentMode = .scaleAspectFit
        addSubview(animationView)
    }

    override open func removeFromSuperview() {
        isHidden = true
        super.removeFromSuperview()
    }

    override open var isHidden: Bool {
        didSet {
            if isHidden {
                animationView.stop()
            } else {
                startIdle()
            }
        }
    }
}
