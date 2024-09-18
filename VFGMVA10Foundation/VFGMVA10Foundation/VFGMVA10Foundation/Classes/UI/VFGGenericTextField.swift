//
//  VFGGenericTextField.swift
//  VFGMVA10Foundation
//
//  Created by Esraa Eldaltony on 7/1/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

/// A generic UIView with customizable border view, text field and top, bottom hint labels.
class VFGGenericTextField: UIView {
    // MARK: - outlets
    @IBOutlet weak var borderView: UIView!
    /// Contains title label at the top of text field, it will be hidden if textfield is empty.
    @IBOutlet weak var topView: UIView!
    /// The title label at the top of textfield, it will be hidden if textfield is empty.
    @IBOutlet weak var topLabel: VFGLabel!
    /// The top vertical spacing from container to border view constraint.
    @IBOutlet weak var topInsetConstraint: NSLayoutConstraint!
    /// The bottom vertical spacing from border view to error view constraint.
    @IBOutlet weak var bottomInsetConstraint: NSLayoutConstraint!
    /// TextField
    @IBOutlet weak var textField: UITextField!
    /// Right button with icon, can be clickable
    @IBOutlet weak var rightButton: VFGButton!
    @IBOutlet weak var textFieldLeadingConstraints: NSLayoutConstraint!

    /// The label under the text field, can be used as a hint or error label.
    @IBOutlet weak var errorHintLabel: VFGLabel!

    /// The label to the left of the text field, can be used to represent the country code, hidden by default.
    @IBOutlet weak var countryCodeLabel: VFGLabel!
    @IBOutlet weak var countryCodeLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var counterView: UIView!
    @IBOutlet weak var counterMaxValueLabel: VFGLabel!
    @IBOutlet weak var counterCurrentValueLabel: VFGLabel!

    // MARK: - properties
    weak var genericTextFieldDelegate: VFGGenericTextFieldProtocol?
    private var borderState: BorderState = .normal

    // MARK: - setup
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    /// *VFGGenericTextField* default configurations
    public func setupUI() {
        frame = bounds
        autoresizingMask = [.flexibleHeight, .flexibleWidth]

        borderView.cornerRadius = 6.0
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.VFGDefaultInputOutline.cgColor

        errorHintLabel.isHidden = true
        topView.isHidden = true
        countryCodeLabelWidthConstraint.constant = 0

        textField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged)

        if textField.textAlignment != .center {
            textField.textAlignment = UIApplication.isRightToLeft ? .right : .left
        }
    }
    /// Update UI for *VFGGenericTextField* background color and *topView* background color
    func updateCustomUI() {
        let customColor = genericTextFieldDelegate?.customBackgroundColor ?? .VFGWhiteBackground
        backgroundColor = customColor
        topView.backgroundColor = customColor
    }

    @objc func textFieldDidChange(textField: VFGGenericTextField, text: String) {
        genericTextFieldDelegate?.vfgTextFieldTextChange(textField, text: text)
    }

    @IBAction func rightButtonClicked(_ sender: Any) {
        genericTextFieldDelegate?.vfgTextFieldRightButtonClicked(self)
    }

    // MARK: - border updates
    func changeBorderState(to state: BorderState) {
        changeBorderColor(to: state)
        borderState = state
        topView.isHidden = state == .normal
    }

    func setupCounterView(maxLength: Int?) {
        counterView.isHidden = maxLength == nil
        guard let maxLength = maxLength else {
            return
        }
        counterMaxValueLabel.text = "\(maxLength)"
    }

    func updateCounterCurrentValue(_ count: Int) {
        counterCurrentValueLabel.text = "\(count)"
    }

    func changeBorderColor(to state: BorderState) {
        switch state {
        case .none:
            borderView.layer.borderColor = UIColor.clear.cgColor
        case .normal:
            borderView.layer.borderColor = UIColor.VFGDefaultInputOutline.cgColor
            topLabel.textColor = UIColor.VFGDefaultInputLabel
        case .focus:
            borderView.layer.borderColor = UIColor.VFGSelectedInputOutline.cgColor
            topLabel.textColor = UIColor.VFGSelectedInputLabel
        case .error:
            if #available(iOS 13.0, *) {
                let resolvedColor = UIColor.VFGErrorInputOutline.resolvedColor(with: self.traitCollection)
                borderView.layer.borderColor = resolvedColor.cgColor
            } else {
                borderView.layer.borderColor = UIColor.VFGErrorInputOutline.cgColor
            }
            topLabel.textColor = UIColor.VFGErrorInputLabel
        case .full:
            borderView.layer.borderColor = UIColor.VFGDefaultInputOutline.cgColor
            topLabel.textColor = UIColor.VFGDefaultInputLabel
        }
    }

    func changeBorderColor(to color: UIColor?) {
        guard let color = color else { return changeBorderState(to: .error) }
        borderView.layer.borderColor = color.cgColor
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                changeBorderColor(to: borderState)
            }
        }
    }

    @discardableResult
    override public func becomeFirstResponder() -> Bool {
        textField?.becomeFirstResponder() ?? super.becomeFirstResponder()
    }

    // MARK: - set identifiers
    func setTextFieldIdentifier(with identifier: String?) {
        textField.accessibilityIdentifier = identifier ?? ""
    }
    func setErrorHintLabelIdentifier(with identifier: String?) {
        errorHintLabel.accessibilityIdentifier = identifier ?? ""
    }
    func setRightButtonIdentifier(with identifier: String?) {
        rightButton.accessibilityIdentifier = identifier ?? ""
    }

    func setTextFieldAccessibilityLabel(with label: String?) {
        textField.accessibilityLabel = label ?? ""
    }
    func setTextFieldAccessibilityHint(with label: String?) {
        textField.accessibilityHint = label ?? ""
    }
    func setErrorHintLabelAccessibilityLabel(with label: String?) {
        errorHintLabel.accessibilityLabel = label ?? ""
    }
    func setRightButtonAccessibilityLabel(with label: String?) {
        rightButton.accessibilityLabel = label ?? ""
    }
    func setRightButtonAccessibilityHint(with label: String?) {
        rightButton.accessibilityHint = label ?? ""
    }
    func setTopLabelAccessibilityLabel(with label: String?) {
        topLabel.accessibilityLabel = label ?? ""
    }
}

/// Border state
/// - normal : textfield is empty and not focused
/// - focus : textfield is focused or being edited
/// - error : textfield validation error
/// - full : textfield editing is finished and filled
public enum BorderState: String {
    case none
    case normal
    case focus
    case error
    case full
}
