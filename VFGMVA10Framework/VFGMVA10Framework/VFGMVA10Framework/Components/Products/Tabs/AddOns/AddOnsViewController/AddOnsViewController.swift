//
//  AddOnsViewController.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 4/8/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// The view controller used to show the addons tab in the products & services screen.
public class AddOnsViewController: UIViewController, BaseTabsViewController {
    public weak var rootViewController: (UIViewController & BaseTabsViewControllerDelegate)?

    // MARK: - Properties
    // MARK: IBOutlets
    @IBOutlet weak var addOnsTitleLabel: VFGLabel!
    @IBOutlet weak var addOnsButtonStackView: UIStackView!
    @IBOutlet weak var addOnsStackViewBottomConstarint: NSLayoutConstraint!
    @IBOutlet weak var addOnsDescriptionLabel: VFGLabel!
    @IBOutlet weak var buyAddOnsButton: VFGButton!

    @IBOutlet weak var timeLineContainer: UIView!
    @IBOutlet weak var timelineViewImageView: VFGImageView!
    @IBOutlet weak var timelineViewLabel: VFGLabel!
    @IBOutlet weak var timelineButton: VFGButton!
    @IBOutlet weak var addOnsTimelineCollectionView: UICollectionView!

    @IBOutlet weak var timelineCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addOnsProductsCollectionView: UICollectionView!
    @IBOutlet weak var productsCollectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noAddonsAvailableLabel: VFGLabel!
    @IBOutlet weak var recommendedAddonContainerView: UIView!
    @IBOutlet weak var recommendView: UIView!
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var recommendedAddonDataStackView: UIStackView!

    // MARK: Data
    public weak var navigationDelegate: AddOnsNavigationControlProtocol?
    public weak var manageAddOnUiDelegate: ManageAddOnUIDelegateProtocol?
    public weak var manageAddOnNavigationDelegate: ManageAddOnNavigationProtocol?
    var addOnsViewModel: AddOnsViewModel?
    var myPlanDataProvider: MyPlanDataProviderProtocol?
    var myActiveServices: ActivePlanServicesProtocol?
    var myPlanModel: AddOnsProductModel?
    var addOnsDates: [String] = []
    var timelineProducts: [AddOnsProductModel] = []

    // MARK: CellIds
    let addOnsProductCellId = "AddOnsProductCell"
    let addOnsTimelineCellId = "AddOnsTimelineCell"
    let addOnsCVMCellId = "AddOnsCVMCell"
    let addOnsProductShimmerCellId = "AddOnsProductShimmerCell"

    // MARK: Observers
    var heightObserver: NSKeyValueObservation?
    var timelineHeightObserver: NSKeyValueObservation?

    // MARK: Constants
    let cellHeight: CGFloat = 90
    let activeAddOnsCellHeight: CGFloat = 110
    let addOnsCVMCellHeight: CGFloat = 158
    let cellPadding: CGFloat = 32
    let numberOfSections = 1
    let buyButtonContainerHeight: CGFloat = 75
    let recommendViewHeight: CGFloat = 220
    var numberOfAddOns = 0
    var initialFrameHeight: CGFloat = 0
    var timeLineCollectionViewCellsYPosition: [CGFloat] = []
    var dictOfDatesAndXPositions: [String: CGFloat] = [:]
    let errorCardConstraintConstant: CGFloat = 60
    let addOnsStackViewBottomConstarintConstant: CGFloat = 34

    // MARK: Booleans
    var isTimelineView = false
    var isDailyView = false
    var firstTimeDisplay = true
    var enterTimelineFromList = false
    var viewDidDisappear = false
    var isRecommendedAddOnsPurchased = false

    // MARK: Views
    var timelineDatesViews: [AddOnsTimelineDateView] = []
    var timelineSeparatorsView = UIView()
    var buyAddOnsButtonShimmerView = VFGShimmerView()
    var errorCardView: VFGErrorView?

    // MARK: Closures
    public var updateHeightClosure: ((CGFloat) -> Void)?
    public var setHeightClosure: ((CGFloat) -> Void)?

    // MARK: - Initializer
    required init(
        nibName: String = String(describing: AddOnsViewController.self),
        bundle: Bundle = Bundle.mva10Framework
    ) {
        super.init(nibName: nibName, bundle: bundle)
        title = "addons_screen_title".localized(bundle: Bundle.mva10Framework)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchData()
        setupAccessibilityLabels()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if addOnsViewModel?.shouldRefresh ?? false, addOnsViewModel?.enableRefresh ?? false {
            fetchData()
            addOnsViewModel?.shouldRefresh = false
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setHeightObserver()
        setTimelineCollectionViewHeightObserver()

        if isTimelineView {
            updateArrayOfProductsForTimeline()
        } else {
            addOnsProductsCollectionView?.reloadData()
            timelineProducts = addOnsViewModel?.myProducts ?? []
        }
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        heightObserver = nil
        timelineHeightObserver = nil
        viewDidDisappear = true
    }

    // MARK: - IBActions
    @IBAction func changeAddOnsViewDisplayStyle(_ sender: Any) {
        if isTimelineView {
            isTimelineView = false
            addOnsStackViewBottomConstarint.constant = addOnsStackViewBottomConstarintConstant
            addOnsProductsCollectionView.isHidden = false
            addOnsTimelineCollectionView.isHidden = true
            timelineSeparatorsView.isHidden = true
            recommendedAddonContainerView.isHidden = false
            addOnsProductsCollectionView?.reloadData()
            toggleNoAddOnsAvailableLabel()
        } else {
            isTimelineView = true
            if buyAddOnsButton.isHidden {
                addOnsStackViewBottomConstarint.constant = 0
            }
            addOnsProductsCollectionView.isHidden = true
            addOnsTimelineCollectionView.isHidden = false
            timelineSeparatorsView.isHidden = false
            recommendedAddonContainerView.isHidden = true
            enterTimelineFromList = true
            updateArrayOfProductsForTimeline()
            noAddonsAvailableLabel.isHidden = true
            addOnsDescriptionLabel.isHidden = false
        }
        setLabelsText()
    }

    @IBAction func buyAddOnPressed(_ sender: Any) {
        navigateToShopAddOn()
    }

    func handleDataError() {
        hideScreenContent()
        showErrorCard()
    }

    func hideScreenContent() {
        addOnsButtonStackView.isHidden = true
        timeLineContainer.isHidden = true
        addOnsDescriptionLabel.isHidden = true
    }

    func showScreenContent() {
        if isTimelineView {
            timeLineContainer.isHidden = false
        } else {
            checkVisibiltyOfBuyAddOnsButton()
            addOnsButtonStackView.isHidden = false
            addOnsProductsCollectionView.isHidden = false
            addOnsDescriptionLabel.isHidden = false
        }
        checkVisibiltyOfBuyAddOnsButton()
    }

    func showErrorCard() {
        stopShimmering()
        guard errorCardView == nil else { return }
        let errorDescription = "addons_screen_error_message".localized(bundle: .mva10Framework)
        let tryAgainDescription = "addons_screen_try_again".localized(bundle: .mva10Framework)
        let errorConfig = VFGErrorModel(
            title: "",
            description: errorDescription,
            tryAgainText: tryAgainDescription
        )
        errorCardView = VFGErrorView(
            error: errorConfig,
            accessibilityIdInitial: "DBerror"
        )
        errorCardView?.tryAgainLabel.text = tryAgainDescription

        guard let errorCardView = errorCardView else { return }

        errorCardView.refreshingClosure = { [weak self] in
            guard let self = self else { return }
            self.refresh()
        }
        errorCardView.alpha = 0
        view.addSubview(errorCardView)

        updateHeightClosure?(errorCardView.frame.height + initialFrameHeight)
        buyAddOnsButton.isHidden = true
        addOnsStackViewBottomConstarint.constant = 0
        errorCardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorCardView.topAnchor.constraint(
                equalTo: addOnsTitleLabel.bottomAnchor,
                constant: errorCardConstraintConstant),
            errorCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        UIView.animate(withDuration: Constants.ErrorCard.visibilityDuration) { [weak self] in
            guard let self = self else { return }
            errorCardView.alpha = 1
            self.addOnsProductsCollectionView.isHidden = true
        }
    }

    func removeErrorCard() {
        errorCardView?.removeFromSuperview()
        errorCardView = nil
    }
}

extension AddOnsViewController {
    func setupAccessibilityLabels() {
        addOnsTitleLabel.accessibilityLabel = addOnsTitleLabel.text ?? ""
        addOnsDescriptionLabel.accessibilityLabel = addOnsDescriptionLabel.text ?? ""
        timelineViewLabel.accessibilityLabel = timelineViewLabel.text ?? ""
        recommendLabel.accessibilityLabel = recommendLabel.text ?? ""
        noAddonsAvailableLabel.accessibilityLabel = noAddonsAvailableLabel.text ?? ""
        buyAddOnsButton.accessibilityLabel = buyAddOnsButton.titleLabel?.text ?? ""
        accessibilityCustomActions = [buyAddOnsVoiceOverAction()]
    }
    /// action for product AddOn  voice over
    /// - Returns: action for product AddOn  buttons in voice over
    func buyAddOnsVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "buyAddOns"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(buyAddOnPressed))
    }
}
