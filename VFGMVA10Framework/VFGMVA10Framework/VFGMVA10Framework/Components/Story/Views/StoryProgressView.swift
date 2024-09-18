//
//  StoryProgressView.swift
//  VFGStory
//
//  Created by Mithat Samet Kaskara on 22.01.2021.
//

import UIKit
import VFGMVA10Foundation
/// Story progress view states
enum ProgressorState {
    case notStarted
    case paused
    case running
    case finished
}
/// Story progress view animator actions
protocol ViewAnimator {
    func start(with duration: TimeInterval, holderView: UIView, completion: @escaping (_ didFail: Bool) -> Void)
    func resume()
    func pause()
    func stop()
    func reset()
}

extension ViewAnimator where Self: StoryProgressView {
    /// Start progress view animation process
    /// - Parameters:
    ///    - duration: Animation progress duration
    ///    - holderView: Progress view animator holder view
    ///    - completion: Return with progress view animation process result
	func start(with duration: TimeInterval, holderView: UIView, completion: @escaping (_ didFail: Bool) -> Void) {
		// Modifying the existing widthConstraint and setting the width equalTo holderView's widthAchor
		state = .running
		widthConstraint?.isActive = false
		widthConstraint = widthAnchor.constraint(equalToConstant: 0)
		widthConstraint?.isActive = true
		widthConstraint?.constant = holderView.frame.width
		frame = CGRect(x: 0, y: 0, width: 0, height: holderView.frame.height)
        self.stop()
		UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { [weak self] in
			guard let self = self else { return }
			self.superview?.layoutIfNeeded()
		}, completion: { [weak self] finished in
			guard let self = self else { return }
			if finished {
				self.state = .finished
			}
			completion(!finished)
		})
	}
    /// Resume progress view animation process
    func resume() {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
		VFGInfoLog("Progress view tag \(self.tag) RESUME. pausedTime: \(pausedTime) -- timeSincePause: \(timeSincePause)")
        state = .running
    }
    /// Pause progress view animation process
    func pause() {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
		VFGInfoLog("Progress view tag \(self.tag) PAUSE. pausedTime: \(pausedTime)")
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        state = .paused
    }
    /// Stop progress view animation process
    func stop() {
        resume()
		VFGInfoLog("Progress view tag \(self.tag) STOP")
        layer.removeAllAnimations()
        state = .finished
    }
    /// reset progress view animation process
    func reset() {
		VFGInfoLog("Progress view tag \(self.tag) RESET")
        state = .notStarted
        widthConstraint?.isActive = false
        widthConstraint = self.widthAnchor.constraint(equalToConstant: 0)
        widthConstraint?.isActive = true
		layer.removeAllAnimations()
    }
    /// Displays the end result of an animated state
    func finish(for width: CGFloat) {
        VFGInfoLog("Progress view tag \(self.tag) FINISH")
        widthConstraint?.isActive = false
        widthConstraint?.constant = width
        widthConstraint?.isActive = true
        superview?.layoutIfNeeded()
        state = .finished
    }
}
/// Story progress view
final class StoryProgressView: UIView, ViewAnimator {
    /// Story progress view width constraint
    public var widthConstraint: NSLayoutConstraint?
    /// Story progress view current state
    public var state: ProgressorState = .notStarted
}
