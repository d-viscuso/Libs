//
//  VFGTopUpOfferView.swift
//  VFGMVA10Framework
//
//  Created by Salma Ashour on 1/19/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGTopUpOfferView: UIView {
    @IBOutlet weak var offerTextLabel: VFGLabel!
    @IBOutlet weak var normalPriceLabel: VFGLabel!
    @IBOutlet weak var offerEndLabel: VFGLabel!
    @IBOutlet weak var topUpButton: VFGButton!
    @IBOutlet weak var noButton: VFGButton!
    weak var topUpDelegate: VFGTopUpProtocol?
    weak var delegate: VFGTopUpOfferProtocol?

    func configure(
        with topUpDelegate: VFGTopUpProtocol?,
        viewModel: VFGTopUpOfferViewModel
    ) {
        self.topUpDelegate = topUpDelegate
        offerTextLabel.text = viewModel.sectionTitle
        offerEndLabel.text = viewModel.subTitle
        topUpButton.setTitle(viewModel.buttonTitle, for: .normal)
        let offerButton = "top_up_quick_action_no_offer_button".localized(bundle: Bundle.mva10Framework)
        let noOfferButtonText = String(
            format: offerButton,
            arguments: [
                String(viewModel.selectedAmount),
                String(topUpDelegate?.model?.currency ?? "")
            ])
        noButton.setTitle(noOfferButtonText, for: .normal)
        let addDataPrice = "top_up_quick_action_add_data_normal_price".localized(bundle: Bundle.mva10Framework)
        let normalPriceText = String(
            format: addDataPrice,
            arguments: [
                String(viewModel.selectedAmount),
                String(topUpDelegate?.model?.currency ?? "")
            ])
        normalPriceLabel.text = normalPriceText
    }
    @IBAction func topUpButtonClicked(_ sender: Any) {
        delegate?.topUpClicked()
    }
    @IBAction func noButtonClicked(_ sender: Any) {
        delegate?.noOfferClicked()
    }
}
