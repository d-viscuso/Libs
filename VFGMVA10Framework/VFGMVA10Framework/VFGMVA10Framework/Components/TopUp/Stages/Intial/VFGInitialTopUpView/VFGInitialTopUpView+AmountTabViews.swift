//
//  VFGInitialTopUpView+AmountTabViews.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 13/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGInitialTopUpView {
    func setupTabs() {
        if !withCustomAmount {
            tabsStackView.isHidden = true
            return
        }
        tabsStackViewTopConstraint.constant = tabsStackViewTopConstraintConstant
        let selectedButtonTab = tabsStackView.arrangedSubviews[selectedAmountEntryType.rawValue] as? VFGButton
        selectedButtonTab?.backgroundColor = .VFGFilterSelectedBg
        selectedButtonTab?.setTitleColor(.VFGFilterSelectedText, for: .normal)
        for case let button as VFGButton in tabsStackView.arrangedSubviews {
            button.setTitle(viewModel?.tabTitles[button.tag], for: .normal)
            button.addTarget(self, action: #selector(tabButtonDidPress(sender:)), for: .touchUpInside)
            if button.tag != selectedButtonTab?.tag {
                button.backgroundColor = .VFGFilterUnselectedBgTwo
                button.setTitleColor(.VFGFilterUnselectedText, for: .normal)
            }
            handleTabCorners(of: button)
        }
    }

    func handleTabCorners(of button: VFGButton) {
        if button.tag == 0 {
            if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                button.roundRightCorners(cornerRadius: 8)
                button.roundLeftCorners(cornerRadius: 0)
            } else {
                button.roundLeftCorners(cornerRadius: 8)
                button.roundRightCorners(cornerRadius: 0)
            }
        }
        if button.tag == tabsStackView.arrangedSubviews.count - 1 {
            if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                button.roundLeftCorners(cornerRadius: 8)
                button.roundRightCorners(cornerRadius: 0)
            } else {
                button.roundRightCorners(cornerRadius: 8)
                button.roundLeftCorners(cornerRadius: 0)
            }
        }
    }

    func selectTabButton(at index: Int) {
        guard index != selectedAmountEntryType.rawValue else { return }

        // Remove some properties from last selected tab
        let lastSelectedTabIndex = selectedAmountEntryType.rawValue
        let lastSelectedTabButton = tabsStackView.arrangedSubviews[lastSelectedTabIndex] as? VFGButton
        lastSelectedTabButton?.backgroundColor = .VFGFilterUnselectedBgTwo
        lastSelectedTabButton?.setTitleColor(.VFGFilterUnselectedText, for: .normal)
        toggleTabView(at: lastSelectedTabIndex)

        // Add some properties to new selected tab
        let selectedTabButton = tabsStackView.arrangedSubviews[index] as? VFGButton
        selectedTabButton?.backgroundColor = .VFGFilterSelectedBg
        selectedTabButton?.setTitleColor(.VFGFilterSelectedText, for: .normal)
        selectedAmountEntryType = VFGAmountEntryType(rawValue: index) ?? .quickTopup
        toggleTabView(at: selectedAmountEntryType.rawValue)
        handleTopupNowButtonEnableState()
    }

    func toggleTabView(at index: Int) {
        let currentView = amountEntryStackView.arrangedSubviews[index]
        currentView.isHidden.toggle()
    }
}
