//
//  ProductsViewController.swift
//  VFGMVA10Framework
//
//  Created by Hamsa Hassan on 12/23/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public protocol SegmentedControllerTabDelegate: AnyObject {
    func notifiySegmentedControllerTab()
}

/// Products view contoller.
public class ProductsViewController: VFGBaseViewController {
    @IBOutlet weak var headerView: ProductsHeaderView!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tabsStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var segmentedCollectionView: SegmentedCollectionView!
    @IBOutlet weak var tabsTopDividerView: UIView!
    @IBOutlet weak var tabsBottomDividerView: UIView!
    @IBOutlet weak var segmentedCollectionViewBackground: UIView!
    private let headerMaxYOffset: CGFloat = 125.0
    private let sohoHeaderMaxYOffset: CGFloat = 90.0
    private let productsCollectionCellId = "ProductsCollectionCellId"
    private let productsCollectionCellNibName = "ProductsCollectionCell"

    // a variable used to store the height of productsCollectionViewHeight, and to reflect in height of the collectionViewCell at runtime
    private var productsCollectionViewHeight: CGFloat = 0.0 {
        didSet {
            if productsCollectionViewHeight != oldValue {
                productsCollectionView.collectionViewLayout.invalidateLayout()
                productsCollectionView.collectionViewLayout.prepare()
            }
        }
    }

    /// Header view model.
    public var headerViewModel: ProductsHeaderViewModel? {
        didSet {
            guard headerView != nil else { return }
            setupHeader()
            headerView.delegate = self
        }
    }
    /// Soho header view model.
    public var sohoHeaderViewModel: ProductsHeaderViewModel?
    /// Callback to be triggered when refresh button is clicked
    public var refreshHeaderViewModel: (() -> Void)?
    /// List of tabs controllers.
    public var tabsViewControllers: [BaseTabsViewController] = []
    /// User type.
    public var userType: VFGUserType = .payM
    /// Header delegate.
    public weak var headerDelegate: (ProductsHeaderViewDelegate & VFGRefreshViewDelegate)? {
        didSet {
            guard headerView != nil else { return }
            headerView.delegate = headerDelegate
        }
    }
    /// products view controller delegate
    public weak var productsDelegate: ProductsViewControllerDelegate?
    public weak var tabDelegate: SegmentedControllerTabDelegate?
    /// Current tab index.
    public var currentIndex = 0
    /// Current style of tab (if scroll or cover the screen size).
    public var segmentedCellStyle: SegmentedCellStyle = .compact
    /// DispatchGroup action.
    let dispatchGroup = DispatchGroup()
    public var sohoHeaderViewHeight: CGFloat = 90
    public var enableTabsScrolling: Bool?
    public var isSwipeGestureEnabled = false

    public var enableScrolling: Bool?
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
        guard isSwipeGestureEnabled else { return }
        if gesture.direction == .left {
            guard currentIndex < tabsViewControllers.count - 1 else { return }
            currentIndex += 1
        } else if gesture.direction == .right {
            guard currentIndex > 0 else { return }
            currentIndex -= 1
        }

        segmentedCollectionView.collectionView(
            segmentedCollectionView.collectionView,
            didSelectItemAt: [0, currentIndex]
        )
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundColors()
        createNewTabButton()
        setupHeader()
        setupCollectionView()
        setupTabs()
        headerView.delegate = self
        ProductsManager.trackView(
            pageName: "analytics_framework_sub_tray_product_title".localized(bundle: .mva10Framework))
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = navigationController as? MVA10NavigationController {
            navigationController.hasDivider = false
        }
        scrollView.contentInsetAdjustmentBehavior = .always
        tabsViewControllers.forEach { viewController in
            addChild(viewController)
        }
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabsViewControllers.forEach { viewController in
            viewController.removeFromParent()
        }
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        productsCollectionViewHeight = productsCollectionView.bounds.size.height
    }

    private func setupBackgroundColors() {
        view.backgroundColor = .grayBackground
        tabsTopDividerView.backgroundColor = .firstDivider
        tabsBottomDividerView.backgroundColor = .firstDivider
        headerView.backgroundColor = .lightBackground
        segmentedCollectionViewBackground.backgroundColor = .lightBackground
    }

    public func setupHeader() {
        headerView.delegate = headerDelegate
        if userType == .soho {
            headerViewHeight.constant = sohoHeaderViewHeight
            headerView.configure(with: sohoHeaderViewModel)
        } else {
            if headerDelegate?.customView != nil {
                headerViewHeight.isActive = false
                headerView.layoutIfNeeded()
            }
            headerView.configure(with: headerViewModel)
        }
    }

    func setupTabs() {
        if tabsViewControllers.isEmpty {
            tabsViewControllers = [DeviceViewController()]
        } else {
            tabsViewControllers.enumerated().forEach { tabViewController in
                tabViewController.element.rootViewController = self
            }
        }

        if tabsViewControllers.count == 1 {
            segmentedCollectionView.isHidden = true
            tabsStackViewHeight.constant = 0
        } else {
            segmentedCollectionView.isHidden = false
            tabsStackViewHeight.constant = 50
        }
    }

    func createNewTabButton() {
        let modelTitles = tabsViewControllers.map { controller in
            controller.title
        }
        segmentedCollectionView.didTapCell = { [weak self] selectIndex in
            guard let self = self else { return }
            if self.currentIndex < self.tabsViewControllers.count {
                self.selectProductCell(at: selectIndex, animated: false)
                self.tabDelegate?.notifiySegmentedControllerTab()
            }
        }
        segmentedCollectionView.dataSource = SegmentedCollectionDataSource(
            titles: modelTitles,
            startIndex: currentIndex,
            segmentedCellStyle: segmentedCellStyle)
    }

    private func selectProductCell(at index: Int, animated: Bool = true) {
        let indexPath = IndexPath(item: index, section: 0)
        currentIndex = index
        productsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        productsDelegate?.selectTabViewController(at: indexPath)
    }

    private func setupCollectionView() {
        productsCollectionView.contentInset = UIEdgeInsets.zero
        productsCollectionView.scrollIndicatorInsets = UIEdgeInsets.zero
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self

        registerCollectionCell()
        setupSwipeGesture()
    }

    public func reloadProductCollectionViewData() {
        productsCollectionView.reloadData()
    }

    private func setupSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right

        productsCollectionView.addGestureRecognizer(swipeLeft)
        productsCollectionView.addGestureRecognizer(swipeRight)
    }

    private func registerCollectionCell() {
        productsCollectionView.register(
            UINib(
                nibName: productsCollectionCellNibName,
                bundle: Bundle.mva10Framework),
            forCellWithReuseIdentifier: productsCollectionCellId)
    }
}

// MARK: - UICollectionViewDataSource + UICollectionViewDelegate
extension ProductsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return tabsViewControllers.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: productsCollectionCellId,
            for: indexPath) as? ProductsCollectionCell else {
                return UICollectionViewCell()
        }

        let tabViewController = tabsViewControllers[indexPath.row]

        cell.headerHeight = headerView.frame.height + tabsStackViewHeight.constant
        cell.contentController = tabViewController
        cell.delegate = self
        cell.scrollView.isScrollEnabled = enableScrolling ?? true
        // Add tabViewController as a child
        // so, tabViewController's lifecycle called on both:
        //      1- Pushing a viewController on top of the tabViewController (viewWillDisappear)
        //      2- Dismissing pushed viewController (ViewWillAppear)
        addChild(tabViewController)

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ProductsCollectionCell {
            cell.contentController?.view.isHidden = true
        }
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ProductsCollectionCell {
            cell.contentController?.view.isHidden = false
        }
    }
}

// MARK: - ProductsCollectionCellDelegate
extension ProductsViewController: ProductsCollectionCellDelegate {
    func productsTabScrollViewDidScroll(offset: (old: CGPoint, new: CGPoint)) {
        if let enableTabsScrolling = enableTabsScrolling, !enableTabsScrolling {
            return
        }

        guard offset.new.y >= 0 else {
            scrollView.contentOffset.y = 0
            return
        }

        let maxYOffset: CGFloat = userType == .soho ? sohoHeaderMaxYOffset : headerMaxYOffset

        guard offset.new.y <= maxYOffset else {
            scrollView.contentOffset.y = maxYOffset
            return
        }

        guard offset.old.y >= scrollView.contentOffset.y else {
            return
        }

        scrollView.contentOffset.y = offset.new.y
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductsViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: productsCollectionViewHeight)
    }
}

extension ProductsViewController: VFGRefreshViewDelegate {
    public func refreshButtonDidPress() {
        refreshHeaderViewModel?()
        tabsViewControllers.forEach { $0.refresh() }
    }
}

extension ProductsViewController: ProductsHeaderViewDelegate {
    public var customView: UIView? {
        return headerDelegate?.customView
    }
    public func topUpButtonDidPress() {
        headerDelegate?.topUpButtonDidPress()
    }
}

extension ProductsViewController: BaseTabsViewControllerDelegate {
    public func dataFetchingWillStart() {
        headerView.refreshManager?.refreshWillStart()
        dispatchGroup.enter()
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.headerView.refreshManager?.refreshDidSucceed()
        }
    }

    public func dataFetchingDidComplete() {
        dispatchGroup.leave()
    }
}
