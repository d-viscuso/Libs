//
//  ShopAddOnsViewController.swift.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 4/23/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public class ShopAddOnsViewController: VFGBaseViewController {
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var filterView: VFGFilterView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var subTitleLabel: VFGLabel!
    @IBOutlet weak var shopAddOnsCollectionView: UICollectionView!
    @IBOutlet weak var customFilterView: UIView!
    public var shopAddOnsVM: ShopAddOnsViewModel?
    public weak var navigationDelegate: AddOnsNavigationControlProtocol?
    public weak var manageAddOnUiDelegate: ManageAddOnUIDelegateProtocol?
    public weak var manageAddOnNavigationDelegate: ManageAddOnNavigationProtocol?

    var errorCardView: VFGErrorView?
    let errorCardConstraintConstant: CGFloat = 60

    let categoryEstimatedHeight: CGFloat = 35
    let categoryEstimatedWidth: CGFloat = 71
    let categoryInteritemSpacing: CGFloat = 12.0
    let categoryCellNibName = "AddOnsCategoryCell"
    let categoryCellId = "AddOnsCategoryCellId"
    private let addOnsProductCellId = "AddOnsProductCell"
    private let addOnsProductShimmerCellId = "AddOnsProductShimmerCell"

    private let cellHeight: CGFloat = 90
    private let recommendedViewHeight: CGFloat = 32
    private let cellPadding: CGFloat = 32
    private let cellShadow: CGFloat = 6
    private let minimumLineSpacing: CGFloat = 15

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionViews()
        initViewModel()
        setupAccessibilityLabels()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let navigationController = navigationController as? MVA10NavigationController {
            navigationController.isTransparentBackground = false
            navigationController.hasDivider = true
            navigationController.bottomDividerColor = UIColor.VFGGreyDividerFive
        }
    }

    func setupUI() {
        titleLabel?.text = "shop_addons_title".localized(bundle: Bundle.mva10Framework)
        subTitleLabel?.text = "shop_addons_subtitle".localized(bundle: Bundle.mva10Framework)
    }

    func setupCollectionViews() {
        setupShopAddOnsCollectionView()
        setUpFilterView()
    }

    func setUpFilterView() {
        filterView?.collectionViewDelegate = self
        filterView.filterUnselectedBorderColor = .VFGPrimaryText
    }

    func refreshCollectionContent() {
        let height = shopAddOnsCollectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeightConstraint.constant = height
    }

    func setupShopAddOnsCollectionView() {
        shopAddOnsCollectionView.delegate = self
        shopAddOnsCollectionView.dataSource = self
        shopAddOnsCollectionView.accessibilityIdentifier = "ADshopAddOnsCollection"

        let addOnsCell = UINib(nibName: addOnsProductCellId, bundle: Bundle.mva10Framework)
        shopAddOnsCollectionView.register(
            addOnsCell,
            forCellWithReuseIdentifier: addOnsProductCellId)
        let addOnsShimmerCell = UINib(nibName: addOnsProductShimmerCellId, bundle: Bundle.mva10Framework)
        shopAddOnsCollectionView.register(
            addOnsShimmerCell,
            forCellWithReuseIdentifier: addOnsProductShimmerCellId)
    }

    func initViewModel() {
        shopAddOnsVM?.updateLoadingStatus = { [weak self] in
            guard let self = self else { return }

            switch self.shopAddOnsVM?.contentState {
            case .loading:
                self.containerScrollView.isScrollEnabled = false
                self.startShimmering()
            case .populated:
                self.reloadCategories()
                self.stopShimmering()
                self.containerScrollView.isScrollEnabled = true
                self.refreshCollectionContent()
            case .error:
                VFGDebugLog("Failed fetching addOns")
                self.handleDataError()
            default:
                VFGDebugLog("Default case")
            }
        }

        shopAddOnsVM?.reloadProducts = { [weak self] in
            self?.shopAddOnsCollectionView?.reloadData()
            self?.shopAddOnsCollectionView?.layoutIfNeeded()
            self?.refreshCollectionContent()
        }

        shopAddOnsVM?.fetchAllProducts()
        guard let view = shopAddOnsVM?.shopAddOnDataProvider.customView() else { return }
        customFilterView.embed(view: view)
    }

    func reloadCategories() {
        filterView?.categories.removeAll()
        filterView.selectedCategories = [AddOnsTypeLocalize.all.localizedString]
        if let categoriesRawValues = shopAddOnsVM?.addOnsCategories {
            filterView?.categories.append(contentsOf: categoriesRawValues)
        }
    }

    func startShimmering() {
        filterView.triggerShimmerMode = true
        shopAddOnsCollectionView.reloadData()
    }

    func stopShimmering() {
        filterView.triggerShimmerMode = false
        shopAddOnsCollectionView.reloadData()
    }

    func handleDataError() {
        hideScreenContent()
        showErrorCard()
    }

    func hideScreenContent() {
        filterView.isHidden = true
        separator.isHidden = true
        subTitleLabel.isHidden = true
        shopAddOnsCollectionView.isHidden = true
    }

    func showScreenContent() {
        filterView.isHidden = false
        separator.isHidden = false
        subTitleLabel.isHidden = false
        shopAddOnsCollectionView.isHidden = false
    }

    func showErrorCard() {
        guard errorCardView == nil else { return }
        let errorDescription = "shop_addons_screen_error_message".localized(bundle: .mva10Framework)
        let tryAgainDescription = "shop_addons_screen_try_again".localized(bundle: .mva10Framework)
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
            self.showScreenContent()
            self.removeErrorCard()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.shopAddOnsVM?.fetchAllProducts()
            }
        }
        errorCardView.alpha = 0
        view.addSubview(errorCardView)
        errorCardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorCardView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: errorCardConstraintConstant),
            errorCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        UIView.animate(withDuration: Constants.ErrorCard.visibilityDuration) { [weak self] in
            guard let self = self else { return }
            errorCardView.alpha = 1
            self.shopAddOnsCollectionView.isHidden = true
        }
    }

    func removeErrorCard() {
        errorCardView?.removeFromSuperview()
        errorCardView = nil
    }
}

extension ShopAddOnsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == shopAddOnsCollectionView {
            if shopAddOnsVM?.contentState == .loading {
                return 5
            } else if shopAddOnsVM?.contentState == .populated {
                return shopAddOnsVM?.numberOfProducts() ?? 0
            }
        }
        return 0
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard collectionView == shopAddOnsCollectionView else {
            return UICollectionViewCell()
        }
        switch shopAddOnsVM?.contentState {
        case .loading:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: addOnsProductShimmerCellId,
                for: indexPath) as? AddOnsProductShimmerCell
            cell?.startShimmer()
            cell?.accessibilityIdentifier = "ADshopShimmerCell\(indexPath.row)"
            return cell ?? UICollectionViewCell()
        case .populated:
            return getCollectionAddOnsProductCell(at: indexPath)
        default:
            return UICollectionViewCell()
        }
    }

    func getCollectionAddOnsProductCell(at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = shopAddOnsCollectionView.dequeueReusableCell(
            withReuseIdentifier: addOnsProductCellId,
            for: indexPath) as? AddOnsProductCell else { return UICollectionViewCell() }
        return getAddOnsProductCell(cell, at: indexPath)
    }

    func getResizingAddOnsProductCell(at indexPath: IndexPath) -> AddOnsProductCell {
        getAddOnsProductCell(at: indexPath)
    }

    func getAddOnsProductCell(_ cell: AddOnsProductCell? = nil, at indexPath: IndexPath) -> AddOnsProductCell {
        guard let product = shopAddOnsVM?.filteredProducts[indexPath.item] else { return AddOnsProductCell() }
        let isPromProduct = shopAddOnsVM?.isPromProduct(at: indexPath) == true
        guard let cell = cell else {
            return AddOnsProductCell.makeResizingAddOnsProductCell(
                for: product,
                    isPromProduct: isPromProduct)
        }
        return cell.setUp(with: product, isPromProduct: isPromProduct)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard shopAddOnsVM?.contentState == .populated else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? VFGFilterCell else {
            // shopAddOnsCollectionView code
            guard collectionView == shopAddOnsCollectionView,
                let product = shopAddOnsVM?.product(at: indexPath.row),
                shopAddOnsVM?.contentState == .populated else { return }
                navigateToBuyAddOn(with: product)
            return
        }
        if filterView?.selectedCategories.first == AddOnsTypeLocalize.all.localizedString {
            deselectItem(collectionView, indexPath: IndexPath(item: 0, section: 0))
            filterView?.selectedCategories.removeFirst()
        }
        // deselect All
        if filterView?.selectedCategories.contains(AddOnsTypeLocalize.all.localizedString) ?? false {
            let allIndexPath = IndexPath(item: 0, section: 0)
            deselectItem(collectionView, indexPath: allIndexPath)
            filterView?.selectedCategories = []
        }
        // if All is selected, deselect all items
        if cell.categoryType == AddOnsTypeLocalize.all.localizedString {
            for index in 1..<collectionView.numberOfItems(inSection: 0) {
                deselectItem(collectionView, indexPath: IndexPath(item: index, section: 0))
            }
            filterView?.selectedCategories = []
        }
        filterView?.selectedCategories.append(cell.categoryType)
        shopAddOnsVM?.filter(with: filterView?.selectedCategories ?? [])
    }

    func deselectItem(_ collectionView: UICollectionView, indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.isSelected = false
        collectionView.deselectItem(at: indexPath, animated: false)
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? VFGFilterCell,
            collectionView == filterView?.filterCollectionView else { return }
        filterView?.selectedCategories.removeAll { addOnType in
            addOnType == cell.categoryType
        }
        if filterView?.selectedCategories.isEmpty ?? false {
            let allIndexPath = IndexPath(item: 0, section: 0)
            collectionView.cellForItem(at: allIndexPath)?.isSelected = true
            filterView?.selectedCategories = [AddOnsTypeLocalize.all.localizedString]
        }
        shopAddOnsVM?.filter(with: filterView?.selectedCategories ?? [])
    }
}

extension ShopAddOnsViewController {
    func navigateToBuyAddOn(with addOn: AddOnsProductModel) {
        switch navigationDelegate?.buyAddOnNavigationType(viewController: self, addOn) {
        case .customNavigation(let navigationAction):
            navigationAction()
            return
        default:
            break
        }
        guard let manageAddOnVC =
            ManageAddOnViewController.instance(
                from: "ManageAddOn",
                with: "ManageAddOnViewController",
                bundle: Bundle.mva10Framework) as? ManageAddOnViewController,
            let shopAddOnsVM =
                shopAddOnsVM?.shopAddOnDataProvider as? VFGManageAddOnDataProviderProtocol else { return }

        manageAddOnVC.manageAddOnVM = ManageAddOnPlanViewModel(
            manageAddOnDataProvider: shopAddOnsVM,
            addOn: addOn,
            actionType: .buy,
            confirmAlertDelegate: manageAddOnVC,
            resultViewDelegate: manageAddOnVC)
        manageAddOnVC.uiDelegate = manageAddOnUiDelegate
        manageAddOnVC.navigationDelegate = manageAddOnNavigationDelegate
        if let navController = self.navigationController as? MVA10NavigationController {
            navController.setTitle(
                title: addOn.title ?? "",
                accessibilityID: addOn.title ?? "",
                for: manageAddOnVC)
        } else {
            self.navigationController?.title = (addOn.title ?? "").localized(bundle: Bundle.mva10Framework)
        }
        self.navigationController?.pushViewController(manageAddOnVC, animated: true)
    }
}

extension ShopAddOnsViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        switch collectionView {
        case shopAddOnsCollectionView:
            let cellWidth = collectionView.frame.width - cellPadding
            if shopAddOnsVM?.contentState == .loading {
                return CGSize(width: cellWidth, height: cellHeight)
            }
            let sizingCell = getResizingAddOnsProductCell(at: indexPath)
            sizingCell.translatesAutoresizingMaskIntoConstraints = false
            sizingCell.widthAnchor.constraint(equalToConstant: cellWidth).isActive = true
            sizingCell.setNeedsLayout()
            sizingCell.layoutIfNeeded()
            let computedSize = sizingCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            return CGSize(width: cellWidth, height: computedSize.height)
        case filterView.filterCollectionView:
            return CGSize(width: categoryEstimatedWidth, height: categoryEstimatedHeight)
        default:
            return .zero
        }
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return minimumLineSpacing - cellShadow
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return categoryInteritemSpacing
    }
}
