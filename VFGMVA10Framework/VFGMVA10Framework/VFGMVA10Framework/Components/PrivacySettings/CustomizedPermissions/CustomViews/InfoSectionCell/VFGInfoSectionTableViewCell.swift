//
//  VFGInfoSectionTableViewCell.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 13/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

protocol VFGInfoSectionTableViewCellProtocol: AnyObject {
    func learnMoreButtonDidPressed(indexPath: IndexPath?)
}

class VFGInfoSectionTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var learnMoreButton: VFGButton!
    @IBOutlet weak var infoSectionTopConstraint: NSLayoutConstraint!
    private var initialInfoSectionTopMargin: CGFloat = 33

    var model: InfoSection?
    var indexPath: IndexPath?
    weak var delegate: VFGInfoSectionTableViewCellProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        enableAccessibility()
    }

    func setup(with model: InfoSection, indexPath: IndexPath, delegate: VFGInfoSectionTableViewCellProtocol? = nil) {
        self.model = model
        self.delegate = delegate
        self.indexPath = indexPath
        descriptionText.isScrollEnabled = false
        descriptionText.isUserInteractionEnabled = false
        titleLabel.text = model.title
        infoSectionTopConstraint.constant = initialInfoSectionTopMargin
        setupTextView()
        setupShowMoreLessButton()
    }

    private func enableAccessibility() {
        titleLabel.isAccessibilityElement = true
        descriptionText.isAccessibilityElement = true
        learnMoreButton.isAccessibilityElement = true
    }

    @IBAction func learnMoreDidPress(_ sender: Any) {
        let isEXpanded = model?.isExpanded ?? false
        model?.isExpanded = !isEXpanded

        setupTextView()
        setupShowMoreLessButton()
        layoutSubviews()
        delegate?.learnMoreButtonDidPressed(indexPath: indexPath)
    }

    private func setupTextView() {
        let text = (model?.isExpanded ?? false) ? model?.fullHTMLDesc : model?.briefHTMLDesc
        descriptionText.attributedText = attributedTextFrom(
            htmlText: text ?? "",
            fontSize: 16.6,
            color: .VFGPrimaryText)
    }

    private func setupShowMoreLessButton() {
        learnMoreButton.isHidden = (model?.fullHTMLDesc ?? "").isEmpty
        if !learnMoreButton.isHidden {
            let title = (model?.isExpanded ?? false) ?
            "privacy_permissions_show_less".localized(bundle: .mva10Framework) :
            "privacy_permissions_learn_more".localized(bundle: .mva10Framework)
            learnMoreButton.setTitle(title, for: .normal)
        }
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
            VFGErrorLog("Error getting attributed text from html: \(error)")
            return nil
        }
    }
}
