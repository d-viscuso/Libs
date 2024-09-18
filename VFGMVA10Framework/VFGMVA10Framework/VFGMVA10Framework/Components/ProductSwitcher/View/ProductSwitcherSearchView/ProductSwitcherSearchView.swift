//
//  ProductSwitcherSearchView.swift
//  VFGMVA10Framework
//
//  Created by Loodos on 11/3/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
import UIKit

/// ProductSwitcherSearchViewDelegate
protocol ProductSwitcherSearchViewDelegate: AnyObject {
    func searchTextChanged(text: String, isRecommendedSearch: Bool)
}

class ProductSwitcherSearchView: UIView {
    @IBOutlet weak var searchHolderView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet private weak var crossButton: VFGButton!
    @IBOutlet private weak var resultLabel: VFGLabel!

    weak var delegate: ProductSwitcherSearchViewDelegate?
    var lastSearchedText = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        setupSearchTextField()
        updateSearchView(isSelected: false)
        addObserverWhenDashboardWillDisappear()
    }

    func showResult(query: String, resultCount: Int) {
        resultLabel.text = ""
        if query.isEmpty || resultCount == 0 {
            return
        }

        let font = UIFont.vodafoneBold(14)
        let attributedQueryText = NSAttributedString(
            string: query,
            attributes: [.font: font]
        )
        let resultString = "product_selector_search_result".localized(bundle: .main)
        let formattedResultString = String(format: resultString, "\(resultCount)", "") + " "
        let attributedResultText = NSMutableAttributedString(string: formattedResultString)
        attributedResultText.append(attributedQueryText)
        resultLabel.attributedText = attributedResultText
    }

    private func setupSearchTextField() {
        let placeholder = "product_selector_search_hint".localized(bundle: .mva10Framework)
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.VFGGreyBorder]
        )
        searchTextField.delegate = self
    }

    private func updateSearchView(isSelected: Bool) {
        if isSelected {
            searchHolderView.layer.borderWidth = 2
            searchHolderView.layer.borderColor = UIColor.VFGTextViewBorderActiveColorTwo.cgColor
            crossButton.isHidden = false
        } else {
            searchHolderView.layer.borderWidth = 1
            searchHolderView.layer.borderColor = UIColor.darkGrayBackground?.cgColor
            crossButton.isHidden = true
        }
    }

    private func addObserverWhenDashboardWillDisappear() {
        NotificationCenter.default
            .addObserver(self, selector: #selector(clearTextField), name: .DashboardWillDisappear, object: nil)
    }

    @objc private func clearTextField() {
        guard !(searchTextField.text?.isEmpty ?? true)  else {return}
            searchTextField.text = ""
            resultLabel.text = ""
            searchTextField.resignFirstResponder()
            delegate?.searchTextChanged(text: "", isRecommendedSearch: false)
    }

    @IBAction func crossButtonClicked(_ sender: Any) {
        clearTextField()
    }
}


extension ProductSwitcherSearchView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
            let textRange = Range(range, in: text)
        else { return true }

        var updatedText = text.replacingCharacters(in: textRange, with: string)
        if updatedText.isEmpty {
            searchTextField.text = ""
        }
        updatedText = updatedText.trimmingCharacters(in: .whitespacesAndNewlines)
        if updatedText != lastSearchedText {
            delegate?.searchTextChanged(text: updatedText, isRecommendedSearch: false)
            lastSearchedText = updatedText
        }

        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        updateSearchView(isSelected: true)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        updateSearchView(isSelected: false)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
