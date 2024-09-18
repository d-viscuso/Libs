//
//  AddPaymentCardViewController.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 8/26/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import Lottie

/// Add payment card view controller.
public class AddPaymentCardViewController: UIViewController {
    @IBOutlet weak var addCardView: UIView!
    @IBOutlet weak var scanCardView: UIView!
    @IBOutlet weak var addPaymentDetailsView: AddPaymentDetailsView!

    @IBOutlet weak var scanCardButton: VFGButton!
    @IBOutlet weak var scanCardHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addCardViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var addCardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveCardButton: VFGButton!
    @IBOutlet weak var deleteButton: VFGButton!
    @IBOutlet weak var securityLabel: VFGLabel!

    var addPaymentCardEditModeHeight: CGFloat = 580
    var cardId: String?
    var cardName: String?
    var isEditable = false
    lazy var loadingLogoView: VFGLoadingLogoView? = {
        let loadingScreenView: VFGLoadingLogoView? = VFGLoadingLogoView.loadXib(bundle: Bundle.foundation)
        loadingScreenView?.configure(
            style: .white,
            view: navigationController?.view ?? view,
            backgroundColor: UIColor.black.withAlphaComponent(0.6)
        )

        return loadingScreenView
    }()

    var paymentCard: PaymentModelProtocol?
    /// Scan card view manager.
    public var scanCardViewManager: ScanCardViewManagerProtocol?

    public override func viewDidLoad() {
        super.viewDidLoad()

        addPaymentDetailsView.delegate = self
        addKeyboardDismissHandler()
        configureUI()
        setupSaveButton()
        if isEditable {
            if let navigaition = navigationController as? MVA10NavigationController {
                navigaition.setTitle(title: cardName ?? "", for: self)
            }
            hideScanCard()
            fetchPaymentCard()
        }
        setVoiceOverAccessibility()
    }

    func fetchPaymentCard() {
        if let cardId = cardId {
            let addCardShimmerView = AddCardShimmerView(frame: addCardView.bounds)
            addCardShimmerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            addCardShimmerView.startShimmer()
            addCardView.addSubview(addCardShimmerView)
            VFGPaymentManager.fetchPaymentCard(by: cardId) { card, error in
                guard error == nil,
                let card = card else {
                    return
                }
                addCardShimmerView.stopShimmer()
                self.setupEditableMode(with: card)
            }
        }
    }

    func configureUI() {
        if scanCardViewManager?.viewController == nil {
            hideScanCard()
        }
        addCardView.configureShadow()
        scanCardView.configureShadow()
        addPaymentDetailsView.load()
        scanCardButton.setTitle("payment_scan_card_button".localized(bundle: .mva10Framework), for: .normal)
    }

    func setupEditableMode(with creditCard: PaymentModelProtocol) {
        addPaymentDetailsView.setup(with: creditCard)
        setupDeleteButton()
        addCardHeightConstraint.constant = addPaymentCardEditModeHeight
    }

    private func hideScanCard() {
        scanCardView.isHidden = true
        addCardViewTopSpace.constant = 0
        scanCardHightConstraint.constant = 0
    }

    private func setupDeleteButton() {
        deleteButton.setTitle(
            "payment_delete_form_delete_button".localized(bundle: .mva10Framework),
            for: .normal
        )
        deleteButton.isHidden = false
    }

    private func setupSaveButton() {
        saveCardButton.isEnabled = false
        saveCardButton.setTitle(
            "payment_add_form_save_button".localized(bundle: .mva10Framework),
            for: .normal
        )
    }

    @IBAction func upsertCard(_ sender: VFGButton) {
        if isEditable {
            updatePaymentCard()
        } else {
            addPaymentCard()
        }
    }

    @IBAction func deleteCard(_ sender: VFGButton) {
        let deletePaymentCard = VFGDeletePaymentCardView(
            deleteAction: { [weak self] in
                guard let self = self, let cardId = self.cardId else {
                    return
                }

                self.deletePaymentCard(cardId)
            },
            cardName: addPaymentDetailsView.cardNameTextField.textFieldText
        )

        VFQuickActionsViewController.presentQuickActionsViewController(with: deletePaymentCard)
    }

    private func startLoading() {
        loadingLogoView?.startLoading()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    private func endLoading() {
        loadingLogoView?.endLoading()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    func addPaymentCard() {
        startLoading()
        VFGPaymentManager.add(paymentCard: addPaymentDetailsView.details) { [weak self] error in
            self?.endLoading()
            guard error == nil else {
                self?.display(error)
                return
            }
            self?.navigationController?.popViewController(animated: true)
        }
    }

    func updatePaymentCard() {
        startLoading()
        VFGPaymentManager.update(paymentCard: addPaymentDetailsView.details) { [weak self] error in
            self?.endLoading()
            guard error == nil else {
                self?.display(error)
                return
            }

            self?.navigationController?.popViewController(animated: true)
        }
    }

    func deletePaymentCard(_ cardId: String) {
        startLoading()
        VFGPaymentManager.deletePaymentCard(by: cardId) { [weak self] _ in
            self?.endLoading()
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
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

extension AddPaymentCardViewController: VFGTrayContainerProtocol {
    public var tobiKey: String {
        "\(AddPaymentCardViewController.self)"
    }

    public var trayStyle: VFGTrayStyle {
        .TOBI
    }

    public var tobiContainerVC: UIViewController? {
        return VFGManagerFramework.tobiDelegate?.helpViewController(for:
            "\(AddPaymentCardViewController.self)")
    }
}

extension AddPaymentCardViewController: AddPaymentErrorDelegate {
    public func retryAddCard() {
        addPaymentCard()
    }

    func disableActionButton() {
        saveCardButton.isEnabled = false
    }
}

extension AddPaymentCardViewController: AddPaymentDetailsViewDelegate {
    func detailsDidChange() {
        saveCardButton.isEnabled = addPaymentDetailsView.isValid()
    }

    func cardNumberIsEmpty() {
        saveCardButton.isEnabled = false
    }
}

// MARK: - setVoiceOverAccessibility
extension AddPaymentCardViewController {
    private func setVoiceOverAccessibility() {
        securityLabel.accessibilityLabel = securityLabel.text ?? ""
        scanCardButton.accessibilityLabel = scanCardButton.titleLabel?.text
        saveCardButton.accessibilityLabel = saveCardButton.titleLabel?.text
        deleteButton.accessibilityLabel = deleteButton.titleLabel?.text
        accessibilityCustomActions = [scanCardVoiceOverAction(), saveCardVoiceOverAction(), deleteCardVoiceOverAction()]
    }

    func scanCardVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = scanCardButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(upsertCard))
    }

    func saveCardVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = scanCardButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(upsertCard))
    }

    func deleteCardVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = scanCardButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(deleteCard))
    }
}
