//
//  DashboardSettingsSection.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 15/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Construct dashboard settings section
public class DashboardSettingsSection: BaseSection {
    private let defaultHeaderHeight: CGFloat = 76

    public override func heightForHeader() -> CGFloat {
        customHeaderHeight ?? defaultHeaderHeight
    }

    public override func headerView(for tableView: UITableView) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "SettingsHeader")
        guard let settingsHeader = header as? SettingsHeaderCell else {
            return header
        }
        settingsHeader.setup(title: title, subTitle: subtitle, headerImageView: VFGImage(named: type.image))
        settingsHeader.title.accessibilityIdentifier = "SHatsection\(1)"
        settingsHeader.headerImageView.isHidden = (type == .plainText)
        settingsHeader.imageViewHeightConstraint.constant = type.imageHeight
        settingsHeader.imageViewTopConstraint.constant = type.imageTopConstraint
        settingsHeader.imageViewBottomConstraint.constant = type.imageBottomConstraint
        return settingsHeader
    }
}
