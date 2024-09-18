//
//  VFGTOBIView.swift
//  VFGTOBI
//
//  Created by Hussein Kishk on 10/27/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

/// VFGTOBIView
public class VFGTOBIView: UIView {
    static let shared = VFGTOBIView()
    var isShown = false
    let tobiFace = VFGTOBIFace(frame: CGRect(x: 0, y: 0, width: 72, height: 56))
    public static var tobiFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    public lazy var titleLabel: UILabel? = {
        let label = UILabel(frame: CGRect(x: self.tobiFace.frame.maxX + 8, y: 0, width: 0, height: 75))
        label.text = "let me know if you need any help"
        label.accessibilityLabel = label.text
        label.textColor = .black
        label.isAccessibilityElement = true
        label.accessibilityIdentifier = "TBhelperLabel"
        return label
    }()

    static public func enableTOBI() {
        UIViewController.classInit
        UINavigationController.navigationControllerInit
    }

    public func begin(_ animationName: VFGTOBIAnimationNames, animateNow: Bool = false) {
        tobiFace.begin(animationName, animateNow: animateNow)
    }

    // Animate
    public func animate() {
        self.addSubview(self.titleLabel ?? UIView())
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.2) {
                self.titleLabel?.frame.size.width = 300
                self.titleLabel?.frame.size.height = VFGTOBIView.tobiFrame.height
                self.titleLabel?.adjustsFontSizeToFitWidth = true
                self.titleLabel?.minimumScaleFactor = 0.5
        }

        UIView.animate(
            withDuration: 0.75,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            animations: {
                self.frame = VFGTOBIView.tobiFrame
                self.frame.size.width = (UIApplication.shared.keyWindow?.frame.width ?? 320 ) - 32
                self.center.x = UIApplication.shared.keyWindow?.center.x ?? 20
            }, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(frame: VFGTOBIView.tobiFrame)
        addSubview(tobiFace)
        tobiFace.center = CGPoint(
            x: self.frame.size.width / 2,
            y: self.frame.size.height / 2)
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        self.backgroundColor = .white
    }

    /// Show TOBI
    public func showTOBI() {
        if !isShown {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                UIApplication.shared.keyWindow?.addSubview(VFGTOBIView.shared)
                self.alpha = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                VFGTOBIView.shared.animate()
            }
            isShown = true
        }
    }

    /// Hide TOBI
    public func hideTOBI() {
        if isShown {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                VFGTOBIView.shared.reverseAnimate()
                UIApplication.shared.keyWindow?.addSubview(VFGTOBIView.shared)
            }
            isShown = false
        }
    }
    /// Reverse Animation
    public func reverseAnimate() {
        UIView.animate(
            withDuration: 0.75,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            animations: {
                self.frame = VFGTOBIView.tobiFrame
                self.center.x = UIApplication.shared.keyWindow?.center.x ?? 20
            }, completion: { _ in
                VFGTOBIView.shared.removeFromSuperview()
            })
    }
}
