//
//  VFGMultiTabsViewController.swift
//  VFGMVA10Foundation
//
//  Created by Moataz Akram on 12/4/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// An enum that represent header size
public enum HeaderStyle {
    case large
    case small
}

/// A view controller that allows a user to add one or more tabs with a header
open class VFGMultiTabsViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var fixedHeaderView: UIView!
    @IBOutlet weak var slidingView: UIView!
    @IBOutlet weak var slidingViewLeading: NSLayoutConstraint!
    @IBOutlet weak var tabsCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var slidingBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewButtons: UIStackView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fixedHeaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tabsStackViewHeight: NSLayoutConstraint!

    private let largeHeaderStyleYOffset: CGFloat = 125.0
    private let smallHeaderStyleYOffset: CGFloat = 90.0
    private var selectedIndex: Int?
    var currentIndex: Int = 0
    public var isSwipeGestureEnabled = false

    private var scrollViewIsDragging = false
    var tabButtons: [VFGButton] = []

    private let multiTabsCollectionCellId = "MultiTabsCollecionViewCellId"
    private let multiTabsCollectionCellNibName = "MultiTabsCollecionViewCell"

    public var headerStyle: HeaderStyle = .large
    public var customHeaderView: MultiTabsHeaderViewProtocol?
    public var headerViewModel: MultiTabsHeaderViewModel?
    public var sohoHeaderViewModel: MultiTabsHeaderViewModel?
    public var tabsViewControllers: [BaseMultiTabsViewController] = []
    public var userType: VFGUserType = .payM
    public weak var headerDelegate: (MultiTabsHeaderViewDelegate & VFGRefreshViewDelegate)?
    public weak var multiTabsDelegate: VFGMultiTabsDelegate?
    public var isHeaderViewFixed = false
    let dispatchGroup = DispatchGroup()

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupCollectionView()
        setupTabs()
        selectTabButton(at: 0)
        setupAccessibility()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = navigationController as? MVA10NavigationController {
            navigationController.hasDivider = false
        }
        scrollView.contentInsetAdjustmentBehavior = .always
    }

    open func updateSubtitleBoldText(with text: String) {
        customHeaderView?.updateSubtitle(text: text)
    }

    func setupAccessibility() {
        tabsCollectionView.isAccessibilityElement = false
        if let headerView = headerView, let stackViewButtons = stackViewButtons {
            accessibilityElements = [headerView, stackViewButtons]
        }
    }

    func setupHeader() {
        guard let headerModel = headerViewModel else {
            headerViewHeight.constant = 0
            headerView.removeFromSuperview()
            return
        }
        if headerStyle == .small {
            headerViewHeight.constant = 90
        }
        let header = customHeaderView ?? VFGMultiTabsHeaderView()
        header.delegate = self
        header.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        header.frame = headerView.bounds
        customHeaderView = header
        header.configure(with: headerModel)
        headerView.addSubview(header)
        fixedHeaderView.isHidden = !isHeaderViewFixed
        guard isHeaderViewFixed else { return }
        fixedHeaderViewHeight.constant = headerViewHeight.constant
        fixedHeaderView.addSubview(header)
    }

    func setupTabs() {
        for subview in stackViewButtons.subviews {
            subview.removeFromSuperview()
        }

        if tabsViewControllers.count <= 1 {
            tabsStackViewHeight.constant = 0
            stackViewButtons.isHidden = true
            slidingView.isHidden = true
            tabsViewControllers = [tabsViewControllers.first ?? VFGBaseMultiTabsViewController()]
            createNewTabButton(
                with: 0,
                title: tabsViewControllers[0].title ?? "")
        } else {
            tabsStackViewHeight.constant = 50
            stackViewButtons.isHidden = false
            slidingView.isHidden = false
            tabsViewControllers.enumerated().forEach { tabViewController in
                tabViewController.element.rootViewController = self
                createNewTabButton(
                    with: tabViewController.offset,
                    title: tabViewController.element.title ?? "")
            }
        }

        slidingBarWidthConstraint?.constant = view.frame.width / CGFloat(tabsViewControllers.count)
    }

    func createNewTabButton(with index: Int, title: String) {
        let button = VFGButton(type: .system)
        button.tag = index
        button.backgroundColor = .clear
        button.frame.size.width = stackViewButtons.frame.width / CGFloat(tabsViewControllers.count)
        button.frame.size.height = stackViewButtons.frame.height
        button.setTitle(title, for: .normal)
        button.isSelected = false
        button.titleLabel?.font = UIFont.vodafoneRegular(16)
        button.setTitleColor(.VFGPrimaryText, for: .normal)
        button.backgroundColor = .clear
        button.accessibilityIdentifier = "tabButton_\(index)"
        stackViewButtons.addArrangedSubview(button)

        tabButtons.append(button)
        button.addTarget(self, action: #selector(tabButtonPressed(sender:)), for: .touchUpInside)
    }

    @objc public func tabButtonPressed(sender: VFGButton) {
        guard sender.tag != selectedIndex else {
            return
        }

        currentIndex = sender.tag
        selectTabButton(at: sender.tag)
        selectTabCell(at: sender.tag)
    }

    private func selectTabButton(at index: Int) {
        guard index != selectedIndex else {
            return
        }

        if let selectedIndex = selectedIndex {
            tabButtons[selectedIndex].isSelected = false
            tabButtons[selectedIndex].titleLabel?.font = UIFont.vodafoneRegular(16)
            tabButtons[selectedIndex].setTitleColor(.VFGPrimaryText, for: .normal)
        }

        tabButtons[index].titleLabel?.font = UIFont.vodafoneBold(16)
        tabButtons[index].setTitleColor(.VFGPrimaryText, for: .selected)

        if selectedIndex != nil {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                let sliderWidth = UIScreen.main.bounds.width / CGFloat(self.tabsViewControllers.count)
                self.slidingViewLeading.constant = CGFloat(index) * sliderWidth
                self.view.layoutIfNeeded()
            }
        }

        tabButtons[index].isSelected = true
        selectedIndex = index
    }

    private func selectTabCell(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        tabsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        multiTabsDelegate?.didSelectTabAt(indexPath: indexPath)
    }

    private func setupCollectionView() {
        tabsCollectionView.contentInset = UIEdgeInsets.zero
        tabsCollectionView.scrollIndicatorInsets = UIEdgeInsets.zero
        tabsCollectionView.delegate = self
        tabsCollectionView.dataSource = self

        registerCollectionCell()
        setupSwipeGesture()
    }

    private func registerCollectionCell() {
        tabsCollectionView.register(
            UINib(
                nibName: multiTabsCollectionCellNibName,
                bundle: Bundle.foundation),
            forCellWithReuseIdentifier: multiTabsCollectionCellId)
    }

    private func setupSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right

        tabsCollectionView.addGestureRecognizer(swipeLeft)
        tabsCollectionView.addGestureRecognizer(swipeRight)
    }

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
        guard isSwipeGestureEnabled else { return }
        if gesture.direction == .left {
            guard currentIndex < tabsViewControllers.count - 1 else { return }
            currentIndex += 1
        } else if gesture.direction == .right {
            guard currentIndex > 0 else { return }
            currentIndex -= 1
        }

        tabsCollectionView.selectItem(
            at: [0, currentIndex],
            animated: true,
            scrollPosition: .centeredVertically
        )
        selectTabButton(at: currentIndex)
    }
}

// MARK: - UICollectionViewDataSource + UICollectionViewDelegate
extension VFGMultiTabsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
            withReuseIdentifier: multiTabsCollectionCellId,
            for: indexPath) as? MultiTabsCollecionViewCell else {
                return UICollectionViewCell()
        }

        let tabViewController = tabsViewControllers[indexPath.row]

        cell.headerHeight = headerViewHeight.constant + tabsStackViewHeight.constant
        cell.contentController = tabViewController
        cell.delegate = self

        // Add tabViewController as a child
        // so, tabViewController's lifecycle called on both:
        //      1- Pushing a viewController on top of the tabViewController (viewWillDisappear)
        //      2- Dismissing pushed viewController (ViewWillAppear)
        addChild(tabViewController)

        return cell
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewIsDragging = true
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollViewIsDragging else {
            return
        }

        slidingViewLeading.constant = scrollView.contentOffset.x / CGFloat(tabsViewControllers.count)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / tabsCollectionView.frame.width)
        selectTabButton(at: index)
        scrollViewIsDragging = false
    }
}

// MARK: - MultiTabsCollectionCellDelegate
extension VFGMultiTabsViewController: MultiTabsCollectionCellDelegate {
    func multiTabScrollViewDidScroll(offset: (old: CGPoint, new: CGPoint)) {
        guard offset.new.y >= 0 else {
            scrollView.contentOffset.y = 0
            return
        }

        let maxYOffset: CGFloat = headerStyle == .small ? smallHeaderStyleYOffset : largeHeaderStyleYOffset

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
extension VFGMultiTabsViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - BaseMultiTabsViewControllerDelegate
extension VFGMultiTabsViewController: BaseMultiTabsViewControllerDelegate {
    public func dataFetchingWillStart() {
        customHeaderView?.refreshManager?.refreshWillStart()
        dispatchGroup.enter()
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.customHeaderView?.refreshManager?.refreshDidSucceed()
        }
    }
    public func dataFetchingDidComplete() {
        dispatchGroup.leave()
    }
}

// MARK: - VFGRefreshViewDelegate
extension VFGMultiTabsViewController: VFGRefreshViewDelegate {
    public func refreshButtonDidPress() {
        tabsViewControllers.forEach { $0.refresh() }
    }
}

// MARK: - MultiTabsHeaderViewDelegate
extension VFGMultiTabsViewController: MultiTabsHeaderViewDelegate {
    public func topUpButtonDidPress() {
        headerDelegate?.topUpButtonDidPress()
    }
}
