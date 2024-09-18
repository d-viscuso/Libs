//
//  VFGAddDataView.swift
//  VFGMVA10Framework
//
//  Created by Salma Ashour on 1/14/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import Lottie

class  VFGAddDataView: UIView {
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var addDataTitleLabel: VFGLabel!
    @IBOutlet weak var addDataDescriptionLabel: VFGLabel!
    @IBOutlet weak var addDataButton: VFGButton!
    @IBOutlet weak var purchaseButton: VFGButton!
    @IBOutlet weak var backButton: VFGButton!
    @IBOutlet weak var paymentSummaryStackView: UIStackView!
    @IBOutlet weak var dataStackView: UIStackView!
    @IBOutlet weak var paymentSummaryTitleLabel: VFGLabel!
    @IBOutlet weak var paymentSummaryTopUpLabel: VFGLabel!
    @IBOutlet weak var paymentSummaryDataLabel: VFGLabel!
    @IBOutlet weak var paymentSummaryTotalLabel: VFGLabel!
    @IBOutlet weak var topUpPriceLabel: VFGLabel!
    @IBOutlet weak var dataPriceLabel: VFGLabel!
    @IBOutlet weak var totalPriceLabel: VFGLabel!

    weak var topUpDelegate: VFGTopUpProtocol?
    weak var delegate: VFGAddDataProtocol?
    var selectedAmount = 0

    let addDataButtonAddText = "top_up_quick_action_add_data_button_text".localized(bundle: .mva10Framework)
    let addDataButtonRemoveText = "top_up_quick_action_remove_data_button_text".localized(bundle: .mva10Framework)

    var currency: String {
        topUpDelegate?.model?.currency ?? ""
    }
    var balance: String {
        String(topUpDelegate?.model?.balance ?? 0)
    }
    var dataOfferAmount: String {
        String(Int(topUpDelegate?.model?.dataOfferAmount ?? 0))
    }
    var dataUnit: String {
        String(topUpDelegate?.model?.dataUnit ?? "")
    }
    var offerPrice: String {
        String(Int(topUpDelegate?.model?.offerAmount ?? 0))
    }
    var offerOriginalPrice: String {
        String(topUpDelegate?.model?.offerPrice ?? 0)
    }
    var selectedAmountAndOfferPrice: String {
        String(Int(selectedAmount) + (Int(topUpDelegate?.model?.offerAmount ?? 0)))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        dataStackView.isHidden = true
    }

    func configure(with topUpDelegate: VFGTopUpProtocol?, selectedAmount: Int) {
        self.topUpDelegate = topUpDelegate
        self.selectedAmount = selectedAmount

        configureAnimation()
        configureLabels()
        configureLocalizationContent()
        animateViewAppearance()
    }

    private func configureAnimation() {
        animationView.animation = Animation.named("Top-up_Reward", bundle: .mva10Framework)
        animationView.play(toProgress: 0)
    }

    private func configureLabels() {
        addDataTitleLabel.numberOfLines = 2
        addDataDescriptionLabel.numberOfLines = 3

        topUpPriceLabel.text = String(selectedAmount) + currency
        dataPriceLabel.text = offerPrice + currency
        totalPriceLabel.text = String(selectedAmount) + currency
    }

    private func configureLocalizationContent() {
        let attributedOfferDescription = String(
            format: "top_up_quick_action_accepting_offer_subtitle".localized(bundle: .mva10Framework),
            offerOriginalPrice,
            currency,
            topUpDelegate?.model?.offerEndDate?.localized(bundle: .mva10Framework) ?? "")
            .boldify(subText: offerOriginalPrice + currency, size: 16)

        addDataTitleLabel.text = String(
            format: "top_up_quick_action_offer_title".localized(bundle: .mva10Framework),
            dataOfferAmount,
            dataUnit,
            offerPrice,
            currency)
        addDataDescriptionLabel.attributedText = attributedOfferDescription
        paymentSummaryTitleLabel.text = "top_up_quick_action_offer_summary_title".localized(bundle: .mva10Framework)
        paymentSummaryTopUpLabel.text = "top_up_quick_action_offer_summary_top_up_title"
            .localized(bundle: .mva10Framework)
        paymentSummaryDataLabel.text = String(
            format: "top_up_quick_action_offer_summary_data_title".localized(bundle: .mva10Framework),
            dataOfferAmount,
            dataUnit)
        paymentSummaryTotalLabel.text = "top_up_quick_action_offer_summary_total_title"
            .localized(bundle: .mva10Framework)

        purchaseButton.setTitle("add_data_buy_offer_button_text".localized(bundle: .mva10Framework), for: .normal)
        backButton.setTitle("top_up_quick_action_back_button_text".localized(bundle: .mva10Framework), for: .normal)
        addDataButton.setTitle(addDataButtonAddText, for: .normal)
        addDataButton.accessibilityIdentifier = "TPAddRemoveDataButton"
    }

    // MARK: - Animation
    func animateViewAppearance() {
        purchaseButton.alpha = 0
        backButton.alpha = 0

        let animationViewNewXOffset = frame.width - animationView.frame.minX
        animationView.transform = CGAffineTransform(translationX: animationViewNewXOffset, y: 0)
        addDataTitleLabel.transform = CGAffineTransform(translationX: animationViewNewXOffset, y: 0)
        addDataDescriptionLabel.transform = CGAffineTransform(translationX: animationViewNewXOffset, y: 0)
        addDataButton.transform = CGAffineTransform(translationX: animationViewNewXOffset, y: 0)
        paymentSummaryStackView.transform = CGAffineTransform(translationX: animationViewNewXOffset, y: 0)

        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.purchaseButton.alpha = 1
                self.backButton.alpha = 1
                self.animationView.transform = .identity
                self.addDataTitleLabel.transform = .identity
                self.addDataDescriptionLabel.transform = .identity
                self.addDataButton.transform = .identity
                self.paymentSummaryStackView.transform = .identity
            },
            completion: { _ in
                self.animationView.play()
            }
        )
    }

    func animateViewDismissal(isBackward: Bool = false, completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.purchaseButton.alpha = 0
                self.backButton.alpha = 0

                let animationViewNewXOffset = isBackward ? self.frame.width : -self.frame.width
                self.animationView.transform = CGAffineTransform(translationX: animationViewNewXOffset, y: 0)
                self.addDataTitleLabel.transform = CGAffineTransform(translationX: animationViewNewXOffset, y: 0)
                self.addDataDescriptionLabel.transform = CGAffineTransform(translationX: animationViewNewXOffset, y: 0)
                self.addDataButton.transform = CGAffineTransform(translationX: animationViewNewXOffset, y: 0)
                self.paymentSummaryStackView.transform = CGAffineTransform(translationX: animationViewNewXOffset, y: 0)
            },
            completion: { _ in
                if isBackward {
                    self.delegate?.backButtonDidPress()
                } else if !self.dataStackView.isHidden {
                    self.delegate?.acceptDataButtonDidPress()
                } else {
                    self.delegate?.declineDataButtonDidPress()
                }
                completion?()
            }
        )
    }

    // MARK: - Actions
    @IBAction func purchaseButtonDidPress(_ sender: Any) {
        animateViewDismissal()
    }

    @IBAction func backButtonDidPress(_ sender: Any) {
        animateViewDismissal(isBackward: true)
    }

    @IBAction func addDataButtonDidPress(_ sender: Any) {
        dataStackView.isHidden.toggle()
        addDataButton.setTitle(dataStackView.isHidden ? addDataButtonAddText : addDataButtonRemoveText, for: .normal)
        addDataButton.buttonStyle = dataStackView.isHidden ? 0 : 2
        let totalPrice = (dataStackView.isHidden ? String(selectedAmount) : selectedAmountAndOfferPrice)
        totalPriceLabel.text = totalPrice + currency
    }
}
