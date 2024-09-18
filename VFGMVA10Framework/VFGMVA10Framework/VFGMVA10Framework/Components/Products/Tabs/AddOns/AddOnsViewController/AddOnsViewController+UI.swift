//
//  AddOnsViewController+UI.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 3/19/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension AddOnsViewController {
    func configureUI() {
        initialFrameHeight = view.frame.height
        timelineViewLabel.textColor = .linksRed
        setupCollectionView()
        setLabelsText()
        setupRecomendedAddonView()
        timelineButton.isEnabled = !(addOnsViewModel?.isTimeLineViewHidden ?? false)
        guard let layout = addOnsTimelineCollectionView?.collectionViewLayout
            as? AddOnsTimelineCollectionViewLayout else { return }
        layout.delegate = self
    }

    private func setupCollectionView() {
        setupAddOnsProductsCell()
        setupAddOnsTimelineProductsCell()
        setupAddOnsCVMProductsCell()
        setupAddOnsProductShimmerCell()
        setupAccessibilityIdentifiers()
    }

    func setHeightObserver() {
        productsCollectionHeightConstraint.constant = 0
        timelineCollectionViewHeightConstraint.constant = 0
        heightObserver = addOnsProductsCollectionView.observe(\.contentSize, options: [.new]) { [weak self]_, change in
            guard let self = self,
                let newHeight = change.newValue?.height else { return }
            if !self.isTimelineView {
                self.productsCollectionHeightConstraint.constant = newHeight
                self.setHeightClosure?(newHeight + self.initialFrameHeight)
            }
        }
    }

    func setTimelineCollectionViewHeightObserver() {
        productsCollectionHeightConstraint.constant = 0
        timelineCollectionViewHeightConstraint.constant = 0
        timelineHeightObserver =
            addOnsTimelineCollectionView.observe(\.contentSize, options: [.new]) { [weak self]_, change in
                guard let self = self,
                    let newHeight = change.newValue?.height else { return }
                if self.isTimelineView {
                    self.timelineCollectionViewHeightConstraint.constant = newHeight
                    self.updateHeightClosure?(newHeight + self.initialFrameHeight)
                    self.timelineSeparatorsView.frame.size.height = self.addOnsTimelineCollectionView.contentSize.height
                        + UIScreen.main.bounds.size.height
                }
            }
    }

    func toggleNoAddOnsAvailableLabel() {
        if addOnsViewModel?.myProducts?.isEmpty ?? false, addOnsViewModel?.numberOfAddOnsCVM() == 0 {
            noAddonsAvailableLabel.isHidden = false
            addOnsDescriptionLabel.isHidden = true
        } else {
            noAddonsAvailableLabel.isHidden = true
            addOnsDescriptionLabel.isHidden = false
        }
    }

    func setLabelsText() {
        buyAddOnsButton.setTitle(
            "manage_addon_buy_action_title".localized(bundle: .mva10Framework),
            for: .normal)
        noAddonsAvailableLabel.text = "addons_not_available".localized(bundle: Bundle.mva10Framework)
        buyAddOnsButton.setTitle("manage_addon_buy_action_title".localized(bundle: .mva10Framework), for: .normal)
        if isTimelineView {
            addOnsTitleLabel.text = "addons_timeline_section_title".localized(bundle: Bundle.mva10Framework)
            addOnsDescriptionLabel.text = "addons_timeline_section_description".localized(bundle: Bundle.mva10Framework)
            timelineViewLabel.text = "addons_timeline_switch".localized(bundle: Bundle.mva10Framework)
            timelineViewImageView.image = UIImage(named: "icMenuRed", in: Bundle.mva10Framework, compatibleWith: nil)
        } else {
            addOnsTitleLabel.text = "addons_list_section_title".localized(bundle: Bundle.mva10Framework)
            addOnsDescriptionLabel.text = "addons_list_section_description".localized(bundle: Bundle.mva10Framework)
            timelineViewLabel.text = "addons_list_switch".localized(bundle: Bundle.mva10Framework)
            timelineViewImageView.image = UIImage(
                named: "icActivityRed",
                in: Bundle.mva10Framework,
                compatibleWith: nil)
        }
    }

    func startShimmering() {
        if isTimelineView {
            changeAddOnsViewDisplayStyle(self)
        }
        if let productsVC = rootViewController as? ProductsViewController {
            productsVC.enableScrolling = false
        }
        if isTimelineView {
            addOnsTimelineCollectionView.reloadData()
        } else {
            addBuyAddOnsButtonShimmerView()
            addOnsProductsCollectionView.reloadData()
        }
        addTimelineButtonShimmerView()
    }

    func stopShimmering() {
        if let productsVC = rootViewController as? ProductsViewController {
            productsVC.enableScrolling = true
            productsVC.productsCollectionView.reloadData()
        }
        removeBuyAddOnsShimmerView()
        removeTimelineButtonShimmerView()

        if isTimelineView {
            addOnsTimelineCollectionView.reloadData()
        } else {
            showRecomendedAddonView()
            addOnsProductsCollectionView.reloadData()
        }
    }

    func addBuyAddOnsButtonShimmerView() {
        hideRecomendedAddonView()
        addOnsButtonStackView.addSubview(buyAddOnsButtonShimmerView)
        buyAddOnsButtonShimmerView.translatesAutoresizingMaskIntoConstraints = false
        buyAddOnsButtonShimmerView.accessibilityIdentifier = "ADButtonShimmerView"
        buyAddOnsButtonShimmerView.topAnchor.constraint(equalTo: addOnsButtonStackView.topAnchor).isActive = true
        buyAddOnsButtonShimmerView.heightAnchor.constraint(equalToConstant: 28.1).isActive = true
        buyAddOnsButtonShimmerView.leadingAnchor.constraint(
        equalTo: addOnsButtonStackView.leadingAnchor).isActive = true
        buyAddOnsButtonShimmerView.trailingAnchor.constraint(
        equalTo: addOnsButtonStackView.trailingAnchor).isActive = true
        addOnsStackViewBottomConstarint.constant = addOnsStackViewBottomConstarintConstant
        buyAddOnsButton.isHidden = true
        buyAddOnsButtonShimmerView.startAnimation()
    }

    func addTimelineButtonShimmerView() {
        timeLineContainer.isHidden = addOnsViewModel?.isTimeLineViewHidden ?? false
        let timeLineButtonShimmerView = VFGShimmerView(
            frame: CGRect(
                x: 0,
                y: timeLineContainer.frame.height / 2,
                width: timeLineContainer.frame.size.width,
                height: 12
            )
        )
        timeLineButtonShimmerView.accessibilityIdentifier = "ADTimeLineButtonShimmerView"
        timeLineContainer.subviews.forEach { $0.isHidden = true }
        timeLineContainer.addSubview(timeLineButtonShimmerView)
        timeLineButtonShimmerView.startAnimation()
    }

    func removeBuyAddOnsShimmerView() {
        buyAddOnsButtonShimmerView.removeFromSuperview()
        buyAddOnsButton.isHidden = manageAddOnUiDelegate?.isBuyAddOnsButtonHidden ?? false
    }

    func removeTimelineButtonShimmerView() {
        if let timeLineButtonShimmerView = timeLineContainer.subviews.last as? VFGShimmerView {
            timeLineButtonShimmerView.removeFromSuperview()
            timeLineContainer.subviews.forEach { $0.isHidden = false }
        }
    }

    private func setupAccessibilityIdentifiers() {
        addOnsTimelineCollectionView.accessibilityIdentifier = "ADtimeLineCollection"
        addOnsProductsCollectionView.accessibilityIdentifier = "ADproductsCollection"
        buyAddOnsButton.accessibilityIdentifier = "ADbuyAddOnsBtn"
    }

    func setupRecomendedAddonView() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(recommendedAddonContainerViewTapGesture(_:))
        )
        recommendedAddonContainerView.addGestureRecognizer(tapGesture)
        recommendedAddonContainerView.configureShadow()
        recommendedAddonContainerView.layer.borderWidth = 1
        recommendedAddonContainerView.layer.borderColor = UIColor.VFGSelectedCellBorder.cgColor
        recommendedAddonContainerView.backgroundColor = .lightBackground
        recommendView.roundUpperCorners(cornerRadius: 6)
        recommendView.backgroundColor = .VFGSelectedCellBorder
        recommendLabel.text = "addons_recommended_title".localized(bundle: .mva10Framework)
    }

    func showRecomendedAddonView() {
        self.addOnsViewModel?.updateMyPromProduct = { [weak self] in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                guard let myPromProduct = self.addOnsViewModel?.myPromProduct else {
                    self.isRecommendedAddOnsPurchased = true
                    self.hideRecomendedAddonView()
                    return
                }
                self.checkVisibiltyOfBuyAddOnsButton()
                self.recommendedAddonContainerView.isHidden = false
                self.recommendedAddonDataStackView.reload([myPromProduct], using: AddOnsProductView.self)
            }
        }
    }

    func getHeightForAddOnsRecommendedView(for addOn: AddOnsProductModel) -> CGFloat {
        let nibName = String(describing: AddOnsProductView.self)
        let nib = Bundle.mva10Framework.loadNibNamed(nibName, owner: nil, options: nil)
        guard let addOnsProductView = nib?.first as? AddOnsProductView else {
            return 0
        }
        let addOnsProductViewWidth = recommendedAddonDataStackView.frame.size.width
        addOnsProductView.setupView(with: addOn)
        addOnsProductView.translatesAutoresizingMaskIntoConstraints = false
        addOnsProductView.widthAnchor.constraint(equalToConstant: addOnsProductViewWidth).isActive = true
        addOnsProductView.setNeedsLayout()
        addOnsProductView.layoutIfNeeded()
        return addOnsProductView.frame.size.height
    }

    @objc func recommendedAddonContainerViewTapGesture(_ sender: UITapGestureRecognizer) {
        guard let myPromProduct = addOnsViewModel?.myPromProduct else { return }
        navigateToRemoveORAddAddOn(with: myPromProduct, actionType: .buy)
    }

    func hideRecomendedAddonView() {
        checkVisibiltyOfBuyAddOnsButton()
        recommendedAddonContainerView.isHidden = true
    }

    func checkVisibiltyOfBuyAddOnsButton() {
        buyAddOnsButton.isHidden = manageAddOnUiDelegate?.isBuyAddOnsButtonHidden ?? false
        if buyAddOnsButton.isHidden && isRecommendedAddOnsPurchased {
            addOnsStackViewBottomConstarint.constant = 0
        }
    }
}
