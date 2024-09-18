//
//  MyPlansViewController.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 4/9/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// My plan view controller.
public class MyPlanViewController: UIViewController, BaseTabsViewController {
    @IBOutlet weak var activePlanServicesTableView: UITableView!
    @IBOutlet weak var activePlanServicesTableTitle: VFGLabel!
    @IBOutlet weak var primaryPlanServiceTitle: VFGLabel!
    @IBOutlet public var bannerView: VFGPageBanner!
    @IBOutlet weak var bannerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var primaryPlanServiceLabelHight: NSLayoutConstraint!

    let bannerHeight: CGFloat = 154
    var initialFrameHeight: CGFloat = 0
    let bottomMarginHeight: CGFloat = 30
    var initialServicesTitlesHeight: CGFloat = 0
    var servicesTitlesHeight: CGFloat = 85
    let servicesSubTitlesHeight: CGFloat = 40
    var bottomMargin: CGFloat = 0
    var heightObserver: NSKeyValueObservation?
    var bundle = Bundle.main

    /// Add plan state manager.
    public var addPlanStateManager: VFGAddPlanStateManager?
    public weak var rootViewController: (UIViewController & BaseTabsViewControllerDelegate)?
    public var updateHeightClosure: ((CGFloat) -> Void)?
    public var setHeightClosure: ((CGFloat) -> Void)?
    public var entryPoint: ProductsEntryPoints = .myPhone
    /// Add plan state manager delegate.
    public weak var addPlanStateManagerDelegate: VFGAddPlanStateManagerProtocol?
    /// Page banner view.
    public var pageBanner: VFGPageBanner?
    /// Page banner delegate.
    public weak var pageBannerDelegate: VFGPageBannerProtocol?
    /// My plan view model.
    public var myPlanViewModel: MyPlanViewModelProtocol?
    /// An optional UIView that can be added as a footer to my plan screen.
    public var extraFooterView: UIView?
    var extraFooterHeight: CGFloat {
        self.extraFooterView?.frame.size.height ?? 0
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        myPlanViewModel?.startLoadingState = { [weak self] in
            self?.setLoadingState()
        }
        fetchMyActivePlanServices()
        configureUI()
        setupBannerView()
        setupActivePlansTableView()
        registerTableViewCells()
        reloadSection(0)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeHeightObserver()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // When return back to this view controller, set observation for height change again
        setHeightObserver()
    }

    private func updateLoadingState() {
        switch self.myPlanViewModel?.contentState {
        case .loading:
            self.setLoadingState()
        case .populated:
            self.setHeightObserver()
            self.setupActivePlansTableView()
            self.showServiceTitleAndSubTitleLabels()
            self.setupServiceTitle()
            self.activePlanServicesTableView.reloadData()
            self.reloadSection(0)
            self.showBanner()
            self.rootViewController?.dataFetchingDidComplete()
        case .error:
            self.setHeightObserver()
            self.activePlanServicesTableView.reloadData()
            self.hideBanner()
            self.setErrorTableView()
            self.rootViewController?.dataFetchingDidComplete()
        case .empty:
            self.setupEmptyState()
        default:
            break
        }
    }

    public func fetchMyActivePlanServices(completion: @escaping () -> Void = {}) {
        myPlanViewModel?.fetchMyActivePlanServices { [weak self] in
            guard let self = self else { return }
            self.updateLoadingState()
            completion()
        }
        rootViewController?.dataFetchingWillStart()
    }

    private func setupExtraFooterView() {
        if let extraFooterView = extraFooterView {
            contentStackView.removeArrangedSubview(extraFooterView)
            extraFooterView.removeFromSuperview()
        }
        extraFooterView = myPlanViewModel?.extraFooterView
        extraFooterView?.heightAnchor.constraint(equalToConstant: extraFooterHeight).isActive = true
        guard let extraFooterView = extraFooterView else { return }
        contentStackView.addArrangedSubview(extraFooterView)
    }

    private func hideServiceTableView() {
        activePlanServicesTableView.backgroundColor = .clear
        activePlanServicesTableView.layer.shadowOpacity = 0
    }

    private func setLoadingState() {
        setupServiceTitleAndSubTitleLabelsForShimmering()
        removeHeightObserver()
        activePlanServicesTableView.reloadData()
        setHeightClosure?(self.initialFrameHeight + self.bannerViewHeight.constant)
    }

    private func setErrorTableView() {
        hideServiceTableView()
        showServiceTitleAndSubTitleLabels()
        activePlanServicesTableTitle?.text = "my_plan_primary_card_title".localized(bundle: .mva10Framework)
        primaryPlanServiceTitle?.text = ""
    }

    func setupEmptyState() {
        setHeightObserver()
        activePlanServicesTableView.reloadData()
        hideBanner()
        setEmptyView()
        rootViewController?.dataFetchingDidComplete()
    }

    private func setEmptyView() {
        // hide table
        hideServiceTableView()
        // center titles
        activePlanServicesTableTitle.textAlignment = .center
        primaryPlanServiceTitle.textAlignment = .center
        // set title text
        activePlanServicesTableTitle?.text = myPlanViewModel?.serviceTitle
        // make sub title accept multi line
        primaryPlanServiceLabelHight.constant = servicesSubTitlesHeight
        primaryPlanServiceTitle.numberOfLines = 0
        // set sub title text
        primaryPlanServiceTitle?.text = myPlanViewModel?.serviceSubtitle
    }

    private func setupBannerView() {
        guard let pageBanner = pageBanner else {
            bottomMargin = bottomMarginHeight
            bannerViewHeight.constant = 0
            return
        }
        bannerViewHeight.constant = bannerHeight
        bannerView.addSubview(pageBanner)
        pageBanner.myPlanDelegate = self
        pageBanner.delegate = self
        pageBanner.frame = bannerView.bounds
        pageBanner.vfgAutoPinEdgesToSuperviewEdges()
    }

    private func setHeightObserver() {
        guard heightObserver == nil else { return }
        heightObserver = activePlanServicesTableView?.observe(\.contentSize, options: [.new]) { [weak self]_, change in
            guard let self = self,
            let newHeight = change.newValue?.height,
            let additionalHeight = self.myPlanViewModel?.additionalHeight else { return }
            self.setHeightClosure?(
            newHeight +
            self.initialFrameHeight +
            self.bannerViewHeight.constant -
            self.bottomMargin -
            self.initialServicesTitlesHeight + additionalHeight)
            self.activePlanServicesTableView.layoutIfNeeded()
            self.bannerView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }

    private func removeHeightObserver() {
        heightObserver = nil
    }

    private func configureUI() {
        activePlanServicesTableTitle.textColor = .primaryTextColor
        primaryPlanServiceTitle.textColor = .primaryTextColor
        setupExtraFooterView()
        let extraFooterHeight = extraFooterHeight != 0 ? extraFooterHeight + contentStackView.spacing : 0
        initialFrameHeight = view.frame.height + extraFooterHeight
        setupAccessibilityIdentifiers()
    }

    private func setupServiceTitle() {
        activePlanServicesTableTitle?.text = myPlanViewModel?.serviceTitle
        primaryPlanServiceTitle?.text = myPlanViewModel?.serviceSubtitle

        activePlanServicesTableTitle.isHidden = (myPlanViewModel?.serviceTitle ?? "").isEmpty
        primaryPlanServiceTitle.isHidden = (myPlanViewModel?.serviceSubtitle ?? "").isEmpty
        initialServicesTitlesHeight = activePlanServicesTableTitle.isHidden ? servicesTitlesHeight : 0
    }

    public func refresh() {
        guard activePlanServicesTableView != nil else { return }
        hideBanner()
        bottomMargin = 0
        fetchMyActivePlanServices()
    }

    func reloadSection(_ index: Int) {
        activePlanServicesTableView?.beginUpdates()
        activePlanServicesTableView?.reloadSections([index], with: .automatic)
        activePlanServicesTableView?.endUpdates()
    }

    func setupActivePlansTableView() {
        activePlanServicesTableView.layer.cornerRadius = 6
        activePlanServicesTableView.addingShadow(size: CGSize(width: 0, height: 2), radius: 8, opacity: 0.16)
        activePlanServicesTableView.backgroundColor = .lightBackground
        if #available(iOS 15.0, *) {
            activePlanServicesTableView.sectionHeaderTopPadding = 0
        }
        activePlanServicesTableView.dataSource = self
        activePlanServicesTableView.delegate = self
    }

    func hideServiceTitleAndSubTitleLabels() {
        activePlanServicesTableTitle.isHidden = true
        primaryPlanServiceTitle.isHidden = true
    }

    func showServiceTitleAndSubTitleLabels() {
        activePlanServicesTableTitle.isHidden = false
        primaryPlanServiceTitle.isHidden = false
    }

    func setupServiceTitleAndSubTitleLabelsForShimmering() {
        activePlanServicesTableTitle.text = "my_plan_primary_card_title".localized(bundle: .mva10Framework)
        primaryPlanServiceTitle.text = "my_plan_primary_card_subtitle".localized(bundle: .mva10Framework)
    }

    public required init(
        nibName: String = String(
        describing: MyPlanViewController.self),
        bundle: Bundle = Bundle.mva10Framework
    ) {
        super.init(nibName: nibName, bundle: bundle)
        title = "my_plan_screen_title".localized(bundle: Bundle.mva10Framework)
    }
}

extension MyPlanViewController {
    private func registerTableViewCells() {
        activePlanServicesTableView.register(
            UINib(nibName: PrimaryPlanLimitedCell.reuseIdentifier, bundle: Bundle.mva10Framework),
            forCellReuseIdentifier: PrimaryPlanLimitedCell.reuseIdentifier)
        activePlanServicesTableView.register(
            UINib(nibName: PrimaryPlanUnlimitedCell.reuseIdentifier, bundle: Bundle.mva10Framework),
            forCellReuseIdentifier: PrimaryPlanUnlimitedCell.reuseIdentifier)
        activePlanServicesTableView.register(
            UINib(nibName: PrimaryPlanInformativeCell.reuseIdentifier, bundle: Bundle.mva10Framework),
            forCellReuseIdentifier: PrimaryPlanInformativeCell.reuseIdentifier)
        activePlanServicesTableView.register(
            UINib(nibName: PrimaryPlanDescriptionCell.reuseIdentifier, bundle: Bundle.mva10Framework),
            forCellReuseIdentifier: PrimaryPlanDescriptionCell.reuseIdentifier)
        activePlanServicesTableView.register(
            UINib(nibName: PrimaryPlanServicesHeader.reuseIdentifier, bundle: Bundle.mva10Framework),
            forHeaderFooterViewReuseIdentifier: PrimaryPlanServicesHeader.reuseIdentifier)
        activePlanServicesTableView.register(
            UINib(nibName: PrimaryPlanServicesFooter.reuseIdentifier, bundle: Bundle.mva10Framework),
            forHeaderFooterViewReuseIdentifier: PrimaryPlanServicesFooter.reuseIdentifier)
        activePlanServicesTableView.register(
            UINib(nibName: MyPlanShimmerCell.reuseIdentifier, bundle: Bundle.mva10Framework),
            forCellReuseIdentifier: MyPlanShimmerCell.reuseIdentifier)
        activePlanServicesTableView.register(
            UINib(nibName: ProductsErrorTableViewCell.reuseIdentifier, bundle: Bundle.mva10Framework),
            forCellReuseIdentifier: ProductsErrorTableViewCell.reuseIdentifier)
        activePlanServicesTableView.register(
            UINib(nibName: HideCustomDetailsButtonCell.reuseIdentifier, bundle: Bundle.mva10Framework),
            forCellReuseIdentifier: HideCustomDetailsButtonCell.reuseIdentifier)
    }

    private func setupAccessibilityIdentifiers() {
        activePlanServicesTableView.accessibilityIdentifier = "MPtableView"
    }
}

extension MyPlanViewController: VFGPageBannerDismissProtocol {
    public func dismissBanner() {
        hideBanner()
    }
}

// MARK: - VFGPageBannerProtocol
extension MyPlanViewController: VFGPageBannerProtocol {
    public func primaryButtonDidSelect(for pageBanner: VFGPageBanner) {
        pageBannerDelegate?.primaryButtonDidSelect(for: pageBanner)
    }

    public func secondaryButtonDidSelect(for pageBanner: VFGPageBanner) {
        dismissBanner()

        pageBannerDelegate?.secondaryButtonDidSelect(for: pageBanner)
    }

    public func switchButtonDidSelect(for pageBanner: VFGPageBanner) {}
}
