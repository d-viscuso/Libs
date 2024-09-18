//
//  VFEverythingIsOKChecksViewController+Transition.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 11/27/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

extension VFEverythingIsOKChecksViewController {
    @objc func transitionPanGestureAction(gesture: UIPanGestureRecognizer) {
        guard let transitionInteractor = transitionInteractor else { return }

        let translation = gesture.translation(in: view)
        let verticalMovement = transitionInteractor.startingPoint - translation.y
        let verticalMovementPercent = verticalMovement / view.bounds.height
        let upwardMovement = max(verticalMovementPercent, 0.0)
        let upwardMovementPercent = min(upwardMovement, 1.0)
        let progress = CGFloat(upwardMovementPercent)

        let endOfTableView = checksTableView.contentSize.height - checksTableView.frame.size.height
        switch gesture.state {
        case .began:
            transitionInteractor.startingPoint = 0
            transitionInteractor.startingPaddingPoint = 0
            transitionInteractor.currentPaddingPosition = 0
        case .changed:
            panGestureChanged(progress: progress, yTranslation: -verticalMovement, endOfTableView: endOfTableView)
        case .cancelled:
            transitionInteractor.cancelTransition {
                self.trayViewController()?.finishAnimation(shouldFinish: transitionInteractor.shouldFinish)
            }
            checksTableView.isScrollEnabled = true
        case .ended:
            if !transitionInteractor.shouldFinish {
                panGestureChanged(progress: 0, yTranslation: 0, endOfTableView: 0)
                trayViewController()?.layoutTrayViews()
            }
            transitionInteractor.endTransition {
                let shouldFinish = transitionInteractor.shouldFinish
                self.trayViewController()?.finishAnimation(
                    shouldFinish: shouldFinish,
                    shouldDelayCompletion: !shouldFinish)
            }
            checksTableView.isScrollEnabled = true
        default:
            break
        }
    }

    func panGestureChanged(progress: CGFloat, yTranslation: CGFloat, endOfTableView: CGFloat) {
        guard let transitionInteractor = transitionInteractor else { return }
        if transitionInteractor.hasStarted {
            updateTransition(progress: progress)
            trayViewController()?.updateAnimation(percentComplete: progress)
        } else {
            if ceil(checksTableView.contentOffset.y) >= floor(endOfTableView),
                yTranslation < 0 {
                if transitionInteractor.startingPaddingPoint == 0 {
                    transitionInteractor.startingPaddingPoint = yTranslation
                } else {
                    transitionInteractor.currentPaddingPosition =
                        transitionInteractor.startingPaddingPoint - yTranslation
                }
                if transitionInteractor.currentPaddingPosition > Constants.transitionPadding {
                    checksTableView.isScrollEnabled = false
                    transitionInteractor.startTransition {
                        transitionInteractor.startingPoint = yTranslation
                        dismiss(animated: true, completion: nil)
                        trayViewController()?.startAnimation(showTray: true)
                    }
                }
            }
        }
    }

    func updateTransition(progress: CGFloat) {
        guard let transitionInteractor = transitionInteractor else { return }
        transitionInteractor.shouldFinish = progress > 0.3
        transitionInteractor.update(progress)
    }
}
