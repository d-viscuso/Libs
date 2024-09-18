//
//  DashboardCustomizationTableViewCell.swift
//  VFGMVA10Framework
//
//  Created by Yasser Soliman on 10/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// *DashboardCustomizationViewController* table view cell
class DashboardCustomizationTableViewCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var addOrRemoveButton: VFGButton!
    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var shadowViewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var shadowViewBottomConstraints: NSLayoutConstraint!

    // MARK: Properties
    /// Add or remove button action
    var onAddOrRemoveButtonPress: (() -> Void)?
    /// Determine if current cell is first cell in table view
    var isFirst = false
    /// Determine if current cell is last cell in table view
    var isLast = false
    /// Table view cell reorder control image
    var reorderControlImageName = ""

    override func awakeFromNib() {
        super.awakeFromNib()

        setViewsBackgroundColor()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = bounds
        reorderControlImageView?.image = VFGImage(named: reorderControlImageName)
        configureCornerRadius()
        configureShadowViewConstraints()
        superview?.subviews.filter { "\(type(of: $0))" == "UIShadowView" }.forEach { (shadowView: UIView) in
            shadowView.removeFromSuperview()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        shadowViewTopConstraints.constant = 0
        shadowViewBottomConstraints.constant = 0
        shadowView.layer.cornerRadius = 0
        onAddOrRemoveButtonPress = nil
    }
    /// *DashboardCustomizationTableViewCell* configuration
    /// - Parameters:
    ///    - title: Current cell title
    ///    - usageIconName: Current cell image
    ///    - actionIconName: Current cell action image
    ///    - isFirst: Determine if current cell is first cell in table view
    ///    - isLast: Determine if current cell is last cell in table view
    func configure(title: String?, usageIconName: String?, actionIconName: String?, isFirst: Bool, isLast: Bool) {
        titleLabel.text = title
        iconImageView.image = VFGImage(named: usageIconName)
        addOrRemoveButton.setImage(VFGImage(named: actionIconName), for: .normal)
        self.isFirst = isFirst
        self.isLast = isLast
        setAccessibilityForVoiceOver(usageIconName: usageIconName, actionIconName: actionIconName)
    }

    func setAccessibilityForVoiceOver(usageIconName: String?, actionIconName: String?) {
        let titleText = titleLabel.text ?? ""
        addOrRemoveButton.accessibilityLabel = actionIconName == "icRemove" ? "Remove" : "Add"
        iconImageView.accessibilityLabel = titleText
        titleLabel.accessibilityLabel = "\(titleText) title"
        reorderControlImageView?.isAccessibilityElement = true
        reorderControlImageView?
            .accessibilityLabel = usageIconName == "icRearrange" ? "" : "\(titleText) reorder drag control"
        accessibilityElements = [
            addOrRemoveButton ?? "",
            iconImageView ?? "",
            titleLabel ?? "",
            reorderControlImageView ?? ""
        ]
        accessibilityCustomActions = [addAndRemoveButtonVoiceOverAction()]
    }

    // MARK: Actions
    @IBAction func addAndRemoveButtonDidPress(_ sender: UIButton) {
        addAndRemoveButtonPressed()
    }
    @objc func addAndRemoveButtonPressed() {
        onAddOrRemoveButtonPress?()
    }
    func addAndRemoveButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = addOrRemoveButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(addAndRemoveButtonPressed))
    }
}

// MARK: Private Method
extension DashboardCustomizationTableViewCell {
    private func setViewsBackgroundColor() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        shadowView.backgroundColor = .VFGWhiteBackground
    }

    private func configureCornerRadius() {
        var cornersToRound = CACornerMask()

        if isFirst {
            cornersToRound.insert(.layerMinXMinYCorner)
            cornersToRound.insert(.layerMaxXMinYCorner)
        }

        if isLast {
            cornersToRound.insert(.layerMinXMaxYCorner)
            cornersToRound.insert(.layerMaxXMaxYCorner)
        }

        shadowView.layer.maskedCorners = cornersToRound
        shadowView.layer.cornerRadius = isFirst || isLast ? 6 : 0
    }

    private func configureShadowViewConstraints() {
        if isFirst {
            shadowViewTopConstraints.constant = 5
        } else if isLast {
            shadowViewBottomConstraints.constant = 5
        } else if isFirst && isLast {
            shadowViewTopConstraints.constant = 5
            shadowViewBottomConstraints.constant = 5
        }
    }
}
