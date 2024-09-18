//
//  VFGFloatingTobiView.swift
//  VFGMVA10Foundation
//
//  Created by Ramy Nasser on 04/07/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//
import UIKit
import VFGMVA10Foundation
/// VFGFloatingTobiView
public class VFGFloatingTobiView: UIView {
    public static let shared = VFGFloatingTobiView()
    public var isFloatingTobiShown = false
    public private(set)var tobiFace: VFGTOBIFace?
    var floatingFrame: CGRect?
    public weak var tobiContainerProtocol: VFGFloatingTobiContainerProtocol?
    public weak var tobiModel: VFGMVA12DashboardFloatingTOBIModel?
    private var heightConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    var rightSwipe: UISwipeGestureRecognizer?
    var leftSwipe: UISwipeGestureRecognizer?
    var draggingGesture: UIPanGestureRecognizer?
    var draggingLimitOffest = 50.0
    var isWelcomeMessageShown = false
    var isCollapesed = true
    var isOnRightSide = true
    private var actionButton: UIButton?

    public lazy var welcomeMessageView: VFGFloatingTobiWelcomeMessageView? = {
        guard let messageView: VFGFloatingTobiWelcomeMessageView = UIView.loadXib(bundle: .foundation)
        else { return nil }
        return messageView
    }()
    public lazy var tobiBadgeView: VFGBadgeView = {
        let badgeView = VFGBadgeView()
        badgeView.badgeContentView?.badgeTextContentWidth = 15
        return badgeView
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private init() {
        floatingFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        super.init(frame: floatingFrame ?? .zero)
        actionButton = UIButton(frame: bounds)
        if let actionButton = actionButton {
            addSubview(actionButton)
            bringSubviewToFront(actionButton)
            actionButton.addTarget(self, action: #selector(tobiViewDidPressed), for: .touchUpInside)
            actionButton.fresh.makeConstraints { fresh in
                fresh.left == self.fresh.left
                fresh.right == self.fresh.right
                fresh.top == self.fresh.top
                fresh.bottom == self.fresh.bottom
            }
        }
    }

    @objc func tobiViewDidPressed() {
        tobiModel?.delegate?.tobiViewDidPressed()
    }

    func setupFloatingContainer() {
        let x = tobiContainerProtocol?.tobiPosition.xPostion ?? 0.0
        let y = tobiContainerProtocol?.tobiPosition.yPosition ?? 0.0
        let height = tobiContainerProtocol?.floatingHeight ?? 0.0
        let width = tobiContainerProtocol?.floatingWidth ?? 0.0
        let tobiHeight = tobiContainerProtocol?.tobiHeight ?? 0.0
        let tobiWidth = tobiContainerProtocol?.tobiWidth ?? 0.0

        floatingFrame = CGRect(x: x, y: y, width: width, height: height)
        let tobiFrame = CGRect(x: 0, y: 0, width: tobiWidth, height: tobiHeight)
        tobiFace?.removeFromSuperview()
        if let imageUrl = tobiModel?.imageUrl, UIApplication.shared.canOpenURL(imageUrl) {
            tobiFace = VFGTOBIFace(frame: tobiFrame, tobiRemoteImageURL: imageUrl)
        } else if let imageName = tobiModel?.imageName {
            tobiFace = VFGTOBIFace(frame: tobiFrame, tobiImageName: imageName)
        } else {
            if let face = tobiModel?.face {
                VFGTOBIFace.defaultSet = face
            }
            tobiFace = VFGTOBIFace(frame: tobiFrame)
        }
        self.frame = floatingFrame ?? .zero

        guard let tobiFace = tobiFace else {
            return
        }
        addSubview(tobiFace)
        tobiFace.center = CGPoint(
            x: self.frame.size.width / 2,
            y: self.frame.size.height / 2)
        setup()
        setupBadge()
        setUpGestures()
    }

    private func setupBadge() {
        addSubview(tobiBadgeView)
        tobiBadgeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tobiBadgeView.leadingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: 45),
            tobiBadgeView.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: -8)
        ])
    }

    func setup() {
        layer.cornerRadius = self.frame.height / 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowOpacity = 0.16
        layer.shadowRadius = 4.0
        backgroundColor = .white
        setWelcomeMessage()
        setBadge()
    }

    private func setWelcomeMessage() {
        guard let tobiModel = tobiModel,
            let welcomeMessageView = welcomeMessageView
        else {
            return
        }
        welcomeMessageView.titleLabel.text = tobiModel.message
    }

    private func setBadge() {
        guard let badgeModel = tobiModel?.badgeModel else {
            return
        }
        tobiBadgeView.setup(with: badgeModel.badgeId)
        VFGFloatingTobiView.updateFloatingTOBIBadge(badgeModel)
    }

    private func setupMessageView() {
        guard let welcomeMessageView = welcomeMessageView else {
            return
        }

        welcomeMessageView.removeFromSuperview()
        self.addSubview(welcomeMessageView)
        isWelcomeMessageShown = true
        welcomeMessageView.translatesAutoresizingMaskIntoConstraints = false

        let top = NSLayoutConstraint(
            item: welcomeMessageView,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant: 0)

        let left = NSLayoutConstraint(
            item: welcomeMessageView,
            attribute: .left,
            relatedBy: .equal,
            toItem: tobiFace,
            attribute: .right,
            multiplier: 1,
            constant: 0)

        let right = NSLayoutConstraint(
            item: welcomeMessageView,
            attribute: .right,
            relatedBy: .equal,
            toItem: self,
            attribute: .right,
            multiplier: 1,
            constant: 0)

        heightConstraint = NSLayoutConstraint(
            item: welcomeMessageView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 0)

        widthConstraint = NSLayoutConstraint(
            item: welcomeMessageView,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 0)

        guard let heightConstraint = heightConstraint else {
            return
        }

        guard let widthConstraint = widthConstraint else {
            return
        }

        NSLayoutConstraint.activate([top, left, right, widthConstraint, heightConstraint])
        welcomeMessageView.delegate = self
    }
    /// Show TOBI
    public func showTOBI(tobiContainer: VFGFloatingTobiContainerProtocol, tobiModel: VFGMVA12DashboardFloatingTOBIModel?, isAnimated: Bool = true) {
        self.tobiContainerProtocol = tobiContainer
        self.tobiModel = tobiModel
        setupFloatingContainer()
        if !isFloatingTobiShown {
            if isAnimated {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.performTobiAppearAnimation(duration: 0.35, slideDelay: 10)
                }
            } else {
                self.tobiContainerProtocol?.containerView?.addSubview(VFGFloatingTobiView.shared)
            }
            isFloatingTobiShown = true
        }
        if let actionButton = actionButton {
            bringSubviewToFront(actionButton)
        }
    }

    /// Change TOBI face
    public func changeTOBIFace(set newTobiSet: VFGTOBISet) {
        tobiFace?.switchTo(set: newTobiSet)
    }
    /// Hide TOBI
    public func hideTOBI() {
        if isFloatingTobiShown {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                VFGFloatingTobiView.shared.reverseAnimate()
                self.tobiContainerProtocol?.containerView?.addSubview(VFGFloatingTobiView.shared)
            }
            isFloatingTobiShown = false
        }
    }
}

// MARK: - Animation
extension VFGFloatingTobiView {
    func performTobiAppearAnimation(duration: CGFloat, slideDelay: CGFloat, completion: (() -> Void)? = nil) {
        self.tobiContainerProtocol?.containerView?.addSubview(VFGFloatingTobiView.shared)
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear) { [weak self] in
            guard let self = self else { return }
            self.transform = CGAffineTransform.identity
            NSLayoutConstraint.activate([
                self.tobiBadgeView.leadingAnchor.constraint(
                    equalTo: self.leadingAnchor,
                    constant: 45)
            ])
            DispatchQueue.main.asyncAfter(deadline: .now() + slideDelay) {
                VFGFloatingTobiView.shared.animate()
                completion?()
            }
        }
    }

    /// Reverse Animation
    public func reverseAnimate() {
        guard let floatingFrame = floatingFrame else {
            return
        }

        UIView.animate(
            withDuration: 0.75,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            animations: {
                self.frame = floatingFrame
                self.center.x = self.tobiContainerProtocol?.containerView?.frame.minX ?? 20
            }, completion: { _ in
                VFGFloatingTobiView.shared.removeFromSuperview()
            })
    }
    /// begin
    public func begin(_ animationName: VFGTOBIAnimationNames, animateNow: Bool = false) {
        tobiFace?.begin(animationName, animateNow: animateNow)
    }
    /// Animate
    public func animate() {
        guard let floatingView = floatingFrame else {
            return
        }

        setupMessageView()

        UIView.animate(
            withDuration: 0.75,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            animations: { [weak self] in
                guard let self = self else { return }
                self.frame.size = floatingView.size
                self.frame.size.width = (UIApplication.shared.keyWindow?.frame.width ?? 320 ) - 32
                self.center.x = UIApplication.shared.keyWindow?.center.x ?? 20
                self.widthConstraint?.constant = self.tobiContainerProtocol?.floatingWidth ?? 0
                self.heightConstraint?.constant = self.tobiContainerProtocol?.floatingHeight ?? 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.welcomeMessageView?.showViews()
                    NSLayoutConstraint.activate([
                        self.tobiBadgeView.leadingAnchor.constraint(
                            equalTo: self.leadingAnchor,
                            constant: 45)
                    ])
                }
            }, completion: { [weak self] _ in
                guard let self = self else { return }
                self.isCollapesed = false
                self.rightSwipe?.isEnabled = true
                self.leftSwipe?.isEnabled = true
                self.draggingGesture?.isEnabled = false
            })
    }
}

extension VFGFloatingTobiView {
    private func setUpGestures() {
        rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        guard let rightSwipe = rightSwipe else {
            return
        }
        rightSwipe.direction = .right
        rightSwipe.isEnabled = true
        rightSwipe.delegate = self
        self.addGestureRecognizer(rightSwipe)

        leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        guard let leftSwipe = leftSwipe else {
            return
        }
        leftSwipe.direction = .left
        leftSwipe.isEnabled = true
        leftSwipe.delegate = self
        self.addGestureRecognizer(leftSwipe)

        draggingGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleDragging))
        guard let draggingGesture = draggingGesture else {
            return
        }
        draggingGesture.isEnabled = true
        draggingGesture.delegate = self
        self.addGestureRecognizer(draggingGesture)
    }

    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if isOnRightSide, sender.direction == .right {
            collapseTOBI()
        } else if isOnRightSide == false, sender.direction == .left {
            collapseTOBI()
        }
    }
}

extension VFGFloatingTobiView: VFGFloatingTobiMessageViewDelegate {
    public func closeAction() {
        collapseTOBI()
    }
}

extension VFGFloatingTobiView {
    public static func updateFloatingTOBIBadge(_ badgeModel: VFGFloatingTobiBadgeModelProtocol) {
        var badgeText = "\(badgeModel.badgeCount)"
        if badgeModel.badgeCount >= 100 {
            badgeText = "99+"
        }
        VFGFloatingTobiView.shared.tobiModel?.badgeModel = badgeModel
        let tobiBadgeModel = BadgeModel(text: badgeText)
        VFGBadgesTracker.shared.updateBadge(with: badgeModel.badgeId, model: tobiBadgeModel)
    }
}
