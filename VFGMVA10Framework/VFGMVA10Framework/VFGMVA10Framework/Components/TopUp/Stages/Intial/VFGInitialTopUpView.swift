//
//  VFTopUpActionView.swift
//  VFGMVA10Group
//
//  Created by Mohamed Mahmoud Zaki on 7/31/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

extension VFGInitialTopUpView: VFGPaymentMethodsCardViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didHeightChanged height: CGFloat,
        viewHeight: CGFloat
    ) {
        // use this height to reload the quickAction VC with the new height
        paymentMethodsCardViewHeightConstraint.constant = viewHeight
        layoutIfNeeded()
    }
}
public enum InitialTopUpState: String {
    case populated
    case loading
    case error
}

class VFGInitialTopUpView: UIView {
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var paymentMethodsCard: VFGPaymentMethodsCardView!
    @IBOutlet weak var paymentMethodsCardViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var subTitle: VFGLabel!
    @IBOutlet weak var topupNowButton: VFGButton!
    @IBOutlet weak var giftImageView: VFGImageView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var tabsStackView: UIStackView!
    @IBOutlet weak var amountEntryStackView: UIStackView!
    @IBOutlet weak var amountEntryStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var amountTextField: VFGTextField!
    @IBOutlet weak var textFieldCurrencyLabel: UILabel!
    @IBOutlet weak var tabsStackViewTopConstraint: NSLayoutConstraint!


    weak var topUpDelegate: VFGTopUpProtocol?
    weak var delegate: VFGInitialTopUpProtocol?
    var amountPickerView: TopUpAmountPickerViewProtocol?
    var topUpShimmerView: TopUpShimmerView?
    var errorCardView: VFGErrorView?
    var viewModel: VFGInitialTopUpViewModel?
    var iconImageName: String {
        viewModel?.giftImageName ?? ""
    }
    var withCustomAmount = false
    let errorCardConstraintConstant: CGFloat = 100
    let tabsStackViewTopConstraintConstant: CGFloat = 30
    var selectedAmount: Double = 0
    var selectedAmountEntryType: VFGAmountEntryType = .quickTopup
    var currentState: InitialTopUpState = .populated {
        didSet {
            if currentState == oldValue {
                return
            }
            switch currentState {
            case .loading:
                showShimmer()
                removeErrorCard()
            case .error:
                showErrorCard()
                hideShimmer()
            default:
                hideShimmer()
                removeErrorCard()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        amountTextField.delegate = self
        paymentMethodsCard.shouldHideAlternativePayments = true
        paymentMethodsCard?.collectionViewDelegate = self
    }

    func configure(
        with topUpDelegate: VFGTopUpProtocol?,
        viewModel: VFGInitialTopUpViewModel,
        completion: (() -> Void)? = nil
    ) {
        self.viewModel = viewModel

        addKeyboardDismissHandler()
        withCustomAmount = viewModel.withCustomAmount
        currentState = .loading
        topUpDelegate?.topUpActionsProtocol = self
        self.topUpDelegate = topUpDelegate

        let presenterType: VFGPresenterType = viewModel.entryPoint == .autoTopUp ? .autoTopUp : .topUp
        paymentMethodsCard.configure(
            title: viewModel.paymentMethodTitle,
            editText: viewModel.editLabel,
            presenterType: presenterType)
        paymentMethodsCard.paymentCardStateDelegate = self

        topupNowButton.isEnabled = true
        subTitle.text = viewModel.subTitle
        topupNowButton.setTitle(viewModel.buttonTitle, for: .normal)
        topupNowButton.alpha = 1

        setupTabs()
        configureTextField()

        switch viewModel.amountPickerAxis {
        case .vertical:
            amountPickerView = UIView.loadXib(
                bundle: .mva10Framework,
                nibName: String(describing: VerticalTopUpAmountPickerView.self)
            ) as? VerticalTopUpAmountPickerView
        case .horizontal:
            amountPickerView = UIView.loadXib(
                bundle: .mva10Framework,
                nibName: String(describing: HorizontalTopUpAmountPickerView.self)
            ) as? HorizontalTopUpAmountPickerView
        }

        guard let amountPickerView else { return }
        let hasOffer = viewModel.entryPoint == .discoveryCard

        pickerContainerView.embed(view: amountPickerView)
        amountPickerView.configure(
            with: self,
            hasOffer: hasOffer,
            completion: completion)
        amountEntryStackViewHeightConstraint.constant = amountPickerView.frame.height

        giftImageView.image = VFGImage(named: iconImageName)
        giftImageView.isHidden = !hasOffer

        checkPreviousSelection()
        setAccessibilityForVoiceOver()
    }

    func setAccessibilityForVoiceOver() {
        subTitle.accessibilityLabel = subTitle.text ?? ""
        topupNowButton.accessibilityLabel = topupNowButton.titleLabel?.text ?? ""
        accessibilityCustomActions = [topUpNowButtonVoiceOverAction()]
    }

    func checkPreviousSelection() {
        guard let viewModel = viewModel,
            let topupModel = topUpDelegate?.model else { return }
        if viewModel.entryPoint == .autoTopUp && viewModel.isEditingMode {
            guard let previousSelectedCard = viewModel.activeAutoTopUpModel?.paymentCard else { return }
            paymentMethodsCard.showSelected(card: previousSelectedCard)
            paymentMethodsCard.initialSelectedCard = previousSelectedCard
            selectedAmount = viewModel.activeAutoTopUpModel?.autoTopUpAmount ?? 0
            let previousSelectedIndex = (topupModel.amounts?.lastIndex(of: selectedAmount) ?? 0)
            amountPickerView?.selectRow(previousSelectedIndex)
        }
    }

    func handleTopupNowButtonEnableState() {
        if selectedAmountEntryType == .quickTopup {
            topupNowButton.isEnabled = true
        } else {
            validateAmountTextField(text: amountTextField.textFieldText)
        }
    }

    // MARK: - Actions
    @IBAction func topUpNowButtonDidPress(_ sender: Any) {
        topUpNowButtonPressed()
    }
    @objc func topUpNowButtonPressed() {
        VFGDebugLog("Set recurrence clicked")
        if selectedAmountEntryType == .quickTopup {
            selectedAmount = amountPickerView?.selectedAmount ?? 0
        } else {
            selectedAmount = Double(amountTextField.textFieldText) ?? 0
        }

        if !(self.paymentMethodsCard.selectedViewId?.isEmpty ?? true) {
            VFGPaymentManager.alternativePaymentProvider?.didSelectSection(
                for: self.paymentMethodsCard.selectedViewId,
                with: selectedAmount,
                paymentIdentifier: nil) { [weak self] _ in
                self?.animateViewDismissal()
            }
        } else if viewModel?.entryPoint != .autoTopUp {
            animateViewDismissal()
        } else {
            if let card = paymentMethodsCard.shownPaymentCards.first {
                VFGPaymentManager.pay(
                    amount: selectedAmount,
                    with: card
                ) { [weak self] _ in
                    self?.animateViewDismissal()
                }
            }
        }
    }
    func topUpNowButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = topupNowButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(topUpNowButtonPressed))
    }

    @objc func tabButtonDidPress(sender: VFGButton) {
        guard sender.tag != selectedAmountEntryType.rawValue else {
            return
        }
        selectTabButton(at: sender.tag)
    }
}

extension VFGInitialTopUpView: VFGPaymentMethodCardStateDelegate {
    func fetchPaymentDidFinish(with error: Error?) {
        if error != nil || topUpDelegate?.model == nil {
            currentState = .error
        } else {
            delegate?.topupPresented()
            currentState = .populated
        }
    }
}
