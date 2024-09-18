//
//  AddPaymentDetailsView.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 10/6/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Add payment details view.
public class AddPaymentDetailsView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cardNumberTextField: VFGTextField!
    @IBOutlet weak var nameOnCardTextField: VFGTextField!
    @IBOutlet weak var expiryTextField: VFGTextField!
    @IBOutlet weak var cvvTextField: VFGTextField!
    @IBOutlet weak var cardNameTextField: VFGTextField!
    @IBOutlet weak var cardNumberTextFieldHeightConstraint: NSLayoutConstraint!

    /// Credit card validator.
    public static var creditCardValidator: CreditCardValidatorProtocol?
    weak var delegate: AddPaymentDetailsViewDelegate?

    let cardNumberError = "payment_add_form_card_number_error_message".localized(bundle: .mva10Framework)
    let cvvError = "payment_add_form_cvv_number_error_message".localized(bundle: .mva10Framework)
    let expiryError = "payment_add_form_expiration_date_error_message".localized(bundle: .mva10Framework)
    let errorImage: UIImage? = VFGFrameworkAsset.Image.icWarningNotificationUiredActive
    let cvvIcon = VFGFrameworkAsset.Image.cvvIcon

    var hasValidCardNumber = false
    var hasValidCardName = false
    var hasValidCardCVV = false
    var hasValidExpiry = false
    var hasValidNameOnCard = false

    var cardType: CardType? = .unknown

    var defaultCardNumberViewHeight: CGFloat = 60
    var cardNumberViewHeightWithError: CGFloat = 82

    var details: PaymentCardDetails {
        PaymentCardDetails(
            cardName: cardNameTextField.textFieldText,
            cardNumber: cardNumberTextField.textFieldText,
            expiry: expiryTextField.textFieldText,
            cvv: cvvTextField.textFieldText,
            nameOnCard: nameOnCardTextField.textFieldText,
            brand: cardType,
            customCardNumberView: nil,
            customCvvView: nil)
    }

    func load() {
        Bundle.mva10Framework.loadNibNamed(className, owner: self, options: nil)

        configureUI()
        configureTextFields()
        setupAccessibilityIdentifiers()
        setVoiceOverAccessibility()

        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func configureUI() {
        cardNumberTextField.resetTextField()
        nameOnCardTextField.resetTextField()
        expiryTextField.resetTextField()
        cvvTextField.resetTextField()
        cardNameTextField.resetTextField()

        cardNumberTextField.delegate = self
        cardNameTextField.delegate = self
        nameOnCardTextField.delegate = self
        cvvTextField.delegate = self
        expiryTextField.delegate = self
    }

    private func configureTextFields() {
        let cardNumberHint = "payment_add_form_card_number".localized(bundle: .mva10Framework)
        cardNumberTextField.configureTextField(
            topTitleText: cardNumberHint,
            placeHolder: cardNumberHint,
            inputType: .numberPad)

        let expiryHint = "payment_add_form_expiration_date".localized(bundle: .mva10Framework)
        expiryTextField.configureTextFieldStyle(textFont: UIFont.vodafoneRegular(17))
        expiryTextField.configureTextField(
            topTitleText: expiryHint,
            placeHolder: expiryHint,
            inputType: .numbersAndPunctuation,
            tipText: "MM/YY")

        let cvvHint = "payment_add_form_cvv_number".localized(bundle: .mva10Framework)
        cvvTextField.configureTextFieldStyle(textFont: UIFont.vodafoneRegular(17))
        cvvTextField.configureTextField(
            topTitleText: cvvHint,
            placeHolder: cvvHint,
            inputType: .numberPad,
            rightIcon: cvvIcon,
            secureTextEntry: true)

        let nameOnCardHint = "payment_add_form_name_on_card".localized(bundle: .mva10Framework)
        nameOnCardTextField.configureTextField(
            topTitleText: nameOnCardHint,
            placeHolder: nameOnCardHint,
            inputType: .alphabet)

        let cardNameHint = "payment_add_form_card_name".localized(bundle: .mva10Framework)
        cardNameTextField.configureTextField(
            topTitleText: cardNameHint,
            placeHolder: cardNameHint)

        cardNumberTextField.maxLength = AddPaymentDetailsView.creditCardValidator?.maxLengthForCardNumber
        cardNumberTextField.allowedCharacters = AddPaymentDetailsView.creditCardValidator?.allowedCharacters

        expiryTextField.maxLength = AddPaymentDetailsView.creditCardValidator?.maxLengthForCardExpiry
        expiryTextField.allowedCharacters = AddPaymentDetailsView.creditCardValidator?.allowedCharacters

        cvvTextField.maxLength = AddPaymentDetailsView.creditCardValidator?.maxLengthForCardCVV
        cvvTextField.allowedCharacters = AddPaymentDetailsView.creditCardValidator?.allowedCharacters

        nameOnCardTextField.notAllowedCharacters = AddPaymentDetailsView.creditCardValidator?.notAllowedCharacters
    }

    func setupAccessibilityIdentifiers() {
        self.accessibilityIdentifier = "addPaymentDetailsView"
        cardNumberTextField.accessibilityIdentifier = "TPcardNumberText"
        nameOnCardTextField.accessibilityIdentifier = "TPnameOnCardText"
        expiryTextField.accessibilityIdentifier = "TPexpiryDateText"
        cvvTextField.accessibilityIdentifier = "TPCVVText"
        cardNameTextField.accessibilityIdentifier = "TPcardNameText"
    }

    func setup(with creditCard: PaymentModelProtocol) {
        cardNumberTextField.textFieldText = creditCard.cardNumber ?? ""
        cardNumberTextField.backToFullState()
        nameOnCardTextField.textFieldText = creditCard.nameOnCard ?? ""
        nameOnCardTextField.backToFullState()
        expiryTextField.textFieldText = creditCard.expiry ?? ""
        expiryTextField.backToFullState()
        cardNameTextField.textFieldText = creditCard.cardName ?? ""
        cardNameTextField.backToFullState()
        cardType = creditCard.brand

        hasValidNameOnCard = true
        hasValidCardNumber = true
        hasValidCardName = true
        hasValidExpiry = true

        if let expiry = creditCard.expiry,
            !validateExpiryDate(expiry) {
            expiryTextField.showRightIcon()
            expiryTextField.showError(title: expiryError, image: errorImage)
        }
    }

    func validateCardNumber(_ text: String) -> Bool {
        if text.isEmpty {
            hasValidCardNumber = false
            cardType = .unknown
            return true
        } else if text.count > 13,
            AddPaymentDetailsView.creditCardValidator?.isValidCreditCardNumber(text).valid ?? false {
            hasValidCardNumber = true
            cardType = AddPaymentDetailsView.creditCardValidator?.isValidCreditCardNumber(text).type
            return true
        } else {
            hasValidCardNumber = false
            cardType = .unknown
            return false
        }
    }

    func validateCvv(_ text: String) -> Bool {
        if AddPaymentDetailsView.creditCardValidator?.isValidCVV(text, cardType: cardType) == false, !text.isEmpty {
            hasValidCardCVV = false
            return false
        } else if text.isEmpty {
            hasValidCardCVV = false
            return true
        } else {
            hasValidCardCVV = true
            return true
        }
    }

    func validateExpiryDate(_ text: String) -> Bool {
        if AddPaymentDetailsView.creditCardValidator?.isValidExpiryDate(text) == false, !text.isEmpty {
            hasValidExpiry = false
            return false
        } else {
            hasValidExpiry = true
            return true
        }
    }

    func isValid() -> Bool {
        return hasValidCardName
            && hasValidNameOnCard
            && hasValidExpiry
            && hasValidCardCVV
            && hasValidCardNumber
    }
}

// MARK: - setVoiceOverAccessibility
extension AddPaymentDetailsView {
    private func setVoiceOverAccessibility() {
        cardNumberTextField.accessibilityLabel = cardNumberTextField.textFieldPlaceHolderText
        nameOnCardTextField.accessibilityLabel = nameOnCardTextField.textFieldPlaceHolderText
        expiryTextField.accessibilityLabel = expiryTextField.textFieldPlaceHolderText
        cvvTextField.accessibilityLabel = cvvTextField.textFieldPlaceHolderText
        cardNameTextField.accessibilityLabel = cardNameTextField.textFieldPlaceHolderText
    }
}
