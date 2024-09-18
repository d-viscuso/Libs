//
//  VFGTopUpSomeoneElseView.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Zaki on 09/03/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
import ContactsUI

class VFGTopUpSomeoneElseView: UIView {
    @IBOutlet weak var title: VFGLabel!
    @IBOutlet weak var newRecipientLabel: VFGLabel!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textfield: VFGTextField!
    @IBOutlet weak var nextButton: VFGButton!
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var childContentView: UIView!
    @IBOutlet weak var textfieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var separatorBottomConstraint: NSLayoutConstraint!
    let contactPicker: CNContactPickerViewController? = CNContactPickerViewController()
    var contactStore: CNContactStore?
    weak var someoneElseDelegate: VFGTopUpSomeoneElseProtocol?
    var isOpenContactsGranted = false
    var numberOfAccounts: Int?
    let cellId = "VFGSubAccountsItemCollectionViewCell"
    var viewModel: VFGTopUpSomeoneElseViewModel?
    var textfieldConstraintConstantWithNoChild: CGFloat = 312
    var separatorBottomConstraintConstNoChild: CGFloat = 19
    var validationTimer = Timer()

    @IBAction func contactButtonDidPress(_ sender: Any) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        checkContactsAccess(authorizationStatus: authorizationStatus)
        someoneElseDelegate?.contactButtonDidPress()
    }

    @IBAction func nextButton(_ sender: Any) {
        evaluateTopupStatement(use: textfield.textFieldText)
    }

    func configure(with viewModel: VFGTopUpSomeoneElseViewModel) {
        contactPicker?.delegate = self
        if isOpenContactsGranted {
            openContactsList()
        }
        self.viewModel = viewModel
        setCollectionViewDelegates()
        observeKeyboard()
        registerCell()
        addKeyboardDismissHandler()
        setupUI(viewModel: viewModel)
        setupTextFieldToolBar()
    }

    func registerCell() {
        let nibCell = UINib(nibName: cellId, bundle: .mva10Framework)
        collectionView?.register(nibCell, forCellWithReuseIdentifier: cellId)
    }

    func showOpenSettingAlert() {
        DispatchQueue.main.async {
            UIApplication.topViewController()?.presentAlert(
                title: "contacts_permission_alert_title".localized(bundle: Bundle.mva10Framework),
                message: "contacts_permission_alert_message".localized(bundle: Bundle.mva10Framework),
                actionTitle: "contacts_permission_alert_confirm_title".localized(bundle: Bundle.mva10Framework),
                cancelTitle: "contacts_permission_alert_cancel_title".localized(bundle: Bundle.mva10Framework)) { _ in
                    self.openAppSetting()
            }
        }
    }

    func openAppSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }

    func setCollectionViewDelegates() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }

    func setupUI(viewModel: VFGTopUpSomeoneElseViewModel) {
        title.text = viewModel.sectionTitle
        newRecipientLabel.text = viewModel.newRecipentTitle
        nextButton.setTitle(viewModel.nextButtonTitle, for: .normal)
        nextButton.isEnabled = false
        textfield.delegate = self
        textfield.configureTextField(
            topTitleText: viewModel.textfieldHeaderTtitle,
            placeHolder: viewModel.textfieldPlaceHolder,
            inputType: .numberPad,
            counterMaxLength: viewModel.phoneNumberMaxLenght)
        textfield.configureTextFieldStyle(textFont: .vodafoneRegular(19))
        let bottom = !UIApplication.shared.windows.isEmpty ?
            UIApplication.shared.windows[0].safeAreaInsets.bottom : 0
        keyboardHeightConstraint.constant = bottom
        if viewModel.accounts.isEmpty {
            childContentView.isHidden = true
        }

        if let view = viewModel.customView {
            customView.isHidden = false
            customView.embed(view: view)
            customView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0).isActive = true
        } else {
            customView.isHidden = true
        }

        if viewModel.accounts.isEmpty && viewModel.customView == nil {
            textfieldBottomConstraint.constant = textfieldConstraintConstantWithNoChild
            separatorBottomConstraint.constant = separatorBottomConstraintConstNoChild
        }
    }

    func setupTextFieldToolBar() {
        let done = UIBarButtonItem(
            title: "top_up_someone_else_new_recipient_keyboard_done_text".localized(bundle: Bundle.mva10Framework),
            style: .done,
            target: self,
            action: #selector(doneButtonTapped))
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        textfield.configureInputAccessoryView(items: [flexSpace, done])
    }

    @objc func doneButtonTapped() {
        endEditing(true)
        evaluateTopupStatement(use: textfield.textFieldText)
    }

    func openContactsList() {
        guard let contactPicker = contactPicker else {
            return
        }
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(contactPicker, animated: true)
        }
    }
}

extension VFGTopUpSomeoneElseView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.accounts.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellId,
            for: indexPath) as? VFGSubAccountsItemCollectionViewCell else {
            return VFGSubAccountsItemCollectionViewCell()
        }
        if let account = viewModel?.accounts[indexPath.row] {
            cell.setup(title: account.name, msisdn: account.msisdn, imageName: account.imageName ?? "icAdmin")
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        someoneElseDelegate?.navigateToInitial(childAccountIndex: indexPath.row)
    }
}

extension VFGTopUpSomeoneElseView: VFGTextFieldProtocol {
    func vfgTextFieldDidBeginEditing(_ vfgTextField: VFGTextField) {
        textfield.hideError()
    }

    func vfgTextFieldDidEndEditing(_ vfgTextField: VFGTextField) {
        guard let delegate = someoneElseDelegate else { return }
        if textfield.textFieldText.isEmpty {
            textfield.hideError()
        } else if !delegate.validateMobileNumber(number: vfgTextField.textFieldText) {
            textfield.showError(title: viewModel?.textfieldErrorTitle)
        }
    }

    func vfgTextFieldRightButtonClicked(_ vfgTextField: VFGTextField) {}

    fileprivate func validateMobileNumber(_ text: String) {
        guard let delegate = someoneElseDelegate else { return }
        nextButton.isEnabled = delegate.validateMobileNumber(number: text)
    }

    func vfgTextFieldDidChange(_ vfgTextField: VFGTextField, text: String) {
        textfield.hideError()
        validateMobileNumber(text)
        validationTimer.invalidate()
        validationTimer = Timer.scheduledTimer(withTimeInterval: Constants.validationDelay, repeats: false) { timer in
            timer.invalidate()
            if !((self.someoneElseDelegate?.validateMobileNumber(number: vfgTextField.textFieldText) ?? false)
                || vfgTextField.textFieldText.isEmpty) {
                self.textfield.showError(title: self.viewModel?.textfieldErrorTitle)
            }
        }
    }
}

extension VFGTopUpSomeoneElseView {
    private func evaluateTopupStatement(use phoneNumber: String) {
        guard let delegate = someoneElseDelegate else { return }
        let number = phoneNumber.replacingOccurrences(of: " ", with: "")
        guard delegate.validateMobileNumber(number: number) else {
            textfield.showError(title: viewModel?.textfieldErrorTitle)
            return
        }
        self.viewModel?.initialTopDelegate?.requestTopupValidation(
            phoneNumber: phoneNumber
        ) { [weak self] isValid, errorMessage in
            if isValid {
                self?.textfield.hideError()
                self?.viewModel?.initialTopDelegate?.requestTopupSomeoneElse(with: phoneNumber)
                self?.someoneElseDelegate?.nextAction(contactNumber: phoneNumber)
            } else {
                self?.textfield.showError(title: errorMessage)
            }
        }
    }

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
        handleKeyboard(isOn: true, height: keyboardFrame?.height ?? 0)
    }

    @objc func whenKeyboardCloses() {
        handleKeyboard(isOn: false)
    }

    func handleKeyboard(isOn: Bool, height: CGFloat = 0) {
        if isOn {
            keyboardHeightConstraint.constant = (VFGUser.shared.type == .payG ||
            !(viewModel?.accounts.isEmpty ?? true)) ? height : 0
            someoneElseDelegate?.shouldScroll(height: keyboardHeightConstraint.constant)
        } else {
            keyboardHeightConstraint.constant = 0
            someoneElseDelegate?.shouldScroll(height: 0)
        }
    }
}

extension VFGTopUpSomeoneElseView: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        if let phoneNumber = contactProperty.value as? CNPhoneNumber {
            evaluateTopupStatement(use: phoneNumber.stringValue)
        }
    }

    func checkContactsAccess(authorizationStatus: CNAuthorizationStatus) {
        switch authorizationStatus {
        case .authorized:
            openContactsList()
        case .notDetermined:
            contactStore = CNContactStore()
            contactStore?.requestAccess(for: .contacts) { [weak self] granted, error in
                if granted && error == nil {
                    self?.openContactsList()
                }
            }
        default:
            showOpenSettingAlert()
        }
    }
}
