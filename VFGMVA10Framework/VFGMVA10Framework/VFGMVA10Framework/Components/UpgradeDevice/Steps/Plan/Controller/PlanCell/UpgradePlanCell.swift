//
//  UpgardePlanCell.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 5/21/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class UpgradePlanCell: UITableViewCell {
    // MARK: Recommended View
    @IBOutlet weak var recommendedView: UIView!
    @IBOutlet weak var recommendedViewBackground: UIView!
    @IBOutlet weak var recommendedLabel: VFGLabel!

    // MARK: Plan View
    @IBOutlet weak var planView: UIView!

    // MARK: Plan Header View
    @IBOutlet weak var planHeaderView: UIView!
    @IBOutlet weak var planImageView: VFGImageView!
    @IBOutlet weak var planNameLabel: VFGLabel!
    @IBOutlet weak var planRecurringPriceLabel: VFGLabel!
    @IBOutlet weak var chevronImageView: VFGImageView!
    @IBOutlet weak var planTopViewButton: VFGButton!

    // MARK: Plan Expanded View
    @IBOutlet weak var planExpandedView: UIView!

    // MARK: Plan DetailsView
    @IBOutlet weak var planDetailsView: UIView!
    @IBOutlet weak var planDetailsStackView: UIStackView!

    // MARK: Plan Subscriptions View
    @IBOutlet weak var planSubscriptionsView: UIView!
    @IBOutlet weak var planSubscriptionTitleLabel: VFGLabel!
    @IBOutlet weak var subscriptionsCollectionView: UICollectionView!

    // MARK: Choose Plan View
    @IBOutlet weak var choosePlanView: UIView!
    @IBOutlet weak var recommendedInfoView: UIView!
    @IBOutlet weak var choosePlanTitleLabel: VFGLabel!
    @IBOutlet weak var recommendedPlanInfoButton: VFGButton!
    @IBOutlet weak var choosePlanButton: VFGButton!

    private var model: VFGPlanCellUIModel?
    private var indexPath = IndexPath()
    private weak var delegate: UpgradePlanCellDelegate?

    func setup(model: VFGPlanCellUIModel, indexPath: IndexPath, delegate: UpgradePlanCellDelegate? = nil) {
        self.model = model
        self.indexPath = indexPath
        self.delegate = delegate
        setupPlanViewUIStyle()
        setupRecommendedView()
        setupPlanHeaderView()
        setupAccessibilityIdentifier(indexPath: indexPath)

        planExpandedView.isHidden = !model.isExpanded
        if !model.isExpanded { return }

        setupPlanDetailsView()
        setupSubscriptionsView()
        setupChoosePlanView()
    }

    private func setupPlanViewUIStyle() {
        if model?.isRecommended ?? false {
            planView.roundBottomAndRightCorners(cornerRadius: 6.0)
        } else {
            planView.roundCorners()
        }

        planView.addingShadow(size: CGSize(width: 0, height: 2), radius: 4, opacity: 0.16)
    }

    private func setupRecommendedView() {
        recommendedView.isHidden = !(model?.isRecommended ?? false)
        planView.layer.borderWidth = model?.isRecommended ?? false ? 1.0 : 0.0
        planView.layer.borderColor = UIColor(named: "VFGActiveSelectionOutline")?.cgColor ?? UIColor.clear.cgColor
        if !(model?.isRecommended ?? false) { return }
        recommendedViewBackground.roundUpperCorners(cornerRadius: 6.0)
        recommendedLabel.text = "device_upgrade_recommended_title".localized(bundle: .mva10Framework)
    }

    private func setupPlanHeaderView() {
        planImageView.image = VFGImage(named: model?.imageURL ?? "icAccelerationMid")
        let price = model?.price?.recurringPrice ?? 0
        let period = model?.price?.recurrencePeriod ?? ""
        let fullText = "\(price)€ /\(period)"
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "/\(period)")
        attributedString.addAttribute(.font, value: UIFont.vodafoneRegular(16.0), range: range)
        planNameLabel.text = model?.name
        planRecurringPriceLabel.attributedText = attributedString
        if  model?.isExpanded ?? false {
            chevronImageView.animateChevronUp()
        } else {
            chevronImageView.animateChevronDown()
        }
    }

    private func setupPlanDetailsView() {
        guard model?.isExpanded == true else {
            return
        }

        planDetailsView.isHidden = model?.price?.details.isEmpty ?? true
        if model?.price?.details.isEmpty ?? true { return }
        planDetailsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for detail in model?.price?.details ?? [] {
            guard let detailView = UpgradePlanDetailView.loadXib(
                bundle: .mva10Framework,
                nibName: "UpgradePlanDetailView") as? UpgradePlanDetailView else {
                continue
            }
            detailView.setup(
                detailImageURL: detail.imageURL,
                detailText: detail.detailDescription,
                bundle: .mva10Framework)
            planDetailsStackView.addArrangedSubview(detailView)
        }
    }

    private func setupSubscriptionsView() {
        guard model?.isExpanded == true else {
            return
        }

        planSubscriptionsView.isHidden = model?.subscriptions?.isEmpty ?? true
        if model?.subscriptions?.isEmpty ?? true { return }
        planSubscriptionTitleLabel.text =
            "device_upgrade_plan_screen_plan_card_subscriptions_title".localized(bundle: .mva10Framework)
        setupSubscriptionsCollectionView()
    }

    private func setupChoosePlanView() {
        guard model?.isExpanded == true, model?.isChoosable == true else {
            choosePlanView.isHidden = true
            planSubscriptionsView.roundBottomCorners(cornerRadius: 6.0)
            return
        }

        recommendedInfoView.isHidden = !(model?.isRecommended ?? false)
        choosePlanTitleLabel.text =
            "device_upgrade_plan_screen_plan_card_why_this_plan_title".localized(bundle: .mva10Framework)
        recommendedPlanInfoButton.setImage(VFGFrameworkAsset.Image.icInfoCircle, for: .normal)
        recommendedPlanInfoButton.contentEdgeInsets = .zero
        choosePlanButton.setTitle(
            "device_upgrade_plan_step_cta_button_title".localized(bundle: .mva10Framework),
            for: .normal)
    }

    // MARK: Actions
    @IBAction func planTopViewButtonDidPress(_ sender: UIButton) {
        planTopViewButtonAction()
    }

    @IBAction func recommendedInfoButtonDidPress(_ sender: UIButton) {
        delegate?.recommendedInfoButtonDidPress()
    }

    @IBAction func choosePlanButtonDidPress(_ sender: UIButton) {
        recommendedInfoButtonAction()
    }

    @objc func planTopViewButtonAction() {
        delegate?.planHeaderViewButtonDidPress(for: indexPath, isExpanded: model?.isExpanded ?? false)
    }

    @objc func recommendedInfoButtonAction() {
        choosePlanButtonAction()
    }

    @objc func choosePlanButtonAction() {
        delegate?.choosePlanButtonDidPress(for: indexPath)
    }
}

extension UpgradePlanCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func setupSubscriptionsCollectionView() {
        subscriptionsCollectionView.delegate = self
        subscriptionsCollectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: 66.0, height: 42.0)
        subscriptionsCollectionView.contentInset = UIEdgeInsets.zero
        subscriptionsCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        let subscriptionNib = UINib(nibName: String(describing: SubscriptionCell.self), bundle: Bundle.mva10Framework)
        subscriptionsCollectionView.register(
            subscriptionNib,
            forCellWithReuseIdentifier: String(describing: SubscriptionCell.self))
        subscriptionsCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.subscriptions?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: SubscriptionCell.self),
            for: indexPath) as? SubscriptionCell,
            model?.subscriptions?.count ?? 0 > 0,
            let subscription = model?.subscriptions?[indexPath.row] else {
            return UICollectionViewCell()
        }
        cell.setup(imageUrlString: subscription.imageURL)
        return cell
    }
}
