//
//  AddonsTimelineCell.swift
//  VFGMVA10Framework
//
//  Created by Salma Ashour on 7/1/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

enum TimelineCellType {
    case currentPlan
    case halfDayActiveAddon
    case oneDayActiveAddon
    case daysActiveAddon
    case renewAddon
}

class AddOnsTimelineCell: UICollectionViewCell {
    var imageContainerWidth: CGFloat = 42
    var imageContainerWidthForOneDayCell: CGFloat = 75
    @IBOutlet var currentPlanView: UIView!
    @IBOutlet var addOnDetailsView: UIView!
    @IBOutlet var addOnImageView: VFGImageView!
    @IBOutlet var addOnTitleLabel: VFGLabel!
    @IBOutlet var addOnValueLabel: VFGLabel!
    @IBOutlet var addOnImageContainerView: UIView!
    @IBOutlet weak var imageContainerWidthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureShadow()
        addOnDetailsView.roundCorners()
        currentPlanView.roundUpperCorners(cornerRadius: 6.2)
    }

    func configure(
        _ product: AddOnsProductModel,
        _ addonPeriod: Int,
        _ isDailyView: Bool
    ) {
        addOnTitleLabel.text = product.title
        addOnValueLabel.text = product.addOnDetails?.price
        addOnImageView.image = UIImage(named: product.imageName, in: Bundle.mva10Framework)

        var isHalfAddon = false
        var isDayAddon = false

        let compareValue = isDailyView ? 1 : 7
        if product.addonType == AddOnsTypeLocalize.myPlan.localizedString &&
            !product.expiredAndRenewedProduct && !product.toBeRenewedProduct {
            showCurrentPlan()
        } else if product.addonType == AddOnsTypeLocalize.myPlan.localizedString && product.expiredAndRenewedProduct {
            addOnImageView.image = VFGFrameworkAsset.Image.icCurrentPlan
        } else if addonPeriod > compareValue {
            showDaysAddon()
        } else if addonPeriod < compareValue {
            showHalfDayAddon()
            isHalfAddon = true
            if  Date() > getDateFromString(product.addOnDetails?.startDate ?? "") ?? Date() &&
                Date() < getDateFromString(product.addOnDetails?.expirationDate ?? "") ?? Date() {
                showDaysAddon()
                isHalfAddon = false
            }
        } else {
            showOneDayAddon()
            isDayAddon = true
        }
        if product.toBeRenewedProduct {
            showRenewAddon(isHalfAddon: isHalfAddon, isDayAddon: isDayAddon)
        }
        if product.expiredAndRenewedProduct || product.expiredProduct {
            showExpiredAddon(isHalfAddon: isHalfAddon, isDayAddon: isDayAddon)
        }
        setupAccessibilityLabels()
    }

    func showCurrentPlan() {
        currentPlanView.isHidden = false
        imageContainerWidthConstraint.constant = imageContainerWidth
        addOnDetailsView.backgroundColor = .VFGWhiteBackground
        addOnImageContainerView.backgroundColor = .VFGWhiteBackground
        addOnDetailsView.layer.borderWidth = 0
        addOnImageContainerView.layer.borderWidth = 0
        addOnImageView.image = VFGFrameworkAsset.Image.icCurrentPlan
        addOnTitleLabel.alpha = 1.0
        addOnDetailsView.alpha = 1.0
        addOnValueLabel.alpha = 1.0
    }
    func showDaysAddon() {
        currentPlanView.isHidden = true
        imageContainerWidthConstraint.constant = imageContainerWidth
        addOnDetailsView.backgroundColor = .VFGWhiteBackground
        addOnImageContainerView.backgroundColor = .VFGWhiteBackground
        addOnDetailsView.layer.borderWidth = 0
        addOnImageContainerView.layer.borderWidth = 0
        addOnTitleLabel.alpha = 1.0
        addOnDetailsView.alpha = 1.0
        addOnValueLabel.alpha = 1.0
    }
    func showHalfDayAddon() {
        currentPlanView.isHidden = true
        imageContainerWidthConstraint.constant = imageContainerWidth
        addOnDetailsView.backgroundColor = .clear
        addOnImageContainerView.backgroundColor = .VFGWhiteBackground
        addOnDetailsView.layer.borderWidth = 0
        addOnImageContainerView.layer.borderWidth = 0
        addOnTitleLabel.alpha = 1.0
        addOnDetailsView.alpha = 1.0
        addOnValueLabel.alpha = 1.0
    }
    func showOneDayAddon() {
        currentPlanView.isHidden = true
        imageContainerWidthConstraint.constant = imageContainerWidthForOneDayCell
        addOnDetailsView.backgroundColor = .clear
        addOnImageContainerView.backgroundColor = .VFGWhiteBackground
        addOnDetailsView.layer.borderWidth = 0
        addOnImageContainerView.layer.borderWidth = 0
        addOnTitleLabel.alpha = 1.0
        addOnDetailsView.alpha = 1.0
        addOnValueLabel.alpha = 1.0
    }

    func showRenewAddon(isHalfAddon: Bool = false, isDayAddon: Bool = false) {
        if isHalfAddon {
            imageContainerWidthConstraint.constant = imageContainerWidth
            addOnDetailsView.layer.borderWidth = 0
            addOnImageContainerView.layer.borderWidth = 1
            addOnImageContainerView.layer.borderColor = UIColor.VFGTimelineCellBorder.cgColor
        } else if isDayAddon {
            imageContainerWidthConstraint.constant = imageContainerWidthForOneDayCell
            addOnDetailsView.layer.borderWidth = 0
            addOnImageContainerView.layer.borderWidth = 1
            addOnImageContainerView.layer.borderColor = UIColor.VFGTimelineCellBorder.cgColor
        } else {
            imageContainerWidthConstraint.constant = imageContainerWidth
            addOnDetailsView.layer.borderWidth = 1
            addOnImageContainerView.layer.borderWidth = 0
            addOnDetailsView.layer.borderColor = UIColor.VFGTimelineCellBorder.cgColor
        }
        addOnImageContainerView.backgroundColor = .clear
        addOnImageView.image = VFGFrameworkAsset.Image.icRenew
        addOnDetailsView.backgroundColor = .clear
        currentPlanView.isHidden = true
        addOnTitleLabel.alpha = 1.0
        addOnDetailsView.alpha = 1.0
        addOnValueLabel.alpha = 1.0
    }

    func showExpiredAddon(isHalfAddon: Bool = false, isDayAddon: Bool = false) {
        if isHalfAddon {
            imageContainerWidthConstraint.constant = imageContainerWidth
            addOnDetailsView.backgroundColor = .clear
            addOnImageContainerView.backgroundColor = .VFGTimelineSeparator
        } else if isDayAddon {
            imageContainerWidthConstraint.constant = imageContainerWidthForOneDayCell
            addOnDetailsView.backgroundColor = .clear
            addOnImageContainerView.backgroundColor = .VFGTimelineSeparator
        } else {
            imageContainerWidthConstraint.constant = imageContainerWidth
            addOnDetailsView.backgroundColor = .VFGTimelineSeparator
            addOnImageContainerView.backgroundColor = .clear
        }
        currentPlanView.isHidden = true
        addOnDetailsView.layer.borderWidth = 0
        addOnImageContainerView.layer.borderWidth = 0
        addOnTitleLabel.alpha = 0.5
        addOnDetailsView.alpha = 0.5
        addOnValueLabel.alpha = 0.5
    }

    func getDateFromString(_ string: String) -> Date? {
        VFGDateHelper.getDateFromString(
            dateString: string,
            format: "yyyy-MM-dd HH:mm:ss",
            locale: Locale(identifier: "en_US_POSIX"))
    }
}

extension AddOnsTimelineCell {
    func setupAccessibilityLabels() {
        addOnTitleLabel.accessibilityLabel = addOnTitleLabel.text ?? ""
        addOnValueLabel.accessibilityLabel = addOnValueLabel.text ?? ""
    }
}
