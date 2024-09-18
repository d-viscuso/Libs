//
//  VFGTextField.swift
//  VFGMVA10Foundation
//
//  Created by Esraa Eldaltony on 7/10/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
/// A UIView contains a UITextField with option of right and left icons and an error view if needed.
public class VFGTextField: UIView, UITextFieldDelegate {
    var textFieldView: VFGGenericTextField?
    /// Delegation for set of optional methods to manage the editing and validation of text in a text field object
    public weak var delegate: VFGTextFieldProtocol?
    /// Delegation protocol to change text field attributes and UI configuration
    public weak var dataSource: VFGTextFieldDataSource? {
        didSet {
            guard dataSource != nil else { return }
            textFieldView?.updateCustomUI()
        }
    }
    let countryCodeLabelWidthDefault: CGFloat = 50
    /// Space between first letter in text field and border view or country code
    var textFieldLeadingDefault: CGFloat = 14
    var textFieldHintText: String? = ""
    var secondaryPlaceholderText: String? = ""
    var textFieldTipText: String?
    /// Options textField vars
    var optionsList: [String] = []
    var isOptionsPickerTextField = false
    var pickerView: UIPickerView?
    var toolBar: UIToolbar?
    var placeHolderColor = UIColor.VFGDefaultInputPlaceholderText
    var counterMaxLength: Int?
    // MARK: - public vars
    /// Determine if entered text matches credentials or not
    public var hasError = false
    /// Determine if user selected text field to type text
    public var isTextFieldFocused = false
    /// Allowed characters for text field
    public var allowedCharacters: String?
    /// Not allowed characters for text field
    public var notAllowedCharacters: String?
    /// Max number of character allowed in text field
    public var maxLength: Int?
    /// Text field background color
    public var customBackgroundColor: UIColor? {
        dataSource?.customBackgroundColor
    }
    /// Text field value
    public var textFieldText: String {
        get {
            return textFieldView?.textField.text ?? ""
        }
        set {
            textFieldView?.textField.text = newValue
            textFieldView?.topView.isHidden = newValue.isEmpty
            if textFieldView?.counterView.isHidden == false {
                textFieldView?.updateCounterCurrentValue(newValue.count)
            }
            guard isOptionsPickerTextField else { return }
            if let row = optionsList.firstIndex(of: newValue) {
                pickerView?.selectRow(row, inComponent: 0, animated: false)
            }
            delegate?.vfgTextFieldDidEndEditing(self)
        }
    }
    /// Error text shown below text field view
    public var textFieldErrorText: String? {
        get {
            return textFieldView?.errorHintLabel.text
        }
        set {
            textFieldView?.errorHintLabel.text = newValue
        }
    }
    /// Placeholder which move to the top of text field when start typing
    public var textFieldPlaceHolderText: String? {
        get {
            return textFieldHintText
        }
        set {
            textFieldView?.textField.attributedPlaceholder = NSAttributedString(
                string: newValue ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
            textFieldHintText = newValue
        }
    }
    /// Placeholder which shown only when user start typing and the hint text move to the top
    public var textFieldSecondaryPlaceholderText: String? {
        get {
            return secondaryPlaceholderText
        }
        set {
            textFieldView?.textField.attributedPlaceholder = NSAttributedString(
                string: newValue ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.VFGDefaultInputPlaceholderText])
            secondaryPlaceholderText = newValue
        }
    }
    /// Text field title
    public var textFieldTopTitleText: String? {
        get {
            return textFieldView?.topLabel.text
        }
        set {
            textFieldView?.topLabel.text = newValue
        }
    }
    /// Constants that specify the type of keyboard to display for a text-based view.
    public var textFieldKeyboardType: UIKeyboardType {
        get {
            return textFieldView?.textField.keyboardType ?? UIKeyboardType.default
        }
        set {
            textFieldView?.textField.keyboardType = newValue
        }
    }
    /// Icon in the right text field
    public var textFieldRightIcon: UIImage? {
        get {
            return textFieldView?.rightButton.image(for: .normal)
        }
        set {
            textFieldView?.rightButton.setImage(newValue, for: .normal)
        }
    }
    /// Text field text color
    public var textFieldTextColor: UIColor? {
        get {
            return textFieldView?.textField.textColor
        }
        set {
            textFieldView?.textField.textColor = newValue
        }
    }
    /// Text field text font
    public var textFieldTextFont: UIFont? {
        get {
            return textFieldView?.textField.font
        }
        set {
            textFieldView?.textField.font = newValue
        }
    }
    /// A Boolean value indicating if text field value will be shown as dots like password text field
    public var isSecureTextEntry: Bool {
        get {
            return textFieldView?.textField.isSecureTextEntry ?? false
        }
        set {
            textFieldView?.textField.isSecureTextEntry = newValue
        }
    }
    /// text shown below textfield and it's color changed according to the status
    public var textFieldTipTextEnabled: Bool {
        get {
            return !(textFieldView?.errorHintLabel.isHidden ?? false) && !(textFieldTipText?.isEmpty ?? false)
        }
        set {
            textFieldView?.errorHintLabel.isHidden = !newValue
        }
    }
    /// Determine if the content in a text field is a one-time code or not
    public var isContentTypeOneTimeCode: Bool {
        get {
            if #available(iOS 12.0, *), textFieldView?.textField.textContentType == .oneTimeCode {
                return true
            } else {
                return false
            }
        }
        set {
            if #available(iOS 12.0, *), newValue {
                textFieldView?.textField.textContentType = .oneTimeCode
            } else {
                textFieldView?.textField.textContentType = nil
            }
        }
    }
    // MARK: - initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        customUI()
    }

    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customUI()
    }
    /// Handle loading *VFGTextField* XIB file
    /// - Returns: Instance of *VFGTextField*
    public class func loadXib() -> VFGTextField? {
        return Bundle.foundation.loadNibNamed("VFGTextField", owner: self, options: nil)?.first as? VFGTextField
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    // MARK: - setup
    /// Set accessibility identifier for *textField* in *textFieldView*
    /// - Parameters:
    ///    - identifier: *textField* accessibility identifier value
    public func setTextFieldIdentifier(with identifier: String?) {
        textFieldView?.setTextFieldIdentifier(with: identifier)
    }
    /// Set accessibility identifier for *errorHintLabel* in *textFieldView*
    /// - Parameters:
    ///    - identifier: *errorHintLabel* accessibility identifier value
    public func setErrorHintLabelIdentifier(with identifier: String?) {
        textFieldView?.setErrorHintLabelIdentifier(with: identifier)
    }
    /// Set accessibility identifier for *rightButton* in *textFieldView*
    /// - Parameters:
    ///    - identifier: *rightButton* accessibility identifier value
    public func setRightButtonIdentifier(with identifier: String?) {
        textFieldView?.setRightButtonIdentifier(with: identifier)
    }
    /// Set accessibility label for *textField* in *textFieldView*
    /// - Parameters:
    ///    - label: *textField* accessibility Label
    public func setTextFieldAccessibilityLabel(with label: String?) {
        textFieldView?.setTextFieldAccessibilityLabel(with: label)
    }
    /// Set accessibility hint for *textField* in *textFieldView*
    /// - Parameters:
    ///    - label: *textField* accessibility hint
    public func setTextFieldAccessibilityHint(with label: String?) {
        textFieldView?.setTextFieldAccessibilityHint(with: label)
    }
    /// Set accessibility label for *errorHintLabel* in *textFieldView*
    /// - Parameters:
    ///    - label: *errorHintLabel* accessibility label
    public func setErrorHintLabelAccessibilityLabel(with label: String?) {
        textFieldView?.setErrorHintLabelAccessibilityLabel(with: label)
    }
    /// Set accessibility label for *rightButton* in *textFieldView*
    /// - Parameters:
    ///    - label: *rightButton* accessibility label
    public func setRightButtonAccessibilityLabel(with label: String?) {
        textFieldView?.setRightButtonAccessibilityLabel(with: label)
    }
    /// Set accessibility hint for *rightButton* in *textFieldView*
    /// - Parameters:
    ///    - label: *rightButton* accessibility hint
    public func setRightButtonAccessibilityHint(with label: String?) {
        textFieldView?.setRightButtonAccessibilityHint(with: label)
    }
    /// Set accessibility label for *topLabel* in *textFieldView*
    /// - Parameters:
    ///    - label: *topLabel* accessibility Label
    public func setTopLabelAccessibilityLabel(with label: String?) {
        textFieldView?.setTopLabelAccessibilityLabel(with: label)
    }

    func customUI() {
        textFieldView = VFGGenericTextField.loadXib(bundle: Bundle.foundation)
        guard let textFieldView = textFieldView else { return }
        textFieldView.frame = bounds
        textFieldView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textFieldView.textField.delegate = self
        textFieldView.genericTextFieldDelegate = self
        addSubview(textFieldView)
    }

	func setupUI() {
        frame = bounds
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textFieldView?.errorHintLabel.textColor = .VFGDefaultInputHelperText
        textFieldView?.textField.tintColor = .VFGInputFieldCursor
        textFieldView?.textField.delegate = self
        textFieldView?.textFieldLeadingConstraints.constant = textFieldLeadingDefault
        textFieldView?.countryCodeLabelWidthConstraint.constant = 0
    }
    /**
    Back to full state when the border is grey and the top title label is hidden and the text field fulled by value
    - Parameter image: The right icon
    */
    public func backToFullState(image: UIImage? = nil) {
        textFieldView?.changeBorderState(to: .full)
        guard image != nil else { return }
        textFieldView?.rightButton.setImage(image, for: .normal)
    }
    /// Move to focus state when user starts typing and there the top title label is shown
    public func getFocuesd() {
        textFieldView?.changeBorderState(to: .focus)
    }
    /// Hide *rightButton* in *textFieldView*
    public func hideRightIcon() {
        textFieldView?.rightButton.isHidden = true
        textFieldView?.rightButton.isAccessibilityElement = false
        textFieldView?.rightButton.isUserInteractionEnabled = false
    }
    /// Show *rightButton* in *textFieldView*
    public func showRightIcon() {
        textFieldView?.rightButton.isHidden = false
        textFieldView?.rightButton.isAccessibilityElement = true
        textFieldView?.rightButton.isUserInteractionEnabled = true
    }
    /// Update background color for *topView* in *textFieldView* and for *textFieldView* itself
    public func updateBackgroundColor(with color: UIColor) {
        textFieldView?.backgroundColor = color
        textFieldView?.topView.backgroundColor = color
    }
    /// Update background color for *borderView* in *textFieldView*
    public func updateInputFieldBackgroundColor(with color: UIColor) {
        textFieldView?.borderView.backgroundColor = color
    }
}
extension VFGTextField {
    private func showError(title: String?, font: UIFont?, textColor: UIColor?, image: UIImage?) {
        hasError = true
        if image != nil {
            textFieldView?.rightButton.setImage(image, for: .normal)
        }
        if let title = title {
            textFieldView?.errorHintLabel.isHidden = false
            textFieldView?.errorHintLabel.text = title
            textFieldView?.errorHintLabel.font = font
            textFieldView?.errorHintLabel.textColor = textColor
        } else {
            textFieldView?.errorHintLabel.isHidden = true
        }
    }
    /**
    Show error
    - Parameter title: The error description
    - Parameter font: The text font
    - Parameter textColor: The text color
    - Parameter image: The right icon shown in error case
    - Parameter borderState: The `BorderState`
    */
    public func showError(
        title: String? = nil,
        font: UIFont? = .vodafoneRegular(15),
        textColor: UIColor? = .VFGErrorInputHelperText,
        image: UIImage? = nil,
        borderState: BorderState = .error
    ) {
        textFieldView?.changeBorderState(to: borderState)
        showError(title: title, font: font, textColor: textColor, image: image)
    }
    /// Show error
    /// - Parameters:
    ///    - title: The error description
    ///    - font: The text font
    ///    - textColor: The text color
    ///    - image: The right icon shown in error case
    ///    - borderColor: The border color
    public func showError(
        title: String? = nil,
        font: UIFont? = .vodafoneRegular(15),
        textColor: UIColor? = .VFGErrorInputHelperText,
        image: UIImage? = nil,
        borderColor: UIColor?
    ) {
        textFieldView?.changeBorderColor(to: borderColor)
        showError(title: title, font: font, textColor: textColor, image: image)
    }
    /// Hide error
    /// - Parameters:
    ///    - resetBorderColor: Determine whether to set text field border color to its default or not
    public func hideError(resetBorderColor: Bool = false) {
        if textFieldTipTextEnabled {
            textFieldView?.errorHintLabel.text = textFieldTipText
            textFieldView?.errorHintLabel.textColor = .VFGDefaultInputHelperText
        } else {
            textFieldView?.errorHintLabel.text = ""
        }
        hasError = false
        guard resetBorderColor else { return }
        textFieldView?.changeBorderColor(to: .normal)
    }
    /// change border color
    /// - Parameters:
    ///    - borderColor: The border color
    public func changeBorderColor(to color: UIColor) {
        textFieldView?.changeBorderColor(to: color)
    }

    public func updateTipText(with tipText: String?) {
        if tipText != nil {
            textFieldTipText = tipText
            textFieldView?.errorHintLabel.text = tipText
            textFieldView?.errorHintLabel.textColor = .VFGDefaultInputHelperText
            textFieldErrorText = tipText
            textFieldTipTextEnabled = true
        } else {
            textFieldTipText = ""
            textFieldErrorText = ""
            textFieldTipTextEnabled = false
        }
    }
    /// Make textField first responder
    public func setTextFieldAsFirstResponder() {
        textFieldView?.textField.becomeFirstResponder()
    }
}
