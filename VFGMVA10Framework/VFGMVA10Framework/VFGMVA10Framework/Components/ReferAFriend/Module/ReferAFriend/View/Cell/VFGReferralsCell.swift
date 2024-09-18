//
//  VFGReferralsCell.swift
//  VFGReferAFriend
//
//  Created by Mustafa Güneş on 25.01.2021.
//

import UIKit
import VFGMVA10Foundation

class VFGReferralsCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak public var titleLabel: VFGLabel!
    @IBOutlet weak public var dateLabel: VFGLabel!
    @IBOutlet weak private var dividerView: UIView!

    public func setCell(with model: ReferralList?, isHideDivider: Bool = false) {
        guard let model = model else { return }

        titleLabel.text = model.referralName
        if let joinDate = model.joinDate {
            let localizedDateText = "refer_a_friend_joined_on".localized(bundle: .mva10Framework)
            dateLabel.text = String(format: localizedDateText, joinDate)
        } else {
            dateLabel.text = nil
        }
        dividerView.isHidden = isHideDivider
        titleLabel.accessibilityLabel = titleLabel.text
        dividerView.isAccessibilityElement = false
        dateLabel.accessibilityLabel = dateLabel.text
    }
}
