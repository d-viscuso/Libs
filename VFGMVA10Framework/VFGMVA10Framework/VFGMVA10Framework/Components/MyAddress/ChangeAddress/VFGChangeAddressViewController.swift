//
//  VFGChangeAddressViewController.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 1/3/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import Lottie

public class VFGChangeAddressViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    @IBOutlet var cardView: UIView!
    @IBOutlet weak var postcodeTextField: VFGTextField!
    @IBOutlet weak var houseNumberTextField: VFGTextField!
    @IBOutlet weak var streetNameTextField: VFGTextField!
    @IBOutlet weak var cityTextField: VFGTextField!
    @IBOutlet weak var countryTextField: VFGTextField!
    @IBOutlet var textFields: [VFGTextField]!
    @IBOutlet weak var saveButton: VFGButton!
    @IBOutlet weak var postCodeViewHeight: NSLayoutConstraint!
    public weak var delegate: VFGChangeAddressProtocol?
    var validationTimer = Timer()
    var saveAddressStatus = false
    var quickActionsResultView: VFGQuickActionsResultView?
    var model: VFGAddressModel {
        VFGAddressModel(
            postcode: postcodeTextField.textFieldText,
            houseNumber: houseNumberTextField.textFieldText,
            streetName: streetNameTextField.textFieldText,
            city: cityTextField.textFieldText,
            country: countryTextField.textFieldText
        )
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardDismissHandler()
        observeKeyboardNotifications()
        cardView.configureShadow()

        setupPostCodeView()
        setupConfirmButton()
        setupLabels()
        setupTextFields()
        setupAccessibilityIdentifier()
        setAccessibilityForVoiceOver()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPrefilledData()
    }

    ///  Update the data of this screen with the given model
    /// - Parameter model: The VFGAddressModel that contains the details of this screen
    public func update(with model: VFGAddressModel) {
        setupPrefilledData(model: model)
    }

    func setupPrefilledData(model: VFGAddressModel? = VFGMyAddressManager.myAddress) {
        guard let model = model else {
            return
        }
        postcodeTextField.textFieldText = model.postcode
        houseNumberTextField.textFieldText = model.houseNumber
        streetNameTextField.textFieldText = model.streetName
        cityTextField.textFieldText = model.city
        countryTextField.textFieldText = model.country
    }

    func setupPostCodeView() {
        if !VFGMyAddressManager.showPostCode {
            postcodeTextField.isHidden = true
            postCodeViewHeight.constant = 0
        }
    }

    func setupConfirmButton() {
        saveButton.isEnabled = false
        saveButton.setTitle(
            "change_address_save_button".localized(bundle: .mva10Framework),
            for: .normal
        )
    }

    func setupLabels() {
        titleLabel.text = "change_address_title".localized(bundle: .mva10Framework)
        descriptionLabel.text = "change_address_subtitle".localized(bundle: .mva10Framework)
    }

    func setupTextFields() {
        textFields.forEach {
            $0.resetTextField()
            $0.configureTextFieldStyle(textFont: .vodafoneRegular(18.7))
            $0.delegate = self
        }
        let postcodeHint =
            "change_address_form_postcode_label".localized(bundle: .mva10Framework)
        postcodeTextField.configureTextField(
            topTitleText: postcodeHint,
            placeHolder: postcodeHint
        )

        let houseNumberHint =
            "change_address_form_house_or_number_label".localized(bundle: .mva10Framework)
        houseNumberTextField.configureTextField(
            topTitleText: houseNumberHint,
            placeHolder: houseNumberHint
        )

        let streetNameHint =
            "change_address_form_street_name_label".localized(bundle: .mva10Framework)
        streetNameTextField.configureTextField(
            topTitleText: streetNameHint,
            placeHolder: streetNameHint
        )

        if let cities = delegate?.cities {
            cityTextField.configureOptionsList(
                topTitleText: "change_address_form_city_label".localized(bundle: .mva10Framework),
                placeHolder: "change_address_form_city_label".localized(bundle: .mva10Framework),
                pickerViewDoneTitle: "change_address_city_selection_done_button_title".localized(bundle:
                    .mva10Framework),
                pickerViewCancelTitle: "change_address_city_selection_cancel_button_title".localized(bundle:
                    .mva10Framework),
                options: cities
            )
        } else {
            cityTextField.configureTextField(
                topTitleText: "change_address_form_city_label".localized(bundle: .mva10Framework),
                placeHolder: "change_address_form_city_label".localized(bundle: .mva10Framework)
            )
        }

        let countryHint =
            "change_address_form_country_label".localized(bundle: .mva10Framework)
        countryTextField.configureCountries(
            topTitleText: countryHint,
            placeHolder: countryHint,
            pickerViewDoneTitle:
                "change_address_country_selection_done_button_title".localized(bundle: .mva10Framework),
            pickerViewCancelTitle:
                "change_address_country_selection_cancel_button_title".localized(bundle: .mva10Framework),
            countries: delegate?.countries
        )
    }

    @IBAction func saveButtonDidPress(_ sender: VFGButton) {
        saveNewAddress()
    }

    @objc func saveNewAddress() {
        validationTimer.invalidate()
        delegate?.saveButtonAction(model: model) { [weak self] status in
            guard let self = self else { return }
            self.saveAddressStatus = status
            if status {
                VFGMyAddressManager.myAddress = self.model
                self.presentQuickActionsSuccessView()
            } else {
                self.presentQuickActionsFailureView()
            }
        }
    }

    func saveNewAddressVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = saveButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(saveNewAddress))
    }

    func presentQuickActionsSuccessView() {
        let model = VFGQuickActionsResultModel(
            type: .success,
            delegate: self,
            titleText: "change_address_modal_success_title".localized(bundle: .mva10Framework),
            descriptionText: "change_address_modal_success_subtitle".localized(bundle: .mva10Framework),
            primaryButtonTitle: "change_address_modal_success_button_title".localized(bundle: .mva10Framework),
            titleFont: .vodafoneBold(25),
            descriptionFont: .vodafoneRegular(17),
            primaryButtonFont: .vodafoneRegular(19))
        quickActionsResultView = VFGQuickActionsResultView(
            title: "change_address_modal_title".localized(bundle: .mva10Framework),
            isCloseButtonHidden: false,
            model: model,
            accessibilityVoiceOverModel: VFGResultViewAccessibilityVoiceOverModel(
                imageViewLabel: nil,
                animationViewLabel: "Check mark animated view")
        )
        guard let quickActionsResultView = quickActionsResultView else { return }
        VFQuickActionsViewController
            .presentQuickActionsViewController(with: quickActionsResultView)
    }

    func presentQuickActionsFailureView() {
        let model = VFGQuickActionsResultModel(
            type: .failure,
            delegate: self,
            titleText: "change_address_modal_failure_title".localized(bundle: .mva10Framework),
            descriptionText: "change_address_modal_failure_subtitle".localized(bundle: .mva10Framework),
            primaryButtonTitle: "change_address_modal_failure_button_title".localized(bundle: .mva10Framework),
            titleFont: .vodafoneBold(25),
            descriptionFont: .vodafoneRegular(17),
            primaryButtonFont: .vodafoneRegular(19))
        quickActionsResultView = VFGQuickActionsResultView(
            title: "change_address_modal_title".localized(bundle: .mva10Framework),
            isCloseButtonHidden: false,
            model: model,
            accessibilityVoiceOverModel: VFGResultViewAccessibilityVoiceOverModel(
                imageViewLabel: "Failure warning view",
                animationViewLabel: nil)
        )
        guard let quickActionsResultView = quickActionsResultView else { return }
        VFQuickActionsViewController
            .presentQuickActionsViewController(with: quickActionsResultView)
    }

    func setAccessibilityForVoiceOver() {
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        descriptionLabel.accessibilityLabel = descriptionLabel.text ?? ""
        postcodeTextField.setTopLabelAccessibilityLabel(
            with: postcodeTextField.textFieldTopTitleText)
        houseNumberTextField.setTopLabelAccessibilityLabel(
            with: houseNumberTextField.textFieldTopTitleText)
        streetNameTextField.setTopLabelAccessibilityLabel(
            with: streetNameTextField.textFieldTopTitleText)
        cityTextField.setTopLabelAccessibilityLabel(
            with: cityTextField.textFieldTopTitleText)
        countryTextField.setTopLabelAccessibilityLabel(
            with: countryTextField.textFieldTopTitleText)
        countryTextField.setTextFieldAccessibilityHint(
            with: "Tap to change country")
        saveButton.accessibilityLabel = saveButton.titleLabel?.text ?? ""
        accessibilityCustomActions = [saveNewAddressVoiceOverAction()]
    }
}

// MARK: - QuickActions Logic
extension VFGChangeAddressViewController: VFGResultViewProtocol {
    public func resultViewPrimaryButtonAction() {
        quickActionsResultView?.closeQuickAction(isCloseButton: false) { [weak self] in
            guard let self = self else { return }
            if self.saveAddressStatus {
                self.delegate?.resultViewPrimaryButtonAction(self)
            } else {
                self.saveNewAddress()
            }
        }
    }

    public func quickActionsClose(isCloseButton: Bool) {
        if saveAddressStatus,
        isCloseButton {
            delegate?.resultViewCloseButtonAction(self)
        }
    }
}

// MARK: - VFGTrayContainerProtocol
extension VFGChangeAddressViewController: VFGTrayContainerProtocol {
    public var tobiKey: String {
        "\(VFGChangeAddressViewController.self)"
    }

    public var trayStyle: VFGTrayStyle {
        .TOBI
    }

    public var tobiContainerVC: UIViewController? {
        return VFGManagerFramework.tobiDelegate?
            .helpViewController(for: "\(VFGChangeAddressViewController.self)")
    }
}

// MARK: - setup accessibilityIdentifier
extension VFGChangeAddressViewController {
    private func setupAccessibilityIdentifier() {
        postcodeTextField.setTextFieldIdentifier(with: "ChangeAddressPostcodeTextField")
        houseNumberTextField.setTextFieldIdentifier(with: "ChangeAddressHouseNumbereTextField")
        streetNameTextField.setTextFieldIdentifier(with: "ChangeAddressStreetNameTextField")
        cityTextField.setTextFieldIdentifier(with: "ChangeAddressCityTextField")
        countryTextField.setTextFieldIdentifier(with: "ChangeAddressCountryTextField")
        saveButton.accessibilityIdentifier = "ChangeAddressSaveButton"
    }
}
