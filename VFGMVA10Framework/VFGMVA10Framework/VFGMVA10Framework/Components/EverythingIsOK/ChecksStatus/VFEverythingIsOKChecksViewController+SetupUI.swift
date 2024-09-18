//
//  VFEverythingIsOKChecksViewController+SetupUI.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 10/14/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFEverythingIsOKChecksViewController {
    func setupUI(shouldReloadOnAppear: Bool = true) {
        guard let overallStatus = eioModel?.eioStatus else { return }
        let closeImage = VFGFrameworkAsset.Image.icClose?.withRenderingMode(.alwaysTemplate)
        closeButton.setImage(closeImage, for: .normal)
        closeButton.adjustsImageWhenHighlighted = false
        closeButton.tintColor = overallStatus == .success ? .VFGGreyTint : .white
        descriptionLabel.textColor = UIColor.headerTint(with: overallStatus)
        logoImageView.image = UIImage.logo(with: overallStatus)

        if shouldReloadOnAppear {
            switch overallStatus {
            case .success:
                updateUISuccess(overallStatus, completion: nil)
                descriptionLabel.layer.removeAllAnimations()
            case .failed:
                updateUIFailure(overallStatus)
                descriptionLabel.layer.removeAllAnimations()
            case .inProgress:
                descriptionLabel.text = Constants.checksInProgressMessage
                descriptionLabel.blink(
                    initialAlpha: Constants.EIOAnimation.iconOpacity,
                    duration: Constants.EIOAnimation.blinkingIconDuration,
                    delay: 0)
            }
        }
        self.setNeedsStatusBarAppearanceUpdate()
    }

    func updateUISuccess(_ overallStatus: EIOStatus, completion: (() -> Void)?) {
        backgroundView.alpha = 1
        descriptionLabel.alpha = 1
        UIView.animate(
            withDuration: Constants.EIOAnimation.expandingCollapsingDuration,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.descriptionLabel.alpha = 0
            },
            completion: { _ in
                self.descriptionLabel.transform = CGAffineTransform(translationX: 0, y: Constants.EIOAnimation.yOffset)
                self.descriptionLabel.text = String(
                    format: Constants.checksSucceededMessage,
                    self.eioModel?.model?.username ?? ""
                )
                completion?()
                UIView.animate(
                    withDuration: 1,
                    delay: 0,
                    options: .curveEaseOut,
                    animations: {
                        self.descriptionLabel.alpha = 1
                        self.descriptionLabel.transform = .identity
                    },
                    completion: nil)
            })
        alreadyFailed = false
        myProductsButton.setImage(myProductsImage, for: .normal)
    }

    func updateUIFailure(_ overallStatus: EIOStatus) {
        descriptionLabel.text = Constants.checksFailedMessage
        if !alreadyFailed {
            backgroundView.alpha = 1
            descriptionLabel.alpha = 0
            descriptionLabel.transform = CGAffineTransform(translationX: 0, y: Constants.EIOAnimation.yOffset)
            UIView.animate(
                withDuration: Constants.EIOAnimation.expandingCollapsingDuration,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.descriptionLabel.alpha = 1
                    self.descriptionLabel.transform = .identity
                }, completion: { _ in
                    self.backgroundView.alpha = 1
                })
            alreadyFailed = true
        }
    }

    func setupTableViewUI() {
        checksTableView.sectionHeaderHeight = UITableView.automaticDimension
        checksTableView.estimatedSectionHeaderHeight = 65
        checksTableView.sectionFooterHeight = 1
        let bottomInset = view.safeAreaInsets.bottom
        checksTableView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: bottomInset,
            right: 0)
        if eioModel?.pullToShowEIO ?? true {
            let panGesture = UIPanGestureRecognizer(
                target: self,
                action: #selector(transitionPanGestureAction(gesture:)))
            panGesture.delegate = self
            checksTableView.addGestureRecognizer(panGesture)
        }
    }
}

extension VFEverythingIsOKChecksViewController {
    func statusUpdated() {
        setupUI()
        guard let checkModels = eioModel?.model?.checks,
            let index = eioModel?.updatedItem else { return }
        let checkViewModel = VFCheckItemViewModel(checkModel: checkModels[index])
        checkViewModel.oldStatus = checks[index].status
        checkViewModel.wasExpanded = checks[index].willExpand
        checks.forEach { check in
            check.oldStatus = check.status
            check.wasExpanded = check.willExpand
        }
        checks[index] = checkViewModel
        guard let eioStatus = eioModel?.eioStatus else { return }
        // if it comes from faliure or inProgress and then to success it shouldn't collapse
        if checks[index].oldStatus != .success, checks[index].status == .success, checks[index].wasExpanded {
            checks[index].willExpand = true
        }
        // if overall status inprogress close all the sections
        if eioStatus == .inProgress {
            checks.forEach { $0.willExpand = false }
            reloadAllSections()
        } else if oldOverallStatus == .inProgress {
            openFailedSections()
        } else if oldOverallStatus != eioStatus {
            reloadAllSections()
        } else { checksTableView.reloadSections([index], with: .automatic)
            let numberOfSections = checksTableView.numberOfSections
            for index in 0 ..< numberOfSections {
                if let header = checksTableView.headerView(forSection: index) as? VFEverythingIsOKChecksHeaderCell {
                    let check = checks[index]
                    bindCell(header, check, index, eioStatus)
                }
            }
        }
        oldOverallStatus = eioStatus
        updateBackground(eioStatus)
    }

    func reloadAllSections(animated: Bool = true) {
        let indexSet = IndexSet(integersIn: 0..<checksTableView.numberOfSections)
        if animated {
            checksTableView.reloadSections(indexSet, with: .automatic)
        } else {
            UIView.performWithoutAnimation { [weak self] in
                guard let self = self else { return }
                self.checksTableView.reloadSections(indexSet, with: .automatic)
            }
        }
    }
}
