//
//  VFGFilterView.swift
//  VFGMVA10Foundation
//
//  Created by Esraa Eldaltony on 11/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// A view that use to filter between list of categories
public class VFGFilterView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!

    // MARK: - Constants
    public var estimatedCategorySize = CGSize(width: 100, height: 35) {
        didSet {
            guard let flowLayout = categoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
                return
            }
            flowLayout.estimatedItemSize = estimatedCategorySize
        }
    }
    public var filterViewShimmerCellsCount = 5
    let categoryIntermidiateSpacing: CGFloat = 12.0
    let categoryCellNibName = "VFGFilterCell"
    let categoryCellShimmerNibName = "VFGFilterCellShimmer"
    let categoryCellId = "VFGFilterCellId"
    let categoryCellShimmerId = "VFGFilterCellShimmerId"
    public var filterCollectionView: UICollectionView?
    /// A Color for un selected items
    public var filterUnselectedBackgroundColor: UIColor?
    // A color for unSelected item's border
    public var filterUnselectedBorderColor: UIColor? = .clear
    /// A Boolean that use to allow multi selection or single selection
    public var allowsMultipleSelection = true {
        didSet {
            categoryCollectionView.allowsMultipleSelection = allowsMultipleSelection
        }
    }
    /// A Boolean that use to show shimmer loading or populated content
    public var triggerShimmerMode = false {
        didSet {
            categoryCollectionView.reloadData()
            filterCollectionView?.isScrollEnabled = !triggerShimmerMode
        }
    }
    /// Categories that showed in filter items list
    public var categories: [String] = [] {
        didSet {
            categoryCollectionView.reloadData()
            guard !categories.isEmpty else { return }
            categoryCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: [])
        }
    }
    /// Categories that user select them
    public var selectedCategories: [String] = []
    /// Delegate for filter items list 
    public weak var collectionViewDelegate: UICollectionViewDelegate? {
        didSet {
            categoryCollectionView.delegate = collectionViewDelegate
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    // MARK: - xib Setup
    func xibSetup() {
        view = loadViewFromNib(nibName: "VFGFilterView")
        xibSetup(contentView: view)
        setupCategoriesCollectionView()
    }
}
// MARK: - Collection View Data Source
extension VFGFilterView: UICollectionViewDataSource {
    func setupCategoriesCollectionView() {
        categoryCollectionView.dataSource = self
        categoryCollectionView.isScrollEnabled = true
        categoryCollectionView.allowsMultipleSelection = allowsMultipleSelection

        let flowLayout = VFGCollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = estimatedCategorySize
        flowLayout.minimumInteritemSpacing = categoryIntermidiateSpacing
        categoryCollectionView.setCollectionViewLayout(flowLayout, animated: false)
        categoryCollectionView.contentInset = UIEdgeInsets.zero

        let categoryCell = UINib(nibName: categoryCellNibName, bundle: .foundation)

        let categoryShimmerCell = UINib(nibName: categoryCellShimmerNibName, bundle: .foundation)
        categoryCollectionView.register(
            categoryCell,
            forCellWithReuseIdentifier: categoryCellId)
        categoryCollectionView.register(
            categoryShimmerCell,
            forCellWithReuseIdentifier: categoryCellShimmerId)
        filterCollectionView = categoryCollectionView
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return triggerShimmerMode ? filterViewShimmerCellsCount : categories.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        return filterCollectionViewCell(at: indexPath)
    }
}
// MARK: - Configure selected cell
extension VFGFilterView {
    /// configure the cell which have been selected
    /// - Parameters:
    ///   - indexPath: indexPath for the selected item
    func filterCollectionViewCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let shimmerCell = categoryCollectionView.dequeueReusableCell(
            withReuseIdentifier: categoryCellShimmerId,
            for: indexPath) as? VFGFilterCellShimmer

        if triggerShimmerMode {
            shimmerCell?.startShimmer()
            return shimmerCell ?? VFGFilterCellShimmer()
        } else {
            shimmerCell?.stopShimmer()

            guard
                let cell = categoryCollectionView.dequeueReusableCell(
                    withReuseIdentifier: categoryCellId,
                    for: indexPath) as? VFGFilterCell else {
                return UICollectionViewCell()
            }

            let type = categories[indexPath.row]
            cell.categoryType = type
            cell.nameLabel.accessibilityIdentifier = "Flabel\(indexPath.row)"
            cell.filterUnselectedBorderColor = filterUnselectedBorderColor ?? .clear
            cell.filterUnselectedBackgroundColor = filterUnselectedBackgroundColor ?? .VFGFilterUnselectedBg
            cell.isSelected = selectedCategories.contains(type)
            return cell
        }
    }
    /// configure the selected cell 
    /// - Parameters:
    ///   - indexPath: indexPath for the selected item
    public func selectCell(at index: IndexPath) {
        categoryCollectionView.selectItem(at: index, animated: true, scrollPosition: [])
    }
    /// configure the unselected cell
    /// - Parameters:
    ///   - indexPath: indexPath for the unselected item
    public func deselectCell(at index: IndexPath) {
        categoryCollectionView.deselectItem(at: index, animated: true)
    }
}
