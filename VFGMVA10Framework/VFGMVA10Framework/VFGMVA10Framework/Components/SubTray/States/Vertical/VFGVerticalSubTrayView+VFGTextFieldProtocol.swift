//
//  VFGVerticalSubTrayView+VFGTextFieldProtocol.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 08/11/2021.
//

import VFGMVA10Foundation

extension VFGVerticalSubTrayView: VFGTextFieldProtocol {
    public func vfgTextFieldDidBeginEditing(_ vfgTextField: VFGTextField) { }

    public func vfgTextFieldDidEndEditing(_ vfgTextField: VFGTextField) { }

    public func vfgTextFieldRightButtonClicked(_ vfgTextField: VFGTextField) {
        // Resets highlighted Index
        highlightedItemIndex = nil
        if isCategoriesEnabled {
            showTabsCollectionView()
        }
        resetSearchTextFieldUI()
        searchProducts(with: searchQurey, in: selectedCategory)
        vfgTextField.setTextFieldAsFirstResponder()
    }

    public func vfgTextFieldDidChange(_ vfgTextField: VFGTextField, text: String) {
        // Resets highlighted Index
        highlightedItemIndex = nil
        searchQurey = text
        if text.isEmpty {
            if isCategoriesEnabled {
                showTabsCollectionView()
            }
            searchTextField?.textFieldRightIcon = VFGFrameworkAsset.Image.icSearch
            searchProducts(with: searchQurey, in: selectedCategory)
        } else {
            hideTabsCollectionView()
            searchTextField?.textFieldRightIcon = UIImage.VFGClose.dynamic
            let category = isCategoriesEnabled ? .all : selectedCategory
            searchProducts(with: searchQurey, in: category)
        }
    }

    public func vfgTextFieldShouldReturn(_ vfgTextField: UITextField) -> Bool {
        vfgTextField.resignFirstResponder()
        return true
    }
}
