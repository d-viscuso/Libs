//
//  VFGVerticalSubTrayView.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 11/17/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Vertical view for sub tray
public class VFGVerticalSubTrayView: VFGBaseSubtrayView {
    @IBOutlet weak var tabsCollectionView: UICollectionView!
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var tabsCollectionViewSeparator: UIView!
    @IBOutlet weak var collectionViewTop: NSLayoutConstraint?
    @IBOutlet weak var searchTextField: VFGTextField?
    @IBOutlet weak var tabsCollectionViewHeightConstraint: NSLayoutConstraint!

    var numberOfShimmerCells = 6
    var cellWidthToHeightRatio: CGFloat {
        return isSubTrayCustomizable ? CGFloat(0.6) : CGFloat(0.815)
    }
    var tabsCollectionViewHeight: CGFloat = 48
    let cellsPerRow = 2
    let strechedItemExtraSpace: CGFloat = 42
    let expandableItemCellHeight: CGFloat = 69
    var highlightedItemIndex: Int? {
        didSet {
            collectionView?.reloadData()
        }
    }
    lazy var cellWidth: CGFloat = {
        guard let collectionView = collectionView,
            let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        else { return 140 }
        let marginsAndInsets =
            flowLayout.sectionInset.left +
            flowLayout.sectionInset.right +
            flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)

        return itemWidth
    }()
    /// Overridden to update vertical sub tray data
    public override var dataModel: VFGSubTrayModel? {
        didSet {
            if dataModel != nil {
                filteredDataSource = dataModel
                collectionView?.reloadData()
                tabsCollectionView.reloadData()
                changeCategoryTabsVisibility()
                changeSearchViewVisibility()
            }
        }
    }
    /// Filter given items to display only expandable
    var filteredDataSource: VFGSubTrayModel? {
        didSet {
            filteredDataSourceUIModels = filteredDataSource?.items
                .map { $0.map { VFGVerticalSubTrayViewDataSourceItem.item($0) } }

            let expandedItemsWithParentIds = filteredDataSource?.items?
                .filter { $0.isExpandableItem }
                .map { ($0.expandedItems, $0.itemID) }
                .filter { $0.0 != nil && $0.1 != nil }
            let expandedItemsWithParentIdsUIModels =
                expandedItemsWithParentIds.map {
                    $0.map { subItems, id -> [VFGVerticalSubTrayViewDataSourceItem]? in
                        return subItems.map {
                            $0.map { VFGVerticalSubTrayViewDataSourceItem.expandedItem(parentId: id ?? "", $0) }
                        }
                    }
                }
            expandedItemsDataSourceUIModels = []
            expandedItemsWithParentIdsUIModels?.forEach { item in
                if let item = item {
                    expandedItemsDataSourceUIModels.append(contentsOf: item)
                }
            }
            hasExpandedItems = !expandedItemsDataSourceUIModels.isEmpty
        }
    }
    let verticalCellId = "VFGVerticalSubTrayCollectionViewCell"
    let expandedCellId = "VFGSubTrayExpandedItemViewCell"
    let tabsCellId = "VFSubTrayCollectionViewTabsCell"
    private let widthPadding: CGFloat = 16
    /// Index Path for selected category tab
    var selectedTabIndexPath = IndexPath(item: 0, section: 0)
    /// Type of selected category
    var selectedCategory = VFGVerticalSubTrayViewTabCategoryUIModel.all
    /// *searchTextField* text
    var searchQurey = ""
    /// Determine if vertical sub tray items is expandable or not
    var hasExpandedItems = false
    /// Determine if vertical sub tray has categories or not
    var isCategoriesEnabled: Bool {
        guard
            let metaData = dataModel?.metaData,
            let expandedTrayConfiguration =
                metaData["expandedTrayConfiguration"] as? VFGTrayItemModel.VFGTrayItemModelConfiguration,
            let isCategoriesEnabled = expandedTrayConfiguration.isCategoriesEnabled
            else { return false }
        return isCategoriesEnabled
    }
    /// Array list of vertical sub tray filtered items collapsed or expanded
    var filteredDataSourceUIModels: [VFGVerticalSubTrayViewDataSourceItem]?
    /// Array list of vertical sub tray expanded items
    var expandedItemsDataSourceUIModels: [VFGVerticalSubTrayViewDataSourceItem] = []
    /// Array list of vertical sub tray filtered expandable items
    var filteredAndExpandedItemsUIModels: [VFGVerticalSubTrayViewDataSourceItem]? {
        guard
            var items = filteredDataSourceUIModels,
            let highlightedItemIndex = highlightedItemIndex,
            let highlightedItem = items[safe: highlightedItemIndex],
            let highlightedItemId = highlightedItem.item?.itemID
        else { return filteredDataSourceUIModels }

        let expandedItems = expandedItemsDataSourceUIModels.filter { $0.expandedItemParentId == highlightedItemId }
        let lastIndex: Int = (items.lastIndex { $0.item?.isExpandableItem ?? false } ?? 0) + 1
        if lastIndex <= items.count {
            items.insert(contentsOf: expandedItems, at: lastIndex)
        } else {
            items.append(contentsOf: expandedItems)
        }
        return items
    }

    required init(_ title: String, _ subtitle: String, _ onRefresh: @escaping () -> Void) {
        super.init(title, subtitle, onRefresh, UIScreen.main.bounds.height * 0.6)

        commonInit()
        setupVoiceOverAccessibility()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    /// *VFGVerticalSubTrayView* configuration
    func commonInit() {
        guard let contentView = loadViewFromNib(nibName: className) else {
            return
        }

        xibSetup(contentView: contentView)

        let nibShimmerCell = UINib(nibName: shimmerCellId, bundle: Bundle.mva10Framework)
        let nibCell = UINib(nibName: verticalCellId, bundle: Bundle.mva10Framework)
        let nibExpandedCell = UINib(nibName: expandedCellId, bundle: Bundle.mva10Framework)
        let tabCell = UINib(nibName: tabsCellId, bundle: Bundle.mva10Framework)

        collectionView?.register(nibCell, forCellWithReuseIdentifier: verticalCellId)
        collectionView?.register(nibExpandedCell, forCellWithReuseIdentifier: expandedCellId)
        collectionView?.register(nibShimmerCell, forCellWithReuseIdentifier: shimmerCellId)
        tabsCollectionView.register(tabCell, forCellWithReuseIdentifier: tabsCellId)
        subtitleLabel?.text = subtitle?.localized(bundle: .mva10Framework)

        collectionView?.delegate = self
        collectionView?.dataSource = self

        tabsCollectionView.delegate = self
        tabsCollectionView.dataSource = self

        searchTextField?.delegate = self
        searchTextField?.configureTextField(
            topTitleText: "sub_tray_search_hint".localized(bundle: .mva10Framework),
            placeHolder: "sub_tray_search_hint".localized(bundle: .mva10Framework),
            placeHolderColor: .VFGDisabledInputText,
            rightIcon: VFGFrameworkAsset.Image.icSearch)
    }
    /// Configure header view for soho
    /// - Parameters:
    ///    - headerView: Soho header view to add to sub tray
    public func setupHeaderViewForSohoTray(with headerView: UIView) {
        searchTextField?.removeFromSuperview()
        headerStackView?.removeSubviews()
        headerStackView?.addArrangedSubview(headerView)
        headerStackView?.addArrangedSubview(subtitleLabel ?? VFGLabel())
    }
    /// Overridden to update the views in vertical sub tray
    public override func reloadViews() {
        super.reloadViews()
        // Resets highlighted Index
        highlightedItemIndex = nil
        // Resets search field
        resetSearchTextFieldUI()
        // Resets selected tab
        selectedCategory = .all
        selectedTabIndexPath = IndexPath(item: 0, section: 0)
        filteredDataSource = dataModel

        if isCategoriesEnabled {
            showTabsCollectionView()
        }
        tabsCollectionView.reloadData()
        tabsCollectionView?.setContentOffset(.zero, animated: false)
    }
    /// Determine which tabs are visible in shown category
    func changeCategoryTabsVisibility() {
        guard
            let metaData = dataModel?.metaData,
            let expandedTrayConfiguration =
                metaData["expandedTrayConfiguration"] as? VFGTrayItemModel.VFGTrayItemModelConfiguration,
            let isExpandedTrayEnabled = metaData["isExpandedTrayEnabled"] as? Bool,
            let categoriesCountThreshold = expandedTrayConfiguration.categoriesCountThreshold,
            let isCategoriesEnabled = expandedTrayConfiguration.isCategoriesEnabled
            else { return }
        if isCategoriesEnabled &&
            isExpandedTrayEnabled &&
            categories.count >= categoriesCountThreshold {
            tabsCollectionView.isHidden = false
            tabsCollectionViewSeparator.isHidden = false
            collectionViewTop?.isActive = true
        } else {
            tabsCollectionView.isHidden = true
            tabsCollectionViewSeparator.isHidden = true
            collectionViewTop?.isActive = false
        }
    }
    /// Determine if *searchTextField* is hidden or not
    func changeSearchViewVisibility() {
        let metaData = dataModel?.metaData
        let searchConfigurations = metaData?["searchConfigurations"] as? VFGTrayItemModel.VFGTraySearchConfiguration
        let itemCountThreshold = searchConfigurations?.itemCountThreshold ?? 12
        let itemsCount = dataModel?.items?.count ?? 0
        searchTextField?.isHidden = !(itemsCount > itemCountThreshold)
    }
    /// Category tabs collection view cell configuration
    /// - Parameters:
    ///    - indexPath: Index path to inject cell in it
    ///    - cell: Current cell to setup its configuration
    /// - Returns: Sub tray collection view cell for current category tab
    func setupTabsCell(indexPath: IndexPath, cell: VFSubTrayCollectionViewTabsCell) -> VFSubTrayCollectionViewTabsCell {
        guard let itemsCount = dataModel?.items?.count else {
            return VFSubTrayCollectionViewTabsCell()
        }

        cell.setupCell(
            with: indexPath.row == 0 ?
                String(format: categories[indexPath.row], String(itemsCount)) :
                categories[indexPath.row]
        )

        if indexPath == selectedTabIndexPath {
            cell.isSelected()
        } else {
            cell.unSelected()
        }

        return cell
    }
    /// Handle tab press action configuration
    func tabSelected() {
        guard let cell =
            tabsCollectionView.cellForItem(at: selectedTabIndexPath) as? VFSubTrayCollectionViewTabsCell else {
                return
        }

        if selectedTabIndexPath == IndexPath(item: 0, section: 0) {
            filteredDataSource = dataModel
            selectedCategory = .all
            collectionView?.reloadData()
        } else {
            let filteredProducts = dataModel?.items?.filter { $0.category?.localized() == cell.tabTitle.text }
            filteredDataSource?.items = filteredProducts
            selectedCategory = .other(cell.tabTitle.text ?? "")
            collectionView?.reloadData()
        }
        collectionView?.setContentOffset(.zero, animated: true)
    }
    /// Category tabs removal process configuration
    func hideTabsCollectionView() {
        tabsCollectionViewHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.layoutIfNeeded()
        }
        tabsCollectionViewSeparator.isHidden = true
    }
    /// Category tabs addition process configuration
    func showTabsCollectionView() {
        tabsCollectionViewHeightConstraint.constant = tabsCollectionViewHeight
        tabsCollectionView.layoutIfNeeded()
        tabsCollectionView.isHidden = false
        tabsCollectionViewSeparator.isHidden = false
    }
    /// Remove any text from *searchTextField* and add search icon
    func resetSearchTextFieldUI() {
        searchTextField?.textFieldRightIcon = VFGFrameworkAsset.Image.icSearch
        searchTextField?.resetTextField()
        searchQurey = ""
    }
}
