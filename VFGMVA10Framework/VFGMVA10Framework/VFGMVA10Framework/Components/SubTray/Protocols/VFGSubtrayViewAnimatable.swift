//
//  VFGSubtrayViewAnimatable.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 12/17/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//
/// List of animation state types
public enum AnimationState {
    /// Entry
    case entry
    /// Exit
    case exit
    /// Switch entry
    case switchEntry
    /// Switch exit
    case switchExit
}
/// Protocol to handle sub tray animation process
public protocol VFGSubtrayViewAnimatable: UIView {
    /// Sub tray collection view
    var collectionView: UICollectionView? { get }
    /// Change sub tray and its collection view visibility based on current animation state
    /// - Parameters:
    ///    - animationState: Current animation state
    ///    - completion: A closure to handle more actions after animation process ends
    func toggleVisibility(with animationState: AnimationState, completion: (() -> Void)?)
}

extension VFGSubtrayViewAnimatable {
    public func toggleVisibility(with animationState: AnimationState, completion: (() -> Void)?) {
        switch animationState {
        case .entry:
            collectionView?.transform = CGAffineTransform(translationX: frame.maxX, y: 0)
            alpha = 0
            entryAnimation()
        case .exit:
            exitAnimation()
        case .switchEntry:
            alpha = 0
            transform = CGAffineTransform(
                translationX: 0,
                y: Constants.trayItemsAnimationOffset)
            switchEntryAnimation()
        case .switchExit:
            switchExitAnimation(completion)
        }
    }


    private func entryAnimation() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.1,
            animations: { [weak self] in
                self?.collectionView?.transform = .identity
                self?.alpha = 1
            },
            completion: nil
        )
    }

    private func exitAnimation() {
        UIView.animate(
            withDuration: 0.08,
            animations: {
                self.alpha = 0
            },
            completion: nil)
    }

    fileprivate func switchEntryAnimation() {
        UIView.animate(
            withDuration: Constants.TrayAnimations.trayLastSwitchingDuration,
            delay: 0,
            options: .curveEaseInOut
        ) {
            self.transform = .identity
            self.alpha = 1
        }
    }

    fileprivate func switchExitAnimation(_ completion: (() -> Void)?) {
        UIView.animate(
            withDuration: Constants.TrayAnimations.trayFirstSwitchingDuration,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.transform = CGAffineTransform(
                    translationX: 0,
                    y: Constants.trayItemsAnimationOffset)
            },
            completion: { _ in
                completion?()
            }
        )

        UIView.animate(
            withDuration: Constants.TrayAnimations.trayFirstFadingDuration,
            delay: 0,
            options: .curveEaseOut
        ) {
            self.alpha = 0
        }
    }
}
