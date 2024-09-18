//
//  ProductSwitcherNoResultCell.swift
//  VFGMVA10Framework
//
//  Created by Loodos on 11/4/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class ProductSwitcherNoResultCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: VFGLabel!
    @IBOutlet private weak var subtitleLabel: VFGLabel!

    private lazy var suggestedQueryTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleSuggestedQueryTap(_:)))
        return gesture
    }()
    private weak var delegate: ProductSwitcherSearchViewDelegate?
    private var suggestedQuery: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "product_selector_search_no_result_title".localized(bundle: .main)
        subtitleLabel.text = "product_selector_search_no_result_subtitle".localized(bundle: .main)
        subtitleLabel.addGestureRecognizer(suggestedQueryTapGesture)
    }

    func suggestQuery(_ query: String, delegate: ProductSwitcherSearchViewDelegate? = nil) {
        suggestedQuery = query
        self.delegate = delegate
        if suggestedQuery.isEmpty {
            subtitleLabel.text = "product_selector_search_no_result_subtitle".localized(bundle: .main)
            return
        }

        let font = UIFont.vodafoneBold(14)
        let attributedQueryText = NSMutableAttributedString(
            string: suggestedQuery,
            attributes: [
                .font: font,
                .foregroundColor: UIColor.VFGLinkText,
                .underlineStyle: NSUnderlineStyle.thick.rawValue
            ]
        )
        let resultString = "product_selector_search_no_result_subtitle_suggestion".localized(bundle: .main) + " "
        let formattedString = String(format: resultString, "")
        let attributedResultText = NSMutableAttributedString(string: formattedString)
        attributedResultText.append(attributedQueryText)
        subtitleLabel.attributedText = attributedResultText
    }

    // MARK: User Actions

    @objc func handleSuggestedQueryTap(_ gesture: UITapGestureRecognizer) {
        if suggestedQuery.isEmpty {
            return
        }
        delegate?.searchTextChanged(text: suggestedQuery, isRecommendedSearch: true)
    }
}
