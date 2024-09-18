//
//  VFGRadioCell.swift
//  VFGMVA10Framework
//
//  Created by Hamsa Hassan on 1/19/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

/// A cell which which contains radio button, title, icon .

public class VFGRadioCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var croppedTopSeparator: UIView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var radioButton: VFGRadioButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var shadowView: CardViewShadow!
    /// Callback which called when radio button is clicked
    public var onRadioButtonPress: (() -> Void)?
    /// A boolean which indicate that this cell is first cell in the table view
    public var isFirstCell = false
    /// A boolean which indicate that this cell is last cell in the table view
    public var isLastCell = false
    /// A boolean which enable and disable radio button
    public var enableButtonInteraction: Bool? {
        didSet {
            radioButton.isUserInteractionEnabled = enableButtonInteraction ?? true
        }
    }
    /// A boolean which to indicate if cell is selected or not 
    public override var isSelected: Bool {
        didSet {
            radioButton.isSelected = isSelected
        }
    }
    /// used to select or unselect cell
    /// - Parameters:
    ///   - selected: Boolean that present status of cell selected or unselected
    ///   - animated: Boolean that present animate selection or not
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        radioButton.isSelected = selected
        setupRadioButtonVoiceover()
    }

    // MARK: Public Methods
    public func setShadow() {
        shadowView.isHidden = false
    }

    /// configure cell content , shadow and corner radius
    /// - Parameters:
    ///   - title: The title of cell
    ///   - imageName: The image name of cell
    ///   - isFirstCell: Boolean which indicate that this cell is first cell in the table view
    ///   - isLastCell: Boolean which indicate that this cell is last cell in the table view
    public func configure(
        title: String,
        imageName: String,
        isFirstCell: Bool,
        isLastCell: Bool,
        imageDescription: String? = nil
    ) {
        self.isFirstCell = isFirstCell
        self.isLastCell = isLastCell

        titleLabel.text = title
        iconImageView.image = VFGImage(named: imageName)
        croppedTopSeparator.isHidden = isFirstCell
        addAccessibilityForVoiceOver(with: imageDescription)
        configureConstraints()
        configureCornerRadius()
    }

    // MARK: Actions
    @IBAction func radioButtonDidPress() {
        guard !radioButton.isSelected else {
            return
        }

        onRadioButtonPress?()
    }
    // MARK: Private Methods
    private func configureConstraints() {
        topConstraint.constant = isFirstCell ? 5 : 0
        bottomConstraint.constant = isLastCell ? 5 : 0
    }

    private func configureCornerRadius() {
        var cornersToRound = CACornerMask()

        if isFirstCell {
            cornersToRound.insert(.layerMinXMinYCorner)
            cornersToRound.insert(.layerMaxXMinYCorner)
        }

        if isLastCell {
            cornersToRound.insert(.layerMinXMaxYCorner)
            cornersToRound.insert(.layerMaxXMaxYCorner)
        }

        cardView.layer.maskedCorners = cornersToRound
        cardView.layer.cornerRadius = isFirstCell || isLastCell ? 6.2 : 0
    }
}
// MARK: Voice over
extension VFGRadioCell {
    /// add accessibility for voice over
    public func addAccessibilityForVoiceOver(with imageDescription: String? = nil) {
        iconImageView.accessibilityLabel = imageDescription
        titleLabel.accessibilityLabel = titleLabel.text
        radioButton.accessibilityLabel = "Radio"
        radioButton.accessibilityTraits = .button
        setupRadioButtonVoiceover()
        if let iconImageView = iconImageView,
            let titleLabel = titleLabel,
            let radioButton = radioButton {
            accessibilityElements = [
                iconImageView,
                titleLabel,
                radioButton
            ]
        }
    }
    func setupRadioButtonVoiceover() {
        var accessibilityHint = ""
        if radioButton.isSelected {
            accessibilityHint = "Selected"
        } else {
            accessibilityHint = "Unselected, tap if you want to choose \(titleLabel.text ?? "")"
        }
        radioButton.accessibilityHint = accessibilityHint
        accessibilityCustomActions = [radioButtonVoiceOverAction()]
    }
    /// action for confirm button in voice over
    /// - Returns: action for confirm button in voice over
    func radioButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = radioButton.isSelected ? "unselect" : "select"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(radioButtonDidPress))
    }
}
