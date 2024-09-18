//
//  MyPlanViewController+TableViewDelegate.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 03/07/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//
import VFGMVA10Foundation

extension MyPlanViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard tableView == activePlanServicesTableView else {
            return myPlanViewModel?.numberOfInActivePlanServices() ?? 0
        }
        return myPlanViewModel?.numberOfActivePlanServices() ?? 0
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contentState = myPlanViewModel?.contentState

        switch contentState {
        case .loading, .error:
            return 1
        case .populated where section == 0:
            let mainInclusionsCount = myPlanViewModel?.mainInclusions?.count ?? 0
            let isHideCustomDetailsEnabled = myPlanViewModel?.customDetailsButtonTitle != nil
            let showHideCustomDetailsBtn = mainInclusionsCount > 0 && isHideCustomDetailsEnabled
            return showHideCustomDetailsBtn ? mainInclusionsCount + 1 : mainInclusionsCount
        default:
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contentState = myPlanViewModel?.contentState
        guard indexPath.row < (myPlanViewModel?.mainInclusions?.count ?? 0)
            || contentState != .populated else {
            return addHideCustomDetailsBtnCell(in: tableView, at: indexPath)
        }
        let inclusionType = myPlanViewModel?.inclusionType(at: indexPath.row)
        switch (contentState, inclusionType) {
        case (.loading, _):
            return addShimmerCell(in: tableView, at: indexPath)
        case (.populated, .limited) where indexPath.section == 0:
            return addPrimaryPlanLimitedCell(in: tableView, at: indexPath)
        case (.populated, .unlimited) where indexPath.section == 0:
            return addPrimaryPlanUnlimitedCell(in: tableView, at: indexPath)
        case (.populated, .informative) where indexPath.section == 0:
            return addPrimaryPlanInformativeCell(in: tableView, at: indexPath)
        case (.populated, .description) where indexPath.section == 0:
            return addPrimaryPlanDescriptionCell(in: tableView, at: indexPath)
        case (.error, _):
            return addErrorCell(in: tableView, at: indexPath)
        default:
            return UITableViewCell()
        }
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard myPlanViewModel?.contentState != .error,
            myPlanViewModel?.isSectionHeaderHidden == false else { return nil }
        guard tableView == activePlanServicesTableView,
            section == 0,
            let sectionHeader = tableView
                .dequeueReusableHeaderFooterView(withIdentifier: PrimaryPlanServicesHeader.reuseIdentifier)
                as? PrimaryPlanServicesHeader else { return UIView() }
        sectionHeader.viewModel = myPlanViewModel?.headerViewModel()
        return sectionHeader
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard myPlanViewModel?.isMyPlanFooterHidden == false,
            myPlanViewModel?.contentState != .error,
            myPlanViewModel?.contentState != .empty else { return nil }
        guard tableView == activePlanServicesTableView,
            section == 0,
            let sectionFooter = tableView
                .dequeueReusableHeaderFooterView(withIdentifier: PrimaryPlanServicesFooter.reuseIdentifier)
                as? PrimaryPlanServicesFooter else { return UIView() }
        sectionFooter.viewModel = myPlanViewModel?.footerViewModel()
        sectionFooter.upgradeAction = { [weak self] in
            self?.navigateToSwapPlanComparisonViewController()
        }
        sectionFooter.updateHeightClosure = { [weak self] in
            UIView.setAnimationsEnabled(false)
            self?.activePlanServicesTableView.beginUpdates()
            self?.activePlanServicesTableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
        return sectionFooter
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = UITableView.automaticDimension
        guard let contentState = myPlanViewModel?.contentState else { return height }
        switch contentState {
        case .loading, .error, .empty:
            return 0
        default:
            return height
        }
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard myPlanViewModel?.isMyPlanFooterHidden == false else { return 0 }
        let height = UITableView.automaticDimension
        guard let contentState = myPlanViewModel?.contentState else { return height }
        switch contentState {
        case .loading, .error:
            return 0
        default:
            return height
        }
    }

    func showBanner() {
        guard pageBanner != nil else {
            bottomMargin = bottomMarginHeight
            bannerViewHeight.constant = 0
            return
        }
        bannerViewHeight.constant = bannerHeight
        bannerView.isHidden = false
        setHeightClosure?(
            activePlanServicesTableView.contentSize.height +
                bannerViewHeight.constant +
                initialFrameHeight -
                bottomMargin)
        activePlanServicesTableView.layoutIfNeeded()
        bannerView.layoutIfNeeded()
        view.layoutIfNeeded()
    }

    func hideBanner() {
        bottomMargin = bottomMarginHeight
        bannerViewHeight.constant = 0
        bannerView.isHidden = true
        setHeightClosure?(
            activePlanServicesTableView.contentSize.height -
                bottomMargin -
                bannerViewHeight.constant -
                initialFrameHeight)
        activePlanServicesTableView.layoutIfNeeded()
        bannerView.layoutIfNeeded()
        view.layoutIfNeeded()
    }

    func navigateToSwapPlanComparisonViewController() {
        guard let delegate = VFGManagerFramework.purchaseDelegate else { return }
        delegate.setupPurchaseModule()
        let swapPlanComparisonViewController = delegate.swapPlanComparisonViewController()

        navigationController?.pushViewController(swapPlanComparisonViewController, animated: true)
    }
}
