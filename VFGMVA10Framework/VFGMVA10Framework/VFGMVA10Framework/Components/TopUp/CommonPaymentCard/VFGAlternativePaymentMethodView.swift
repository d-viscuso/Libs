//
//  VFGAlternativePaymentMethodView.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Zaki on 24/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

protocol AlternativePaymentMethodDelegate: AnyObject {
    func radioButtonDidSelect(view: VFGAlternativePaymentMethodView)
}

class VFGAlternativePaymentMethodView: UIView {
    @IBOutlet weak var radioButton: VFGRadioButton!
    @IBOutlet weak var alternativePaymentMethodCardView: UIView!
    @IBOutlet weak var title: VFGLabel!
    var cardId: String?
    weak var delegate: AlternativePaymentMethodDelegate?
    let nibName = "VFGAlternativePaymentMethodView"

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setVoiceOverAccessibility()
    }

    func xibSetup() {
        guard let view = loadViewFromNib(nibName: nibName) else {
            VFGErrorLog("VFGPaymentMethodsCardView is nil")
            return
        }
        xibSetup(contentView: view)
    }

    @IBAction func radioButton(_ sender: Any) {
        radioButtonDidPressed()
    }
    @objc func radioButtonDidPressed() {
        delegate?.radioButtonDidSelect(view: self)
    }
}

// MARK: - setVoiceOverAccessibility
extension VFGAlternativePaymentMethodView {
    private func setVoiceOverAccessibility() {
        title.accessibilityLabel = title.text
        radioButton.accessibilityLabel = "Radio button"
        accessibilityCustomActions = [saveCardVoiceOverAction()]
    }

    func saveCardVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "radio button"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(radioButtonDidPressed))
    }
}
