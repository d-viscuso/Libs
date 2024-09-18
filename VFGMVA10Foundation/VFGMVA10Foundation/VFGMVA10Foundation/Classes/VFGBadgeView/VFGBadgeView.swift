//
//  VFGBadgeView.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 9/13/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

/// A badge view that appears on top of another view to display text or an image when the associated view has an active notification.
@IBDesignable
public class VFGBadgeView: UIView {
    var animationDuration: TimeInterval = 0.2
    public lazy var badgeContentView: VFGBadgeContentView? = {
        let view = UINib(
            nibName: "VFGBadgeContentView",
            bundle: .foundation).instantiate(withOwner: nil, options: nil)[0]
        guard let badgeContentView = view as? VFGBadgeContentView else {
            VFGInfoLog("badgeContentView not initialized")
            return nil
        }
        addSubview(badgeContentView)
        badgeContentView.vfgAutoPinEdgesToSuperviewEdges()
        return badgeContentView
    }()

    /// BadgeModel
    public var badgeModel: BadgeModel?
    /// A boolean to determine whether to skip observer update or not
    public var shouldSkipObserverUpdate = false
    /// Badge id
    public var badgeID: String?

    public override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = (badgeContentView?.frame.height ?? 20) / 2
    }

    /// Setup badgeView
    /// - Parameters:
    ///   - badgeID: The id that will be used for updating the badge value
    public func setup(with badgeID: String, and imageDescription: String? = nil) {
        if badgeID.isEmpty { return }
        self.badgeID = badgeID
        if let model = VFGBadgesTracker.shared.badgesValues[badgeID] {
            update(with: model, badgeID: badgeID, imageDescription: imageDescription)
        } else if let imageDescription = imageDescription {
            badgeContentView?.imageView.accessibilityLabel = imageDescription
        }

        // Add observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateBadge),
            name: .VFGBadgesTrackerID,
            object: nil)
    }

    /// Reset VFGBadgeView
    public func reset() {
        badgeModel = nil
        badgeID = nil
        badgeContentView?.reset()
    }

    @objc func updateBadge(notification: Notification) {
        guard
            let notificationObject = notification.userInfo as? [String: BadgeModel],
            let badgeID = badgeID,
            let model = notificationObject[badgeID] else { return }
        update(with: model, badgeID: badgeID)
    }

    /// Update badge
    /// - Parameters:
    ///   - badgeModel: The updated badge model
    ///   - badgeID: The badge id
    public func update(
        with badgeModel: BadgeModel,
        badgeID: String = "",
        imageDescription: String? = nil
    ) {
        self.badgeModel = badgeModel
        badgeContentView?.configure(with: badgeModel, and: imageDescription)
        showBadge(animated: false)
    }

    /// Show badge
    /// - Parameters:
    ///   - animated: A boolean to animate showing the badge
    ///   - completion: A callback action to be called after finishing animation
    public func showBadge(animated: Bool, completion: (() -> Void)? = nil) {
        guard
            !isBadgeEmpty(),
            !shouldSkipObserverUpdate else {
            hideBadge(animated: animated)
            return
        }

        isHidden = false
        if animated {
            transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(
                withDuration: animationDuration,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0,
                options: [],
                animations: { self.transform = .identity },
                completion: { _ in
                    guard let completion = completion else { return }
                    completion()
                })
        }
    }

    func isBadgeEmpty() -> Bool {
        guard let badgeModel = badgeModel else { return true }
        switch badgeModel.type {
        case .text:
            if let text = badgeModel.text,
                let badgeCount = Int(text),
                badgeCount <= 0 {
                return true
            }
            return false
        default:
            return false
        }
    }
    /// Hide badge
    /// - Parameters:
    ///   - animated: A boolean to animate showing the badge
    ///   - completion: A callback action to be called after finishing animation
    public func hideBadge(animated: Bool, completion: (() -> Void)? = nil) {
        if animated {
            transform = CGAffineTransform.identity
            UIView.animate(
                withDuration: animationDuration,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0,
                options: [],
                animations: { self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0) },
                completion: { [weak self] _ in
                    self?.isHidden = true
                    self?.transform = CGAffineTransform.identity
                    guard let completion = completion else { return }
                    completion()
                })
        } else {
            isHidden = true
            guard let completion = completion else { return }
            completion()
        }
    }
}
