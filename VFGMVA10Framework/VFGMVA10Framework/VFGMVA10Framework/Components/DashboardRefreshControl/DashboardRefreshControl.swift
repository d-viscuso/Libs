//
//  DashboardRefreshControl.swift
//  VFGMVA10Framework
//
//  Created by Giovanni Romaniello on 06/09/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import UIKit
import VFGMVA10Foundation
import Lottie

public protocol RefreshControllable {
    var refreshAction: (() -> Void)? { get set }
    var scrollView: UIScrollView? { get set }
    var status: PullRefreshStatus { get }
    func refresh(completion: @escaping() -> Void)
    func endRefresh(completion: @escaping() -> Void)
}

public protocol RefreshControlAnimatable {
    func setAlpha(by offset: CGFloat)
    func updatePosition(by offset: CGFloat)
    func animateArrow()
    func updateMessageStatus()
}

public enum PullRefreshStatus {
    case pull
    case release
    case updating
    case updated
}

public class DashboardRefreshControl: UIView, RefreshControllable {
    public var label: VFGLabel?
    public var arrow: UIImageView?
    public var stackView: UIStackView?
    public var animationContainerView: UIView?
    public var animationView: AnimationView?
    public var refreshDistance: CGFloat = -80
    private let refreshMargin: CGFloat = -8
    public var checkUpdateAnimation = Animation.named("pull_to_refresh_speechmark", bundle: .mva10Framework)
    public var updatedAnimation = Animation.named("pull_to_refresh_tick", bundle: .mva10Framework)
    public weak var scrollView: UIScrollView? {
        didSet {
            setupPanGestureObservation()
        }
    }
    public var refreshAction: (() -> Void)?
    public var status: PullRefreshStatus = .pull
    public var pangestureObservation: NSKeyValueObservation?

    private let stackSpacing: CGFloat = 10
    private let stackHeight: CGFloat = 40
    private let arrowWidth: CGFloat = 17
    private let arrowHeight: CGFloat = 19
    private let animationContainerViewWidth: CGFloat = 28
    private let animationContainerViewHeight: CGFloat = 28
    private let animationViewWidth: CGFloat = 18
    private let animationViewHeight: CGFloat = 18
    var isRefreshingFromNavigation = false
    var refreshControl: UIRefreshControl?

    public func onPangestureState(state: UIPanGestureRecognizer.State, completion: @escaping() -> Void) {
        switch state {
        case .cancelled, .failed, .ended:
            if self.scrollView?.contentOffset.y ?? 0 < self.refreshDistance && status == .release {
                self.refresh {
                    completion()
                }
            } else {
                if status == .pull {
                    onAnimationComplete {
                        print("ended with pull status")
                    }
                }
            }
        default: break
        }
    }

    public func setupPanGestureObservation() {
        pangestureObservation = scrollView?.panGestureRecognizer
            .observe(\.state) { [weak self] pangestureRecognizer, _ in
                let state = pangestureRecognizer.state
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.onPangestureState(state: state) {
                        self.refreshAction?()
                        self.updateMessageStatus()
                    }
                }
            }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    deinit {
        pangestureObservation?.invalidate()
    }

    private func setupView() {
        alpha = 0
        animationContainerView = UIView()
        label = VFGLabel()
        label?.textColor = .white
        label?.font = UIFont.vodafoneRegular(14)
        label?.text = "pullrefresh_pulldown".localized(bundle: .main)
        arrow = UIImageView()
        arrow?.contentMode = .scaleAspectFit
        arrow?.image = VFGFrameworkAsset.Image.downArrow
        stackView = UIStackView()
        stackView?.axis = .horizontal
        stackView?.spacing = stackSpacing
        animationView = AnimationView()
        animationContainerView?.isHidden = true
        guard let stackView = stackView,
    let label = label,
    let arrow = arrow,
    let animationView = animationView,
    let animationContainerView = animationContainerView else {
    return
        }
        addSubview(stackView)
        stackView.fresh.makeConstraints { fresh in
            fresh.top == self.fresh.top
            fresh.centerX == self.fresh.centerX + 40
            fresh.height == stackHeight
        }
        arrow.fresh.makeConstraints { fresh in
            fresh.height == self.arrowHeight
            fresh.width == self.arrowWidth
        }
        animationContainerView.fresh.makeConstraints { fresh in
            fresh.height == self.animationContainerViewHeight
            fresh.width == self.animationContainerViewWidth
        }
        animationContainerView.backgroundColor = .white
        animationContainerView.layer.cornerRadius = animationContainerViewWidth * 0.5
        animationView.backgroundColor = .clear
        stackView.addArrangedSubview(arrow)
        stackView.addArrangedSubview(animationContainerView)
        stackView.addArrangedSubview(label)
        animationContainerView.addSubview(animationView)
        animationView.fresh.makeConstraints { fresh in
            fresh.height == self.animationViewHeight
            fresh.width == self.animationViewWidth
            fresh.centerTo(boundsOf: animationContainerView)
        }
    }

    public func refresh(completion: @escaping() -> Void) {
        refreshControl?.beginRefreshing()
        status = .updating
        updateMessageStatus()
        reloadAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion()
        }
    }

    func reloadAnimation() {
        playCheckUpdatesAnimation()
    }

    private func playCheckUpdatesAnimation() {
        arrow?.isHidden = true
        animationContainerView?.isHidden = false
        animationView?.stop()
        animationView?.animation = checkUpdateAnimation
        animationView?.loopMode = .loop
        animationView?.play()
    }

    public func endRefresh(completion: @escaping() -> Void) {
        if !isRefreshingFromNavigation {
            status = .updated
            updateMessageStatus()
        }
        playUpdatedAnimation { [weak self] in
            guard let self = self else { return }
            self.onAnimationComplete(completion: completion)
        }
    }

    public func onAnimationComplete(completion: @escaping() -> Void) {
        refreshControl?.endRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            self.checkScrollViewPosition()
            self.status = .pull
            self.hideAnimations()
            self.updateMessageStatus()
            completion()
        }
    }

    private func checkScrollViewPosition() {
        guard let scrollView, scrollView.contentOffset.y < refreshMargin else {return}
            scrollView.bounces = true
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
    }

    private func playUpdatedAnimation(completion: @escaping() -> Void) {
        if !isRefreshingFromNavigation {
            arrow?.isHidden = true
            animationContainerView?.isHidden = false
            animationView?.stop()
            animationView?.animation = updatedAnimation
            animationView?.loopMode = .playOnce
        }
        animationView?.play { finished in
            if finished {
                completion()
            }
        }
    }

    public func hideAnimations() {
        arrow?.isHidden = false
        animationView?.stop()
        animationContainerView?.isHidden = true
    }
}

extension DashboardRefreshControl: RefreshControlAnimatable {
    public func setAlpha(by offset: CGFloat) {
        if offset < refreshMargin {
            alpha = (abs(offset) / 255) * 5
        } else {
            alpha = 0
        }
    }

    public func updatePosition(by offset: CGFloat) {
        if offset < refreshMargin {
            let newoffset = abs(offset) * 0.5
            stackView?.fresh.updateConstraints { fresh in
                fresh.top == self.fresh.top + newoffset
            }
        } else {
            stackView?.fresh.updateConstraints { fresh in
                fresh.top == self.fresh.top
            }
        }
    }

    public func animateArrow() {
        if status == .release, arrow?.transform == .identity {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.arrow?.transform = CGAffineTransform(rotationAngle: .pi)
            }
        } else if status == .pull, arrow?.transform != .identity {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.arrow?.transform = .identity
            }
        }
    }

    public func updateMessageStatus() {
        switch status {
        case .pull:
            label?.text = "pullrefresh_pulldown".localized(bundle: .mva10Framework)
        case .release:
            label?.text = "pullrefresh_release".localized(bundle: .mva10Framework)
        case .updating:
            label?.text = "pullrefresh_updating".localized(bundle: .mva10Framework)
        case .updated:
            label?.text = "pullrefresh_updated".localized(bundle: .mva10Framework)
        }
    }
}

extension DashboardRefreshControl: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if status != .updating, status != .updated {
            status = scrollView.contentOffset.y <= refreshDistance ? .release : .pull
        }
        setAlpha(by: scrollView.contentOffset.y)
        updatePosition(by: scrollView.contentOffset.y)
        animateArrow()
        updateMessageStatus()
    }
}
