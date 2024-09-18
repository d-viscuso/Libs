//
//  AddOnsProductCell.swift
//  VFGMVA10Framework
//
//  Created by Hamsa Hassan on 5/11/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class AddOnsProductCell: UICollectionViewCell {
    @IBOutlet weak var title: VFGLabel!
    @IBOutlet weak var subtitle: VFGLabel!
    @IBOutlet weak var thumbnail: VFGImageView!
    @IBOutlet weak var activeAddOnIndicatorContainer: UIStackView!
    @IBOutlet weak var activeAddOnIndicatorLabel: VFGLabel!
    @IBOutlet weak var activeAddOnExpiryDateLabel: VFGLabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var recommendView: UIView!
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var recommendViewHeightConstraint: NSLayoutConstraint!
    private let recommendedViewHeight: CGFloat = 32

    override func awakeFromNib() {
        super.awakeFromNib()
        configureShadow()
        removeRecommendedView()
        containerView.backgroundColor = .lightBackground
        recommendLabel.text = "shop_addons_recommended_title".localized(bundle: .mva10Framework)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        removeRecommendedView()
    }

    func setUp(with product: AddOnsProductModel, isPromProduct: Bool) -> Self {
        setupCell(with: product)
        if isPromProduct {
            setupRecommendedView()
        }
        return self
    }

    func setupCell(with itemVM: AddOnsProductModel) {
        title.text = itemVM.title
        subtitle.text = itemVM.subTitle
        let shouldHideActiveIndicatorView = !(itemVM.addOnDetails?.shouldShowActiveIndicatorView ?? false)
        let isActive = (itemVM.addOnDetails?.isActive ?? false)
        activeAddOnIndicatorContainer.isHidden = shouldHideActiveIndicatorView || !isActive
        activeAddOnIndicatorLabel.text = "addons_active".localized(bundle: Bundle.mva10Framework)
        activeAddOnExpiryDateLabel.font = .vodafoneRegular(14)
        activeAddOnExpiryDateLabel.text = itemVM.addOnDetails?.activeDate
        if let imageName = itemVM.imageName {
            thumbnail.image = VFGImage(named: imageName)
        }
        setupAccessibilityLabels()
    }

    func setupRecommendedView() {
        recommendViewHeightConstraint.constant = recommendedViewHeight
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.VFGOceanText.cgColor
        containerView.roundCorners()
    }

    func removeRecommendedView() {
        recommendViewHeightConstraint.constant = 0
        containerView.layer.borderWidth = 0
        containerView.layer.borderColor = UIColor.clear.cgColor
    }
}

extension AddOnsProductCell {
    static var nibName = "AddOnsProductCell"

    static func makeResizingAddOnsProductCell(
        for product: AddOnsProductModel,
        isPromProduct: Bool
    ) -> AddOnsProductCell {
        let addOnsCellNib = UINib(nibName: nibName, bundle: Bundle.mva10Framework)
        guard let cell = addOnsCellNib.instantiate(withOwner: nil, options: nil).first as? AddOnsProductCell
        else {
            return AddOnsProductCell()
        }
        return cell.setUp(with: product, isPromProduct: isPromProduct)
    }
}

extension AddOnsProductCell {
    func setupAccessibilityLabels() {
        title.accessibilityLabel = title.text ?? ""
        subtitle.accessibilityLabel = subtitle.text ?? ""
        activeAddOnIndicatorLabel.accessibilityLabel = activeAddOnIndicatorLabel.text ?? ""
        activeAddOnExpiryDateLabel.accessibilityLabel = activeAddOnExpiryDateLabel.text ?? ""
    }
}
