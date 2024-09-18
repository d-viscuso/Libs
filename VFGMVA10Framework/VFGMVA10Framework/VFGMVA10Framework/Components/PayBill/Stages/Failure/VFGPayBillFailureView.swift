//
//  VFGPayBillFailureView.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 12/1/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGPayBillFailureView: UIView {
    @IBOutlet weak var warningImageView: VFGImageView!
    @IBOutlet weak var tryAgainButton: VFGButton!
    @IBOutlet weak var failureMainTitle: VFGLabel!
    @IBOutlet weak var failureSubTitle: VFGLabel!
    @IBOutlet weak var cancelButton: VFGButton!
    var card: PaymentModelProtocol?
    var billAmount: Double?

    weak var delegate: VFGPayBillStateInternalProtocol?

    func configure(with viewModel: VFGPayBillFailureViewModel) {
        failureMainTitle.text = viewModel.sectionTitle
        failureSubTitle.text = viewModel.subTitle
        tryAgainButton.setTitle(viewModel.buttonTitle, for: .normal)
        cancelButton.setTitle(viewModel.cancelButtonTitle, for: .normal)
        setAccessibilityForVoiceOver()
    }

    func setAccessibilityForVoiceOver() {
        failureMainTitle.accessibilityLabel = failureMainTitle.text ?? ""
        failureSubTitle.accessibilityLabel = failureSubTitle.text ?? ""
        tryAgainButton.accessibilityLabel = tryAgainButton.titleLabel?.text ?? ""
        cancelButton.accessibilityLabel = cancelButton.titleLabel?.text ?? ""
        warningImageView.accessibilityLabel = "Failure warning view"
        accessibilityCustomActions = [tryAgainButtonVoiceOverAction(), cancelButtonVoiceOverAction()]
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                cancelButton.backgroundStyle = 0
            }
        }
    }

    @IBAction func cancelButtonDidPress(_ sender: VFGButton) {
        cancelButtonPressed()
    }
    @objc func cancelButtonPressed() {
        delegate?.finishPayBill()
    }
    func cancelButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = cancelButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(cancelButtonPressed))
    }
    @IBAction func tryAgainButtonDidPress(_ sender: Any) {
        tryAgainButtonPressed()
    }
    @objc func tryAgainButtonPressed() {
        delegate?.tryAgain()
    }
    func tryAgainButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = tryAgainButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(tryAgainButtonPressed))
    }
}
