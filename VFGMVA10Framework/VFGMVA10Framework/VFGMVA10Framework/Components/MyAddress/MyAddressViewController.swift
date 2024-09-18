//
//  MyAddressViewController.swift
//  VFGMVA10Framework
//
//  Created by Hamsa Hassan on 1/3/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// My Address View Controller
/// View Controller that contains saved addresses
public class MyAddressViewController: UIViewController {
    @IBOutlet weak var currentTitle: VFGLabel!
    @IBOutlet weak var currentSubTitle: VFGLabel!
    @IBOutlet weak var correspondenceAddress: VFGLabel!
    @IBOutlet weak var myAddressLabel: VFGLabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var editButton: VFGButton!
    @IBOutlet weak var deleteButton: VFGButton!
    @IBOutlet weak var imageView: VFGImageView!
    @IBOutlet weak var stateLabel: VFGLabel!
    @IBOutlet weak var countryLabel: VFGLabel!
    @IBOutlet weak var editLabel: VFGLabel!
    @IBOutlet weak var deleteLabel: VFGLabel!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var editView: UIView!
    /// Delete address protocol
    public weak var delegate: VFGDeleteAddressProtocol?
    var quickActionsResultView: VFGQuickActionsResultView?
    var isSucceedDelete = false
    public override func viewDidLoad() {
        super.viewDidLoad()
        cardView.addingShadow(size: CGSize(width: 0, height: 2), radius: 8, opacity: 0.16)
        setupLabels()
        setupButtons()
        setAccessibilityIdentifier()
        setAccessibilityForVoiceOver()
        if VFGMyAddressManager.myAddress == nil {
            navigateToChangeAddress()
        }
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAddressLabel()
    }
    func setupLabels() {
        currentTitle.text = "my_address_current_title".localized(bundle: .mva10Framework)
        currentSubTitle.text = "my_address_current_subtitle".localized(bundle: .mva10Framework)
        correspondenceAddress.text = "my_address_correspondence_title".localized(bundle: .mva10Framework)
        editLabel.text = "my_address_edit_button_title".localized(bundle: .mva10Framework)
        deleteLabel.text = "my_address_delete_button_title".localized(bundle: .mva10Framework)
    }

    func setupAddressLabel() {
        guard let model = VFGMyAddressManager.myAddress else {
            hideMyAddressCard()
            return
        }
        showMyAddressCard()
        myAddressLabel.text = "\(model.houseNumber) \(model.streetName),"
        stateLabel.text = "\(model.city) \(model.postcode),"
        countryLabel.text = "\(model.country)"
    }
    func setupButtons() {
        deleteView.isHidden = !VFGMyAddressManager.showDeleteButton
        editView.isHidden = !VFGMyAddressManager.showEditButton
    }
    func setAccessibilityIdentifier() {
        view.accessibilityIdentifier = "MAsecondScreen"
        cardView.accessibilityIdentifier = "MAcardView"
        myAddressLabel.accessibilityIdentifier = "MAaddressLabel"
        editButton.accessibilityIdentifier = "MAchangeAddressButton"
        deleteButton.accessibilityIdentifier = "MAdeleteButton"
        imageView.accessibilityIdentifier = "MAhomeImageView"
    }
    func setAccessibilityForVoiceOver() {
        currentTitle.accessibilityLabel = currentTitle.text ?? ""
        currentSubTitle.accessibilityLabel = currentSubTitle.text ?? ""
        correspondenceAddress.accessibilityLabel = correspondenceAddress.text ?? ""
        myAddressLabel.accessibilityLabel = myAddressLabel.text ?? ""
        editButton.accessibilityLabel = "Edit"
        deleteButton.accessibilityLabel = "Delete"
        imageView.accessibilityLabel = "Home"
        accessibilityElements = [
            "",
            currentSubTitle ?? "",
            imageView ?? "",
            correspondenceAddress ?? "",
            myAddressLabel ?? "",
            editButton ?? "",
            deleteButton ?? ""
        ]
        accessibilityCustomActions = [changeAddressVoiceOverAction(), deleteAddressVoiceOverAction()]
    }
    private func hideMyAddressCard() {
        cardView.isHidden = true
    }

    private func showMyAddressCard() {
        cardView.isHidden = false
    }

    private func navigateToChangeAddress() {
        VFGMyAddressManager.navigateToChangeAddressViewController(
            navigation: navigationController as? MVA10NavigationController)
    }

    @IBAction func changeAddress(_ sender: Any) {
        changeAddressPressed()
    }
    @objc func changeAddressPressed() {
        VFGMyAddressManager.navigateToChangeAddressViewController(
            navigation: (self.navigationController as? MVA10NavigationController)
        )
    }
    func changeAddressVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "Edit address"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(changeAddressPressed))
    }
    @IBAction func deleteAddress(_ sender: Any) {
        deleteAddressPressed()
    }
    @objc func deleteAddressPressed() {
        let blockingView = VFGDeleteAddressView()
        blockingView.delegateDeleteAddress = delegate
        blockingView.delegateListAddress = self
        VFQuickActionsViewController.presentQuickActionsViewController(with: blockingView)
    }

    func deleteAddressVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "Delete address"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(deleteAddressPressed))
    }
}

// MARK: - VFGTrayContainerProtocol
extension MyAddressViewController: VFGTrayContainerProtocol {
    /// Tobi identifier key
    public var tobiKey: String {
        "\(MyAddressViewController.self)"
    }
    /// TObi displaying style
    public var trayStyle: VFGTrayStyle {
        .TOBI
    }
    /// Tobi View controller
    public var tobiContainerVC: UIViewController? {
        return VFGManagerFramework.tobiDelegate?
            .helpViewController(for: "\(MyAddressViewController.self)")
    }
}

// MARK: - VFGListAddressProtocol
extension MyAddressViewController: VFGListAddressProtocol {
    /// Delegate method to show Success View
    public func showSuccessView() {
        isSucceedDelete = true
        presentQuickActionsSuccessView()
    }
    /// Delegate method to show Error View
    public func showErrorView() {
        isSucceedDelete = false
        presentQuickActionsFailureView()
    }
}

// MARK: - VFGQuickActionsViews
extension MyAddressViewController {
    func presentQuickActionsSuccessView() {
        let model = VFGQuickActionsResultModel(
            type: .success,
            delegate: self,
            titleText: "change_address_modal_success_title".localized(bundle: .mva10Framework),
            descriptionText: "delete_address_modal_success_subtitle".localized(bundle: .mva10Framework),
            primaryButtonTitle: "change_address_modal_success_button_title".localized(bundle: .mva10Framework))
        quickActionsResultView = VFGQuickActionsResultView(
            title: "my_address_screen_title".localized(bundle: .mva10Framework),
            isCloseButtonHidden: false,
            model: model
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
            descriptionText: "delete_address_modal_failure_subtitle".localized(bundle: .mva10Framework),
            primaryButtonTitle: "change_address_modal_failure_button_title".localized(bundle: .mva10Framework))
        quickActionsResultView = VFGQuickActionsResultView(
            title: "my_address_screen_title".localized(bundle: .mva10Framework),
            isCloseButtonHidden: false,
            model: model
        )
        guard let quickActionsResultView = quickActionsResultView else { return }
        VFQuickActionsViewController
            .presentQuickActionsViewController(with: quickActionsResultView)
    }
}

// MARK: - VFGResultViewProtocol
extension MyAddressViewController: VFGResultViewProtocol {
    /// Result View Main Button action 
    public func resultViewPrimaryButtonAction() {
        quickActionsResultView?.closeQuickAction(isCloseButton: false) {
            if self.isSucceedDelete {
                self.dismiss(animated: true)
            }
        }
    }
}
