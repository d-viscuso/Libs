//
//  VFSectionHeader+UpdateEIOKStatus.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 12/20/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension VFSectionHeader {
    /// Dashboard collection view section header current EIO status
    /// - Parameters:
    ///    - oldStatus: Old EIO status
    func updateEIOKStatus(oldStatus: EIOStatus?) {
        greetingMessageLabel.layer.removeAllAnimations()
        greetingMessageLabel.layoutIfNeeded()
        if !(eioModel?.isEIOEnabled ?? true) {
            Constants.eiokMessageDuration = 0.0
            titleLabel.isHidden = false
            titleLabel.text = titleHeader
        } else {
            titleLabel.isHidden = true
        }
        if VFSectionHeader.finishedAnimation == false {
            headerMessage = currentStateMessage ?? greetingMessageHeader
        } else {
            if eioModel?.eioStatus == .success {
                headerMessage = greetingMessageHeader
            } else {
                headerMessage = currentStateMessage ?? greetingMessageHeader
                VFSectionHeader.finishedAnimation = false
            }
        }

        if VFSectionHeader.finishedAnimation == true {
            delegate?.updateDashboardSectionHeight(completion: nil)
        } else {
            if eioModel?.eioStatus == .success {
                if let eiokTimer = eiokTimer {
                    eiokTimer.invalidate()
                }
                eiokTimer = Timer.scheduledTimer(
                    withTimeInterval: Constants.eiokMessageDuration,
                    repeats: false) { [weak self] _ in
                    if self?.eioModel?.eioStatus == .success {
                        VFSectionHeader.finishedAnimation = true
                        self?.headerMessage = self?.greetingMessageHeader ?? ""
                        self?.greetingMessageLabel.fadeTransition(0.4)
                        self?.greetingMessageLabel.text = ""
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            if self?.eioModel?.eioStatus == .success {
                                self?.greetingMessageLabel.fadeTransition(0.4)
                                self?.greetingMessageLabel.text = self?.greetingMessageHeader
                                self?.titleLabel.text = self?.titleHeader
                            }
                        }
                        self?.delegate?.updateDashboardSectionHeight(completion: nil)
                    }
                }
            }
        }
        refreshTitleLabel()
        setupUpStateView()
        drawChecksIcons()
        setupAccountTitle()
    }
    /// Update dashboard collection view section header greeting message
    func refreshTitleLabel() {
        greetingMessageLabel.text = headerMessage
        if firstEnter && eioModel?.eioStatus == .inProgress {
            greetingMessageLabel.alpha = 0
            UIView.animate(
                withDuration: Constants.EIOAnimation.iconAnimationDuration,
                delay: Constants.eiokWelcomeMessageDelay,
                options: .curveEaseOut,
                animations: {
                    self.greetingMessageLabel.alpha = 1
                },
                completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.eiokWelcomeMessageDuration) { [weak self] in
                guard let self = self else {
                    return
                }
                self.firstEnter = false
                self.blinkHeader()
            }
        } else {
            greetingMessageLabel.accessibilityValue = headerMessage
            blinkHeader()
        }
    }

    private func setupUpStateView() {
        guard let status = eioModel?.eioStatus else { return }
        switch status {
        case .success:
            logoImageView.image = VFGFrameworkAsset.Image.logoRed
            greetingMessageLabel.textColor = UIColor.VFGPrimaryText
        default:
            logoImageView.image = UIImage.VFGLogo.white
            greetingMessageLabel.textColor = UIColor.VFGWhiteText
        }
    }
}
