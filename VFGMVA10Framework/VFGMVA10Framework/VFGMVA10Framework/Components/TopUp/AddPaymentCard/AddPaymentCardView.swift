//
//  AddPaymentCardView.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 9/27/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class AddPaymentCardView: UIView {
    @IBOutlet weak var addPaymentDetailsView: AddPaymentDetailsView!
    @IBOutlet weak var saveCardButton: VFGButton!
    @IBOutlet weak var securityLabel: VFGLabel!
    @IBOutlet weak var laterUseLabel: VFGLabel!
    @IBOutlet weak var toggleButton: VFGButton!
    @IBOutlet weak var keyboardViewHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var editPaymentDetailsLabel: VFGLabel!

    var didPurchaseGift = false
    weak var delegate: VFGQuickActionStateInternalProtocol?
    weak var topUpDelegate: VFGTopUpProtocol?
    var saveToggleIsEnabled = false {
        didSet {
            if saveToggleIsEnabled {
                toggleButton.setImage(
                    UIImage.VFGToggle.Medium.active,
                    for: .normal)
            } else {
                toggleButton.setImage(
                    UIImage.VFGToggle.Medium.inactive,
                    for: .normal)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        editPaymentDetailsLabel.text = "quick_action_add_new_payment_card_subtitle".localized(
            bundle: Bundle.mva10Framework
        )
    }
    func configure(didPurchaseGift: Bool) {
        addPaymentDetailsView.load()
        addPaymentDetailsView.delegate = self
        observeKeyboard()
        addKeyboardDismissHandler()
        configureUI()
        setupSaveButton()
        self.didPurchaseGift = didPurchaseGift
        setVoiceOverAccessibility()
    }

    func configureUI() {
        securityLabel.text = "quick_action_add_new_payment_card_encryption_hint".localized(bundle: .mva10Framework)
        laterUseLabel.text = "quick_action_add_new_payment_card_save_this_card".localized(bundle: .mva10Framework)
        saveCardButton.accessibilityIdentifier = "addPaymentCardButton"
    }

    private func setupSaveButton() {
        saveCardButton.isEnabled = false
        saveCardButton.setTitle(
            "quick_action_add_new_payment_card_done".localized(bundle: .mva10Framework),
            for: .normal
        )
    }

    @IBAction func toggleButtonClicked(_ sender: Any) {
        saveToggleIsEnabled.toggle()
    }

    @IBAction func addNewCard(_ sender: VFGButton) {
        addPaymentCard()
    }

    func addPaymentCard() {
        var paymentDetails = addPaymentDetailsView.details
        if topUpDelegate?.isCustomTopUpFlow ?? false {
            if !saveToggleIsEnabled {
                paymentDetails.isTempCard = true
            }
            VFGPaymentManager.add(paymentCard: paymentDetails) { [weak self] error in
                guard let self = self else { return }
                guard error == nil else {
                    self.display(error)
                    return
                }
                self.delegate?.backAndReloadAction()
            }
        } else {
            if saveToggleIsEnabled {
                VFGPaymentManager.add(paymentCard: paymentDetails) { [weak self] error in
                    guard let self = self else { return }
                    guard error == nil else {
                        self.display(error)
                        return
                    }
                }
            }
            self.delegate?.addNewCardDidFinish(withGift: self.didPurchaseGift, completion: nil)
        }
    }

    private func display(_ error: AddPaymentErrorModel?) {
        guard let error = error else {
            return
        }
        let addPaymentCardErrorView = AddPaymentCardErrorView(error: error)
        addPaymentCardErrorView.delegate = self
        VFQuickActionsViewController.presentQuickActionsViewController(with: addPaymentCardErrorView)
    }
}

extension AddPaymentCardView: AddPaymentErrorDelegate {
    public func retryAddCard() {
        addPaymentCard()
    }

    func disableActionButton() {
        saveCardButton.isEnabled = false
    }
}

extension AddPaymentCardView: AddPaymentDetailsViewDelegate {
    func detailsDidChange() {
        saveCardButton.isEnabled = addPaymentDetailsView.isValid()
    }

    func cardNumberIsEmpty() {
        saveCardButton.isEnabled = false
    }
}

extension AddPaymentCardView {
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(whenKeyboardOpens),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(whenKeyboardCloses),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    @objc func whenKeyboardOpens (notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        keyboardViewHightConstraint.constant = keyboardFrame?.height ?? 0
    }

    @objc func whenKeyboardCloses() {
        keyboardViewHightConstraint.constant = 0
    }
}

// MARK: - setVoiceOverAccessibility
extension AddPaymentCardView {
    private func setVoiceOverAccessibility() {
        securityLabel.accessibilityLabel = securityLabel.text
        laterUseLabel.accessibilityLabel = laterUseLabel.text
        editPaymentDetailsLabel.accessibilityLabel = editPaymentDetailsLabel.text

        saveCardButton.accessibilityLabel = saveCardButton.titleLabel?.text
        toggleButton.accessibilityLabel = "toggle button"
        accessibilityCustomActions = [saveCardVoiceOverAction(), toggleVoiceOverAction()]
    }

    func saveCardVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = saveCardButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(addNewCard))
    }

    func toggleVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = toggleButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(toggleButtonClicked))
    }
}
