//
//  VFEverythingIsOKChecksHeaderCell.swift
//  VFGMVA10Group
//
//  Created by Sandra Morcos on 3/19/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFEverythingIsOKChecksHeaderCell: UITableViewHeaderFooterView, EIOCellProtocol {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var indicatorImageView: VFGImageView!
    @IBOutlet weak var headerIconContainer: UIView!
    @IBOutlet weak var headerIcon: VFGImageView!
    @IBOutlet weak var topSeparator: UIView!

    static var isClicked = false
    var willExpand = false
    var wasExpanded = false
    var status: EIOStatus = .inProgress
    var expandActionClosure: (() -> Void)? {
        didSet {
            accessibilityCustomActions?.append(expandButtonVoiceOverAction())
        }
    }
    var oldStatus: EIOStatus?
    var isClicked = false
    var hasSubItems = false
    var isFirst = true

    private func blinkHeaderIcon() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            if self.status == .failed {
                self.headerIcon.blink(
                    initialAlpha: Constants.EIOAnimation.iconOpacity,
                    duration: Constants.EIOAnimation.blinkingIconDuration,
                    delay: 0)
            }
        }
    }

    private func animateArrowUp() {
        DispatchQueue.main.async {
            self.indicatorImageView.transform = .identity
            UIView.animate(
                withDuration: Constants.EIOAnimation.expandingCollapsingDuration,
                delay: 0) {
                self.indicatorImageView.transform = CGAffineTransform(rotationAngle: (-.pi * 0.99))
            }
        }
    }

    private func animateArrowDown() {
        DispatchQueue.main.async {
            self.indicatorImageView.transform = CGAffineTransform(rotationAngle: (-.pi * 0.99))
            UIView.animate(
                withDuration: Constants.EIOAnimation.expandingCollapsingDuration,
                delay: 0) {
                self.indicatorImageView.transform = .identity
            }
        }
    }

    func updateHeader(iconName: String?, eioStatus: EIOStatus) {
        let tintColor = UIColor.indicator(with: eioStatus)
        indicatorImageView.image = indicatorImageView.image?.withRenderingMode(.alwaysTemplate)
        indicatorImageView.tintColor = tintColor
        let headerTintColor = UIColor.headerTint(with: eioStatus)
            headerIcon.image = UIImage.image(named: iconName ?? "")?.withRenderingMode(.alwaysTemplate)
            headerIcon.tintColor = headerTintColor
        titleLabel.textColor = headerTintColor
        switch status {
        case .failed:
            updateFailure(overallStatus: eioStatus)
        case .success:
            updateSuccess()
        case .inProgress:
            updateInProgress()
        }
    }

    private func updateInProgress() {
        indicatorImageView.transform = .identity
        headerIcon.alpha = Constants.EIOAnimation.iconOpacity
        if !hasSubItems {
            return
        }
        if willExpand, wasExpanded {
            indicatorImageView.transform = CGAffineTransform(rotationAngle: (-.pi * 0.99))
            return
        }
        if isClicked && !willExpand {
            animateArrowDown()
        }
        if willExpand, !wasExpanded {
            animateArrowUp()
        }
        isClicked = false
    }

    private func updateSuccess() {
        indicatorImageView.transform = .identity
        headerIcon.alpha = 1
        if !hasSubItems {
            return
        }
        if willExpand, wasExpanded {
            indicatorImageView.transform = CGAffineTransform(rotationAngle: (-.pi * 0.99))
            return
        }
        if isClicked && !willExpand {
            animateArrowDown()
            oldStatus = status
        } else if willExpand, !wasExpanded {
            animateArrowUp()
        }
    }

    private func updateFailure(overallStatus: EIOStatus) {
        headerIcon.alpha = 1
        if overallStatus == .failed {
            blinkHeaderIcon()
        }
        if !hasSubItems || isFirst {
            indicatorImageView.transform = .identity
            return
        }
        if wasExpanded, willExpand {
            indicatorImageView.transform = CGAffineTransform(rotationAngle: (-.pi * 0.99))
            return
        }
        if willExpand, oldStatus != status {
            animateArrowUp()
        } else if wasExpanded, !willExpand {
            animateArrowDown()
        } else if willExpand, !wasExpanded {
            animateArrowUp()
        } else {
            indicatorImageView.transform = .identity
        }
    }

    override func prepareForReuse() {
        removeGestures()
        super.prepareForReuse()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewAppearance(type: VFEverythingIsOKChecksHeaderCell.self, duration: 0.2, delay: 0.2)
        }
    }

    deinit {
        removeGestures()
    }

    @IBAction func expand(_ sender: VFGButton) {
        expandAction()
    }

    @objc func expandAction() {
        expandActionClosure?()
    }
}

extension VFEverythingIsOKChecksHeaderCell {
    func expandButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "expand action"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(expandAction)
        )
    }
}
