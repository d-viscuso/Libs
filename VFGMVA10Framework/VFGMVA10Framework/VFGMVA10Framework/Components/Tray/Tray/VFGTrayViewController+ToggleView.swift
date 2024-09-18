//
//  VFGTrayViewController+ToggleView.swift
//  mva10
//
//  Created by Mahmoud Amer on 12/27/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import UIKit

extension VFGTrayViewController {
    public func trayItemPressed(trayItem: VFGTrayItemModel) {
        trayDelegate?.didSelectItem(trayItem)
        guard !trayItem.isSelected.value else {
            collapseTray()
            return
        }
        selectedItem = getSelectedItem(trayItem: trayItem)
        if selectedItem?.itemModel.subTrayID != nil {
            resetSelectedTrayItems()
            handleSelectedTrayItem()
            selectedItem?.subtrayView?.reloadViews()
            expandTrayView(trayItem: selectedItem)
        } else {
            collapseTray()
            // if trayItem has screen, push it
            navigateToScreenForItem(trayItem: trayItem)
            // if trayItem has an action, execute it
            if trayItem.hasAction() {
                state = .executingAction
                self.notifyTrayState()
                trayItem.executeAction()
            }
        }
    }
    func getSelectedItem(trayItem: VFGTrayItemModel) -> VFGTrayItemProtocol? {
        return trayModel?.trayItems.first { $0.itemModel.title == trayItem.title }
    }
    func handleSelectedTrayItem() {
        guard let selectedItem = selectedItem else { return }
        selectedItem.itemModel.isSelected.value.toggle()
    }

    func resetSelectedTrayItems() {
        trayModel?.trayItems.forEach {
            $0.itemModel.isSelected.value = false
        }
    }

    private func expandTrayView(trayItem: VFGTrayItemProtocol?) {
        expandTrayAnimation(trayItem: trayItem)
        resetCorners(view: mainTrayView)
        state = .expanded
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(collapseTray))
        backgroundOverlay.addGestureRecognizer(tapGestureRecognizer)
        notifyTrayState()
    }

    private func expandTrayAnimation(trayItem: VFGTrayItemProtocol?) {
        if let subtrayView = trayItem?.subtrayView as? VFGSubtrayViewAnimatable,
            state == .expanded {
            subtrayView.toggleVisibility(with: .switchExit) { [weak self] in
                guard let self = self else { return }
                self.trayContentView.removeSubviews()
                self.embedContentView(trayItem: trayItem, with: .switchEntry)
            }
        } else {
            trayContentView.removeSubviews()
            embedContentView(trayItem: trayItem, with: .entry)
            view.isUserInteractionEnabled = false
            animateTrayPlaceholder()
            animatedTrayBarContainer.isHidden = false
            centerShadowImageView.isHidden = true
            centerAnimatedView.stop()
            centerAnimationCurrentProgress = 0.5
            centerAnimatedView.play(toProgress: 0.35) { [weak self] _ in
                guard let self = self else { return }
                self.centerShadowImageView.isHidden = false
            }
            animateTobi()
            animateTrayLabels()
        }
        let title = trayItem?.itemModel.subTrayTitle?.localized(bundle: Bundle.mva10Framework) ?? ""
        subTrayLabel.text = title
        setAccessibilityIDs(trayItem?.itemModel.subTrayID)
    }

    func setAccessibilityIDs(_ subTrayID: String?) {
        guard let subTrayID = subTrayID else {
            return
        }


        let type = subTrayID.contains("_") ?
            subTrayID.split(separator: "_")[1].lowercased() :
            subTrayID.lowercased()
        subTrayLabel.accessibilityIdentifier = "ST\(type)MainTitle"
        sheetView.accessibilityIdentifier = "ST\(type)View"
        closeButtonOutlet.accessibilityIdentifier = "ST\(type)CloseBtn"
    }

    private func embedContentView(trayItem: VFGTrayItemProtocol?, with animationState: AnimationState) {
        guard let subtrayView = trayItem?.subtrayView else {
            return
        }

        subtrayView.delegate = self
        contentView = subtrayView
        trayContentView.embed(view: subtrayView)
        updateHeight(subtrayView, with: animationState)
    }

    func navigateToScreenForItem(trayItem: VFGTrayItemModel) {
        guard navigationDelegate == nil else {
            navigationDelegate?.navigateToScreenForItem(trayItem: trayItem)
            return
        }
        guard let viewController = selectedItem?.screenForItem else { return }
        state = .pushingScreen
        collapseTray()
        let topVC = UIApplication.shared.topMostNavigationController
        if viewController is UINavigationController {
            topVC?.present(viewController, animated: true, completion: nil)
        } else {
            topVC?.pushViewController(viewController, animated: true)
        }
    }

    func collapseTrayView(animated: Bool = true, completion: (() -> Void)? = nil) {
        view.isUserInteractionEnabled = false
        if animated {
            centerAnimatedView.animationSpeed = Constants.TrayAnimations.trayLottieSpeedPercentage
        } else {
            centerAnimatedView.animationSpeed = 0
        }
        centerShadowImageView.isHidden = true
        centerAnimationCurrentProgress = 1
        centerAnimatedView.play(fromProgress: 0.5, toProgress: 1, completion: nil)
        UIView.animate(
            withDuration: 0.2,
            animations: { [weak self] in
                guard let self = self else { return }
                self.animatedViewHeightConstraint.constant = 0
                self.view.layoutSubviews()
            },
            completion: { [weak self] _ in
                guard let self = self else { return }
                self.animatedTrayBarContainer.isHidden = true
            }
        )
        reverseTrayLabelsAnimation(animated: animated)
        reverseTrayPlaceholderAnimation(animated: animated)
        reverseTobiAnimation(animated: animated)

        if let contentView = contentView as? VFGSubtrayViewAnimatable {
            contentView.toggleVisibility(with: .exit) { [weak self] in
                guard let self = self else { return }
                self.trayContentView.removeSubviews()
            }
        }

        state = .collapsed
        guard let completion = completion else { return }
        completion()
    }

    private func updateHeight(_ subTrayView: VFGSubtrayViewProtocol, with animationState: AnimationState) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.updateSubTrayViewHeight(subTrayView)
        }

        if let contentView = contentView as? VFGSubtrayViewAnimatable {
            contentView.toggleVisibility(with: animationState, completion: nil)
        }
    }

    private func updateSubTrayViewHeight(_ subTrayView: VFGSubtrayViewProtocol) {
        self.trayContentHeightConstraint.constant = subTrayView.height
        self.sheetViewBottomConstraintTrayContent.constant = subTrayView.sheetViewBottomConstraintTrayContent
        self.view.layoutSubviews()

        let shadowHeight: CGFloat = 10
        let sheetViewHeight = self.sheetView.frame.height
        let finalHeight = sheetViewHeight - self.centerAnimatedView.frame.height + shadowHeight
        self.animatedViewHeightConstraint.constant = max(0, finalHeight)
        self.view.layoutSubviews()
    }

    @objc func collapseTray(animated: Bool = true) {
        // For closing keyboard if it's opened when collapsing
        view.endEditing(true)
        guard state == .expanded else {
            state = .collapsed
            return
        }
        collapseTrayView(animated: animated)
        resetSelectedTrayItems()
    }
}

extension VFGTrayViewController: VFGSubtrayViewDelegate {
    public func subtrayDidDismiss(animated: Bool = true) {
        collapseTray(animated: animated)
    }

    public func subtrayHeightDidChange(for subtrayView: VFGSubtrayViewProtocol) {
        guard state == .expanded else {
            return
        }

        updateHeight(subtrayView, with: .switchEntry)
    }

    public func updateSubtrayHeight(for subtrayView: VFGSubtrayViewProtocol) {
        updateSubTrayViewHeight(subtrayView)
    }
}
