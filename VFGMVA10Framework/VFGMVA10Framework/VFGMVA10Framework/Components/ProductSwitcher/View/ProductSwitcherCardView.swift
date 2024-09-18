//
//  ProductSwitcherView.swift
//  VFGMVA10Framework
//
//  Created by Tuncel, Pelin, Vodafone on 8/10/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

public class ProductSwitcherCardView: UIView {
    @IBOutlet weak var filtersStackView: UIStackView!
    @IBOutlet weak var addressFilterHolderView: UIView!
    @IBOutlet weak var searchHolderView: UIView!
    @IBOutlet weak var categoriesFilterView: VFGFilterView!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    lazy var addressFilterView: ProductSwitcherAddressFilterView? = {
        guard let view: ProductSwitcherAddressFilterView = UIView.loadXib(bundle: .mva10Framework)
        else { return nil }
        view.frame = CGRect(x: 0, y: 0, width: filtersStackView.frame.size.width, height: addressFilterHeight)
        return view
    }()
    lazy var searchView: ProductSwitcherSearchView? = {
        guard let view: ProductSwitcherSearchView = UIView.loadXib(bundle: .mva10Framework)
        else { return nil }
        view.frame = CGRect(x: 0, y: 0, width: filtersStackView.frame.size.width, height: searchFilterHeight)
        view.delegate = self
        return view
    }()

    /// card height constant, this height can be changed due to other elements that are gonna be added in the stack view in future developments
    var cardHeight: CGFloat {
        var height: CGFloat = cellHeight + (2 * Constants.dashboardCollectionPadding)
        guard let viewModel = viewModel else { return height }
        if viewModel.isAddressFilterEnabled {
            height += addressFilterHeight + filterViewMargin
        }
        if viewModel.isSearchEnabled {
            height += searchFilterHeight + filterViewMargin
        }
        if viewModel.isCategoryFilterEnabled {
            height += categoryFilterHeight + filterViewMargin
        }
        if !viewModel.isAddressFilterEnabled,
            !viewModel.isSearchEnabled,
            !viewModel.isCategoryFilterEnabled {
            height += filterViewMargin
        }
        return height
    }
    /// A completion handler that returns the dashboard product switcher height.
    var cardViewHeightCompletion: ((CGFloat) -> Void)?
    /// Address Filter height
    let addressFilterHeight: CGFloat = 60
    /// Category Filter height
    let searchFilterHeight: CGFloat = 72
    /// Category Filter height
    let categoryFilterHeight: CGFloat = 35
    /// Filter cell height
    let filterViewMargin: CGFloat = 24
    /// cell height constant
    let cellHeight: CGFloat = 250
    /// default card margin constant
    let cardMargin: CGFloat = 16
    /// margin for collection cell shadow when filter is hidden
    let shadowMargin: CGFloat = 12

    public var viewModel: ProductSwitcherCardViewModelProtocol?

    public override func awakeFromNib() {
        super.awakeFromNib()
        setupCategoriesFilterView()
        setupCollectionView()
    }

    func hideStackView() {
        filtersStackView.isHidden = true
        productsCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: shadowMargin).isActive = true
        cardViewHeightCompletion?(cellHeight + cardMargin + shadowMargin)
    }

    func showStackView() {
        filtersStackView.isHidden = false
        productsCollectionView.topAnchor
            .constraint(equalTo: filtersStackView.bottomAnchor, constant: filterViewMargin).isActive = true
        cardViewHeightCompletion?(cardHeight)
    }

    public func setViewModel(_ viewModel: ProductSwitcherCardViewModel?) {
        self.viewModel = viewModel
        self.viewModel?.updateStatus = { [weak self] in
            self?.productsCollectionView.reloadData()
        }
        configureFilterViews()
        productsCollectionView.reloadData()
    }

    private func setupCategoriesFilterView() {
        let insets = UIEdgeInsets(top: 0, left: cardMargin, bottom: 0, right: 0)
        categoriesFilterView?.filterCollectionView?.contentInset = insets
        categoriesFilterView.filterUnselectedBorderColor = .VFGPrimaryText
        categoriesFilterView?.collectionViewDelegate = self
    }

    private func setupCollectionView() {
        productsCollectionView.clipsToBounds = false
        productsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        productsCollectionView.dataSource = self
        productsCollectionView.delegate = self

        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        productsCollectionView.collectionViewLayout = collectionLayout
        productsCollectionView.decelerationRate = .fast
        productsCollectionView.backgroundColor = .clear
        productsCollectionView.register(
            UINib(
                nibName: ProductSwitcherCollectionCell.reuseIdentifier,
                bundle: Bundle.mva10Framework),
            forCellWithReuseIdentifier: ProductSwitcherCollectionCell.reuseIdentifier)
        productsCollectionView.register(
            UINib(
                nibName: ProductSwitcherNoResultCell.reuseIdentifier,
                bundle: Bundle.mva10Framework),
            forCellWithReuseIdentifier: ProductSwitcherNoResultCell.reuseIdentifier)
        productsCollectionView.register(
            UINib(
                nibName: ProductSwitchErrorCell.reuseIdentifier,
                bundle: Bundle.mva10Framework),
            forCellWithReuseIdentifier: ProductSwitchErrorCell.reuseIdentifier)
        productsCollectionView.register(
            UINib(
                nibName: ProductSwitcherShimmerCell.reuseIdentifier,
                bundle: Bundle.mva10Framework),
            forCellWithReuseIdentifier: ProductSwitcherShimmerCell.reuseIdentifier)
    }

    private func configureFilterViews() {
        configureAddressFilterView()
        configureSearchView()
        configureCategoryFilterView()
    }

    private func configureAddressFilterView() {
        guard let viewModel = viewModel,
            viewModel.isAddressFilterEnabled,
            let addressFilterView = addressFilterView
        else {
            addressFilterHolderView.isHidden = true
            return
        }
        addressFilterHolderView.isHidden = false
        if addressFilterView.superview == nil {
            addressFilterHolderView.addSubview(addressFilterView)
        }

        let filters = viewModel.getAddressFilters()
        addressFilterView.configure(addressList: filters, delegate: self)

        guard let firstAddress = filters.first else { return }
        addressFilterDidSelect(address: firstAddress)
    }

    private func configureSearchView() {
        guard let viewModel = viewModel,
            viewModel.isSearchEnabled,
            let searchView = searchView
        else {
            searchHolderView.isHidden = true
            return
        }
        searchHolderView.isHidden = false
        if searchView.superview == nil {
            searchHolderView.addSubview(searchView)
        }
    }

    private func configureCategoryFilterView() {
        guard let viewModel = viewModel,
            viewModel.isCategoryFilterEnabled
        else {
            categoriesFilterView.isHidden = true
            return
        }
        categoriesFilterView.isHidden = false
        let filters = viewModel.getCategoryFilters()
        categoriesFilterView.selectedCategories = [viewModel.allCategoryText]
        categoriesFilterView.categories = filters
    }

    private func updateCategoryFilters(with filters: [String]) {
        guard let viewModel = viewModel,
            viewModel.isCategoryFilterEnabled
        else { return }

        categoriesFilterView.selectedCategories = [viewModel.allCategoryText]
        categoriesFilterView.categories = filters
        resetCategoryFilters()
    }
}

// MARK: - ProductSwitcherAddressFilterViewDelegate
extension ProductSwitcherCardView: ProductSwitcherAddressFilterViewDelegate {
    func addressFilterDidSelect(address: String) {
        guard let viewModel = viewModel else { return }
        // Filter view model cards
        viewModel.filterFor(address: address)
        // Update Category filters
        viewModel.updateAllCategoryText()
        updateCategoryFilters(with: viewModel.getCategoryFilters())
        // Reload results
        reloadForFilteredProducts()
    }
}

// MARK: - Filter Handling
extension ProductSwitcherCardView {
    func filterCardsWith(categoryName: String) {
        guard let filterView = categoriesFilterView,
            let filterCollectionView = filterView.filterCollectionView,
            let viewModel = viewModel
        else { return }
        // Deselect All
        if filterView.selectedCategories.contains(viewModel.allCategoryText) {
            deselectItem(filterCollectionView, indexPath: IndexPath(item: 0, section: 0))
            filterView.selectedCategories = []
        }
        // If All is selected then deselect other items
        if categoryName == viewModel.allCategoryText {
            for index in 1..<filterCollectionView.numberOfItems(inSection: 0) {
                deselectItem(filterCollectionView, indexPath: IndexPath(item: index, section: 0))
            }
            filterView.selectedCategories = []
        }
        // Add new filter tor selected categories
        filterView.selectedCategories.append(categoryName)

        viewModel.filterFor(categories: filterView.selectedCategories)
        reloadForFilteredProducts()
    }

    func resetFiltering(for category: String) {
        guard let filterView = categoriesFilterView,
            let viewModel = viewModel
        else { return }
        filterView.selectedCategories.removeAll { selectedCategory in
            selectedCategory == category
        }
        if filterView.selectedCategories.isEmpty {
            resetCategoryFilters()
        }

        viewModel.filterFor(categories: filterView.selectedCategories)
        reloadForFilteredProducts()
    }

    private func resetCategoryFilters() {
        guard let filterView = categoriesFilterView,
            let filterCollectionView = filterView.filterCollectionView,
            let viewModel = viewModel
        else { return }
        // Deselect all category filters
        if filterCollectionView.numberOfItems(inSection: 0) > 0 {
            for index in 1..<filterCollectionView.numberOfItems(inSection: 0) {
                deselectItem(filterCollectionView, indexPath: IndexPath(item: index, section: 0))
            }
        }
        // Select only All filter
        let allIndexPath = IndexPath(item: 0, section: 0)
        filterCollectionView.cellForItem(at: allIndexPath)?.isSelected = true
        filterView.selectedCategories = [viewModel.allCategoryText]
        filterView.selectCell(at: allIndexPath)
    }

    private func reloadForFilteredProducts() {
        guard let viewModel = viewModel else { return }
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            guard let self = self else { return }
            if viewModel.numberOfCards > 0 {
                self.productsCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
            }
        }
        productsCollectionView.reloadData()
        CATransaction.commit()
    }

    private func deselectItem(_ collectionView: UICollectionView, indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.isSelected = false
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

extension ProductSwitcherCardView: ProductSwitcherSearchViewDelegate {
    func searchTextChanged(text: String, isRecommendedSearch: Bool) {
        // Filter for searched query
        guard let resultCount = viewModel?.filterFor(query: text),
            let viewModel = viewModel
        else { return }
        // This call back can be made from ProductSwitcherNoResultCell
        // For suggested query searches
        // Thus search field must be updated accordingly
        if isRecommendedSearch {
            searchView?.searchTextField.text = text
        }
        // Display result text
        searchView?.showResult(query: text, resultCount: resultCount)
        viewModel.updateAllCategoryText()
        // Update Category filters
        var filters = viewModel.getCategoryFilters()
        if resultCount == 0 {
            filters = []
        }
        updateCategoryFilters(with: filters)
        // Reload for search result cards
        reloadForFilteredProducts()
    }
}
