//
//  VFGPayBillView.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 11/17/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

class VFGPayBillView: UIView {
    @IBOutlet weak var paymentMethodsCard: VFGPaymentMethodsCardView!
    @IBOutlet weak var subTitle: VFGLabel!
    @IBOutlet weak var confirmPayButton: VFGButton!
    @IBOutlet weak var cancelButton: VFGButton!
    @IBOutlet weak var amountLabel: VFGLabel!

    weak var delegate: VFGPayBillStateInternalProtocol?
    var billAmount: Double?

    override func awakeFromNib() {
        super.awakeFromNib()
        paymentMethodsCard?.collectionViewDelegate = self
    }

    func configure(
        viewModel: VFGPayBillViewModel,
        completion: (() -> Void)? = nil
    ) {
        subTitle.text = viewModel.subTitle
        amountLabel.text = "\(viewModel.amount)\(viewModel.currency)"
        confirmPayButton.setTitle(viewModel.buttonTitle, for: .normal)
        confirmPayButton.isEnabled = false
        cancelButton.setTitle(viewModel.cancelTitle, for: .normal)
        billAmount = Double(viewModel.amount) ?? 0

        paymentMethodsCard.configure(
            title: viewModel.paymentMethodTitle,
            editText: viewModel.editLabel,
            presenterType: .billing)
        setAccessibilityForVoiceOver()
    }

    func animateViewDismissal() {
        guard !paymentMethodsCard.shownPaymentCards.isEmpty else { return }
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.confirmPayButton.alpha = 0
                self.subTitle.alpha = 0
            },
            completion: { _ in
                if !(self.paymentMethodsCard.selectedViewId?.isEmpty ?? true) {
                    self.delegate?.initialPayBillFinished(selectedViewId: self.paymentMethodsCard.selectedViewId)
                } else {
                    self.delegate?.initialPayBillFinished(
                        with: self.paymentMethodsCard.shownPaymentCards.first)
                }
            }
        )
    }

    func setAccessibilityForVoiceOver() {
        subTitle.accessibilityLabel = subTitle.text ?? ""
        amountLabel.accessibilityLabel = amountLabel.text ?? ""
        confirmPayButton.accessibilityLabel = confirmPayButton.titleLabel?.text ?? ""
        cancelButton.accessibilityLabel = cancelButton.titleLabel?.text ?? ""
        accessibilityCustomActions = [payBillButtonVoiceOverAction(), cancelButtonVoiceOverAction()]
    }

    // MARK: - Actions
    @IBAction func payBillAction(_ sender: Any) {
        payBillButtonPressed()
    }
    @objc func payBillButtonPressed() {
        VFGDebugLog("pay bill clicked")
        animateViewDismissal()
    }
    func payBillButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = confirmPayButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(payBillButtonPressed))
    }

    @IBAction func cancel(_ sender: Any) {
        cancelButtonPressed()
    }
    @objc func cancelButtonPressed() {
        delegate?.dismiss()
    }
    func cancelButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = cancelButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(cancelButtonPressed))
    }
}

extension VFGPayBillView: VFGPaymentMethodsCardViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHeightChanged height: CGFloat) {
        layoutIfNeeded()
    }

    func fetchPaymentDidFinish(with cardsCount: Int) {
        if cardsCount > 0 {
            confirmPayButton.isEnabled = true
        } else {
            confirmPayButton.isEnabled = false
        }
    }
}
