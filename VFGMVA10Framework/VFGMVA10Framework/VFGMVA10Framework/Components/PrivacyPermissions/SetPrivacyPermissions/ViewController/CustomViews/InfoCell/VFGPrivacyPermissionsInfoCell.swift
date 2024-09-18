//
//  VFGPrivacyPermissionsInfoCell.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 27/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

protocol VFGPrivacyPermissionsInfoCellProtocol: AnyObject {
    func learnMoreButtonDidPressed(indexPath: IndexPath?)
}

class VFGPrivacyPermissionsInfoCell: UITableViewCell {
    enum TitleSize: CGFloat {
        case large = 25.0
        case medium = 20.8
    }

    // MARK: Outlets
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var learnMoreButton: VFGButton!

    var titleSize: TitleSize = .medium
    var model: VFGPrivacyPermissionsInfoCellUIModel?
    var indexPath: IndexPath?
    weak var delegate: VFGPrivacyPermissionsInfoCellProtocol?

    // MARK: Actions
    @IBAction func learnMoreButtonDidPressed(_ sender: Any) {
        learnMoreButtonPressed()
    }
    @objc func learnMoreButtonPressed() {
        let isExpanded = model?.isExpanded ?? false
        model?.isExpanded = !isExpanded
        setupTextView()
        setupShowMoreLessButton()
        layoutSubviews()
        delegate?.learnMoreButtonDidPressed(indexPath: indexPath)
        setAccessibilityForVoiceOver()
    }
    func learnMoreButtonVoiceAction() -> UIAccessibilityCustomAction {
        let actionName = learnMoreButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(learnMoreButtonPressed))
    }

    // MARK: Setup
    func setup(with model: VFGPrivacyPermissionsInfoCellUIModel, indexPath: IndexPath, delegate: VFGPrivacyPermissionsInfoCellProtocol? = nil) {
        self.model = model
        self.delegate = delegate
        self.indexPath = indexPath
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isUserInteractionEnabled = false
        titleLabel.font = UIFont.vodafoneBold(titleSize.rawValue)
        titleLabel.text = model.infoSection.title
        setupTextView()
        setupShowMoreLessButton()
        setAccessibilityForVoiceOver()
    }

    func setAccessibilityForVoiceOver() {
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        descriptionTextView.accessibilityTraits = .none
        learnMoreButton.accessibilityLabel = learnMoreButton.titleLabel?.text ?? ""
        accessibilityElements = [
            titleLabel ?? "",
            descriptionTextView ?? "",
            learnMoreButton ?? ""
        ]
        accessibilityCustomActions = [learnMoreButtonVoiceAction()]
    }

    private func setupShowMoreLessButton() {
        learnMoreButton.isHidden = (model?.infoSection.fullHTMLDesc ?? "").isEmpty
        if !learnMoreButton.isHidden {
            let title = (model?.isExpanded ?? false) ?
            "privacy_permissions_show_less".localized(bundle: .mva10Framework) :
            "privacy_permissions_learn_more".localized(bundle: .mva10Framework)
            learnMoreButton.setTitle(title, for: .normal)
        }
    }

    private func setupTextView() {
        let text = (model?.isExpanded ?? false) ? model?.infoSection.fullHTMLDesc : model?.infoSection.briefHTMLDesc
        descriptionTextView.attributedText = attributedTextFrom(
            htmlText: text ?? "",
            fontSize: 16.6,
            color: .VFGPrimaryText)
    }

    private func attributedTextFrom(htmlText: String, fontSize: CGFloat, color: UIColor) -> NSMutableAttributedString? {
        let baseFont = UIFont.vodafoneRegular(fontSize)
        guard
            let fontName = baseFont.fontName as NSString?
        else {
            return nil
        }
        let modifiedFont = String(
            format: "<span style=\"font-family: '\(fontName)'; font-size: \(baseFont.pointSize)\">%@</span>", htmlText)

        do {
            guard let data = modifiedFont.data(using: .unicode, allowLossyConversion: true) else {
                return nil
            }
            let attributedText = try NSMutableAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            attributedText.addAttribute(textColor: color)
            return attributedText
        } catch {
            VFGDebugLog("Error getting attributed text from html: \(error)")
            return nil
        }
    }
}
