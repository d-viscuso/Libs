//
//  VFGConfirmView.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 6/7/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

protocol VFGConfirmViewDelegate: AnyObject {
    func confirmButtonDidPress(_ confirmView: VFGConfirmView)
    func hyperLinkDidPress(_ confirmView: VFGConfirmView, url: String)
}

class VFGConfirmView: UIView {
    @IBOutlet weak var termsTextView: UITextView!
    @IBOutlet weak var confirmButton: VFGButton!

    weak var delegate: VFGConfirmViewDelegate?

    @IBAction func confirmButtonDidPress(_ sender: Any) {
        confirmButtonAction()
    }

    @objc func confirmButtonAction() {
        delegate?.confirmButtonDidPress(self)
    }

    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {
        guard let contentView = self.loadViewFromNib(nibName: className, in: .mva10Framework) else {
            return
        }

        xibSetup(contentView: contentView)
        configureUI()
        addAccessibilityForVoiceOver()
        setupAccessibilityIds()
    }

    func configureUI() {
        confirmButton.setTitle(
            "book_appointment_summary_cta_button_title".localized(bundle: .mva10Framework),
            for: .normal
        )

        configureTermsAndCondition()
    }

    func configureTermsAndCondition() {
        termsTextView.delegate = self
        termsTextView.textContainerInset = UIEdgeInsets.zero
        termsTextView.textContainer.lineFragmentPadding = 0

        let originalText = String(
            format: "book_appointment_summary_step_terms".localized(bundle: .mva10Framework),
            VFGTermsAndConditionsLinks.privacy.link,
            VFGTermsAndConditionsLinks.termsAndConditions.link
        )

        termsTextView.hyperLink(
            originalText: originalText,
            hyperLinks: termsAndConditionsLinks,
            linkColor: UIColor.VFGPrimaryText,
            alignment: .left,
            font: UIFont.vodafoneRegular(14),
            textColor: UIColor.VFGPrimaryText,
            direction: .backwards
        )
    }
}

extension VFGConfirmView: UITextViewDelegate {
    var termsAndConditionsLinks: [VFGHyperLink] {
        return [
            VFGTermsAndConditionsLinks.termsAndConditions,
            VFGTermsAndConditionsLinks.privacy
        ]
    }

    public func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        openURL(URL.absoluteString)
        return false
    }

    func openURL(_ url: String) {
        delegate?.hyperLinkDidPress(self, url: url)
    }
}
// MARK: Voice over
extension VFGConfirmView {
    /// add accessibility for voice over
    func addAccessibilityForVoiceOver() {
        accessibilityCustomActions = [confirmVoiceOverAction()]
    }

    /// add accessibility identifiers
    func setupAccessibilityIds() {
        termsTextView.accessibilityIdentifier = "CVtextView"
        confirmButton.accessibilityIdentifier = "CVconfirmButton"
    }

    /// action for confrm voice over
    /// - Returns: action for confrm button in voice over
    func confirmVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = confirmButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(confirmButtonAction))
    }
}


public enum VFGTermsAndConditionsLinks {
    static let termsAndConditions: VFGHyperLink = (
        "book_appointment_summary_step_terms_hyperlink_text".localized(bundle: .mva10Framework),
        "https://www.vodafone.co.uk/terms-and-conditions/")

    static let privacy: VFGHyperLink = (
        "book_appointment_summary_step_privacy_hyperlink_text".localized(bundle: .mva10Framework),
        "https://www.vodafone.co.uk/privacy")
}
