//
//  VFGFloatingTobiView+panGesture.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 20/07/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// this extension for handling dragging action
public extension VFGFloatingTobiView {
    /// handle dragging action for floating tobi and adjust view while dragging by adding red border and when dragging
    /// is finished reallocate floating to the nearst right or left
    ///
    /// - Parameters:
    ///   - gesture: Pan gesture responsible for dragging floating tobi
    @objc func handleDragging(gesture: UIPanGestureRecognizer) {
        guard !isWelcomeMessageShown else {
            return
        }

        guard let boundaryView = tobiContainerProtocol?.boundaryView else {
            return
        }

        guard let containerView = tobiContainerProtocol?.containerView else {
            return
        }

        let location = gesture.location(in: containerView)
        let yPosition = tobiContainerProtocol?.tobiPosition.yPosition ?? 0.0
        let maxY = yPosition + frame.height / 2
        let statusBarFrame = UIApplication.shared.statusBarFrameValue
        let minY = (statusBarFrame?.maxY ?? 0) + max(statusBarFrame?.height ?? 0, draggingLimitOffest)
        guard location.y < maxY, location.y > minY  else {
            adjustViewLayout(to: gesture.state)
            tobiBadgeView.hideBadge(animated: true)
            draggingDidFinish()
            return
        }
        let draggedView = gesture.view
        draggedView?.center = location
        translate(gesture.translation(in: self), boundaryView: boundaryView)
        gesture.setTranslation(.zero, in: self)
        setNeedsDisplay()

        adjustViewLayout(to: gesture.state)
        tobiBadgeView.hideBadge(animated: true)
        draggingDidFinish()
    }
    /// Adjust view while dragging by adding red border while dragging and remove it when dragging is finished
    ///
    /// - Parameters:
    ///   - state: Pan gesture state
    private func adjustViewLayout(to state: UIGestureRecognizer.State) {
        switch state {
        case .changed:
            setupDraggableView()
        default:
            setup()
            layer.borderColor = UIColor.clear.cgColor
            layer.borderWidth = 0
        }
    }
    /// Setup draggable view
    private func setupDraggableView() {
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 2
    }
    /// Reallocating floating to the nearst right or left when dragging is finished
    private func draggingDidFinish() {
        guard draggingGesture?.state == .ended || draggingGesture?.state == .cancelled
        else {
            return
        }
        tobiBadgeView.showBadge(animated: true)
        guard let containerView = tobiContainerProtocol?.containerView else {
            return
        }

        var newCenterX = draggingLimitOffest
        isOnRightSide = (self.frame.midX >= containerView.layer.frame.width / 2)
        if isOnRightSide {
            newCenterX = containerView.layer.frame.width - self.draggingLimitOffest
        }

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseIn,
            animations: {
                self.center.x = newCenterX
            },
            completion: { _ in self.tobiBadgeView.showBadge(animated: false) })
    }
    /// Reallocating floating to boundary view
    func moveTobiToBoundaryView() {
        guard let panGesture = draggingGesture else {
            return
        }
        removeGestures()
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleDragging))
        self.draggingGesture = panGestureRecognizer
        addGestureRecognizer(panGestureRecognizer)
        guard !isWelcomeMessageShown else {
            return
        }

        guard let boundaryView = tobiContainerProtocol?.boundaryView else {
            return
        }

        guard let containerView = tobiContainerProtocol?.containerView else {
            return
        }

        let location = panGesture.location(in: containerView)

        guard location.y == .zero else { return }

        let draggedView = panGesture.view
        draggedView?.center = location
        translate(panGesture.translation(in: self), boundaryView: boundaryView)
        panGesture.setTranslation(.zero, in: self)
        setNeedsDisplay()

        adjustViewLayout(to: panGesture.state)
        draggingDidFinish()
    }
    /// Translation in the coordinate system of the specified view
    ///
    /// - Parameters:
    ///   - translation: Translation point in the coordinate system of the specified view
    ///   - boundaryView: Boundary view that used while dragging
    func translate(_ translation: CGPoint, boundaryView: UIView) {
        let destination = center + translation
        let verticalPadding = tobiContainerProtocol?.verticalDraggingPadding ?? 0
        let horizontalPadding = tobiContainerProtocol?.horizontalDraggingPadding ?? 0
        let minX = boundaryView.frame.minX + frame.width / 2 + verticalPadding
        let minY = boundaryView.frame.minY + frame.height / 2 + horizontalPadding
        let yPosition = tobiContainerProtocol?.tobiPosition.yPosition ?? 0
        let xPosition = tobiContainerProtocol?.tobiPosition.xPostion ?? 0
        let maxY = yPosition + frame.height / 2
        let maxX = xPosition + frame.width / 2

        center = CGPoint(
            x: min(maxX, max(minX, destination.x)),
            y: min(maxY, max(minY, destination.y)))
    }

    func collapseTOBI(completion: (() -> Void)? = nil) {
        guard let welcomeMessageView = welcomeMessageView else {
            return
        }

        guard let floatingFrame = floatingFrame else {
            return
        }

        var newCenterX = UIScreen.main.bounds.maxX - 48
        if isOnRightSide == false {
            newCenterX = UIScreen.main.bounds.minX + 48
        }

        UIView.animate(
            withDuration: 0.75,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            animations: {
                self.frame.size = floatingFrame.size
                self.center.x = newCenterX
                self.welcomeMessageView?.hideViews()
                self.isWelcomeMessageShown = false
            }, completion: { _ in
                self.isCollapesed = true
                welcomeMessageView.removeFromSuperview()
                self.rightSwipe?.isEnabled = false
                self.leftSwipe?.isEnabled = false
                self.draggingGesture?.isEnabled = true
                NSLayoutConstraint.activate([
                    self.tobiBadgeView.leadingAnchor.constraint(
                        equalTo: self.trailingAnchor,
                        constant: -20)
                ])
                completion?()
            })
    }
}
