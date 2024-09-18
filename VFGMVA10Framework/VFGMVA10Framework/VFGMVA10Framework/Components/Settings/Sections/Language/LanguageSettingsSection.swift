//
//  LanguageSettingsSection.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 31/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//
/// Construct language settings section
public class LanguageSettingsSection: BaseSection {
    private let defaultHeaderHeight: CGFloat = 86

    public override func heightForHeader() -> CGFloat {
        customHeaderHeight ?? defaultHeaderHeight
    }

    public override func headerView(for tableView: UITableView) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "SettingsHeader")
        guard let settingsHeader = header as? SettingsHeaderCell else {
            return header
        }
        settingsHeader.setup(title: title, subTitle: subtitle)
        settingsHeader.title.accessibilityIdentifier = "SHatsection\(3)"
        settingsHeader.imageViewTopConstraint.constant = 11
        return settingsHeader
    }
}
