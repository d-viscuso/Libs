//
//  PersonalAdvisorViewController.swift
//  VFGMVA10PersonalAdvisor
//
//  Created by Vasiliki Trachani, Vodafone on 10/08/2022.
//

import UIKit
import VFGMVA10Foundation


public class VFGPersonalAdvisorViewController: UIViewController {
    @IBOutlet weak var customerImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var confirmButton: VFGButton!
    @IBOutlet weak var phoneNumberTextField: VFGTextField!
    @IBOutlet weak var descriptionTipLabel: VFGLabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var personalAdvisorTitleLabel: VFGLabel!
    @IBOutlet weak var personalAdvisorNameLabel: VFGLabel!
    @IBOutlet weak var infoLabel: VFGLabel!
    @IBOutlet weak var checkPreviousRequestStatusView: UIView!
    @IBOutlet weak var checkPreviousRequestStatusLabel: VFGLabel!
    @IBOutlet weak var checkPreviousRequestStatusButton: VFGButton!
    @IBOutlet weak var checkPreviousRequestStatusImageView: VFGImageView!
    public weak var delegate: VFGPersonalAdvisorProtocol?
    /// Delegate for handling result of send request status changes
    public weak var personalAdvisorAskChangeResult: VFGPersonalAdvisorResultProtocol?
    var quickActionsResultView: VFGQuickActionsResultView?
    var status: VFGPersonalAdvisorStatus?
    public override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardDismissHandler()
        observeKeyboardNotifications()
        setUpUI()
        setupAccessibilityIDs()
        setUpTextField()
        setupDescriptionTextView()
        setupConfirmButton()
        personalAdvisorAskChangeResult = self
    }
    func setUpUI() {
        titleLabel.text = "personal_advisor_subtitle".localized(bundle: .mva10Framework)
        personalAdvisorTitleLabel.text = "personal_advisor_customer_title".localized(bundle: .mva10Framework)
        infoLabel.text = "personal_advisor_info_label".localized(bundle: .mva10Framework)
        checkPreviousRequestStatusLabel.text =
        "personal_advisor_status_request_button_title".localized(bundle: .mva10Framework)
        checkPreviousRequestStatusButtonHidden(hasPreviousRequest: delegate?.hasPreviousRequest)
        personalAdvisorNameLabel.text = delegate?.personalAdvisorName
        checkPreviousRequestStatusImageView.image = UIImage.VFGChevronRightRed
        customerImageView.image = UIImage.VFGCustomer
        setUpInfoView()
    }
    // Info View Configuration
    func setUpInfoView() {
        infoView.layer.cornerRadius = 15
        infoView.configureShadow()
    }
    func setupAccessibilityIDs() {
        phoneNumberTextField.setErrorHintLabelIdentifier(with: "PAphoneNumberTextField")
        confirmButton.accessibilityIdentifier = "PAsendRequestButton"
        checkPreviousRequestStatusButton.accessibilityIdentifier = "PAcheckStatusRequestButton"
    }
    // Phone Number TextField Configuration
    func setUpTextField() {
        phoneNumberTextField.resetTextField()
        phoneNumberTextField.delegate = self
        let phoneNumberText =
        "personal_advisor_phonenumber_textfield_placeholder".localized(bundle: .mva10Framework)
        phoneNumberTextField.configureTextField(
            topTitleText: "personal_advisor_phonenumber_tip_label".localized(bundle: .mva10Framework),
            placeHolder: phoneNumberText,
            inputType: UIKeyboardType.phonePad,
            tipText: "personal_advisor_phonenumber_title".localized(bundle: .mva10Framework)
        )
        phoneNumberTextField.maxLength = delegate?.phoneMaxLength
        phoneNumberTextField.allowedCharacters = delegate?.phoneAllowedCharacters
    }
    // Description TextView Configuration
    func setupDescriptionTextView() {
        descriptionTextView.text = "personal_advisor_decription_placeholder".localized(bundle: .mva10Framework)
        descriptionTextView.textColor = .VFGDefaultInputPlaceholderText
        descriptionTextView.font = UIFont.vodafoneRegular(18)
        descriptionTextView.backgroundColor = .VFGWhiteBackground
        descriptionTextView.layer.cornerRadius = 6
        descriptionTextView.layer.borderColor = UIColor.VFGDefaultInputOutline.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.delegate = self
        setUpDescriptionBottomText()
    }
    // Description TextView Bottom Label Configuration
    func setUpDescriptionBottomText() {
        if let isDescriptionBottomLabelHidden =
            delegate?.isDescriptionBottomLabelHidden,
            let descriptionMaxLength = delegate?.descriptionMaxLength {
            descriptionTipLabel.textColor = .VFGSecondaryText
            descriptionTipLabel.isHidden = isDescriptionBottomLabelHidden
            let tipDescriptionTitle = "personal_advisor_decription_tip_label".localized(bundle: .mva10Framework)
            descriptionTipLabel.text = "\(tipDescriptionTitle) \(descriptionMaxLength)"
        }
    }
    // Confirmation Button Configuration
    func setupConfirmButton() {
        confirmButton.isEnabled = false
        confirmButton.setTitle(
            "personal_advisor_confirm_button_title".localized(bundle: .mva10Framework),
            for: .normal
        )
    }
    // Previous Status Requset Button Configuration
    func checkPreviousRequestStatusButtonHidden(hasPreviousRequest: Bool?) {
        guard let hasPreviousRequest = hasPreviousRequest else { return }
        checkPreviousRequestStatusView.isHidden = !hasPreviousRequest
        checkPreviousRequestStatusButton.isEnabled = hasPreviousRequest
    }
    @IBAction func confirmButtonAction(_ sender: Any) {
        sendRequestAction()
    }
    func sendRequestAction() {
        delegate?.confirmButtonAction(
            phoneNumber: phoneNumberTextField.textFieldText,
            descriptionOfRequest: descriptionTextView.text) { [weak self] sendRequestStatus in
                guard let self = self else { return }
                if sendRequestStatus {
                    self.status = .sendRequest(type: true)
                    self.personalAdvisorAskChangeResult?.showSuccessQuickResult()
                } else {
                    self.status = .sendRequest(type: false)
                    self.personalAdvisorAskChangeResult?.showErrorQuickResult()
                }
        }
    }
    @IBAction func checkPreviousRequestStatusAction(_ sender: Any) {
        checkPreviousRequestStatus()
    }
    func checkPreviousRequestStatus() {
        delegate?.checkPreviousRequestStatus { [weak self] statusPreviousRequest in
            guard let self = self else { return }
            let statusRequestmodel = self.createPreviousRequestStatusView(type: statusPreviousRequest)
            if statusPreviousRequest == .failed {
                presentPreviousRequestStatusFailureView(statusRequestmodel: statusRequestmodel)
            } else {
                presentPreviousRequestStatusSuccessView(statusRequestmodel: statusRequestmodel)
            }
        }
    }
}
