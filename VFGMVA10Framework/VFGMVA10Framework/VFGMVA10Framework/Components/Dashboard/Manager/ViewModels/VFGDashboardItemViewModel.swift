//
//  VFGDashboardItemViewModel.swift
//  VFGMVA10
//
//  Created by Mahmoud Amer on 1/15/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

enum VFConnectedAppsItemMetaDataKeys {
    static let subItems = "subItems"
}
/// Dashboard item view model
public class VFGDashboardItemViewModel: BaseItemViewModel {
    private enum Const {
        static let subItemHeight: CGFloat = 58.0
        static let collectionInsets: CGFloat = 30.0
        static let fixedHeightWidthRatio: CGFloat = 0.56
    }

    let itemMargins: CGFloat = 16
    var showMoreHeight: CGFloat = 0
    var minNumberOfItems: Int
    var maxNumberOfItems: Int = 6
    /// An instance of *VFGDashboardItemViewModelDelegate*
    weak var delegate: VFGDashboardItemViewModelDelegate?
    /// *VFGDashboardItemViewModel* initializer
    /// - Parameters:
    ///    - item: Item model data
    ///    - minNumberOfItems: Minimum number of items allowed to display on dashboard
    public init?(componentEntry: VFGComponentEntry? = nil, item: VFGDashboardItem, minNumberOfItems: Int = 3) {
        self.minNumberOfItems = minNumberOfItems
        super.init()

        if let componentEntry = componentEntry {
            self.componentEntry = componentEntry
        } else if let entry = VFGManagerFramework.dashboardDelegate?.targetComponentEntries.component(
            with: item.componentId,
            metaData: item.metaData,
            error: item.error) {
            self.componentEntry = entry
        } else {
            return nil
        }

        data = item

        actionBasedOnItem(item)
    }

    private func genericComponentEntry(item: VFGDashboardItem) {
        guard let actualHeight = componentEntry?.cardView?.frame.height else {
            itemHeight = UIScreen.main.bounds.width - Const.collectionInsets
            return
        }
        if actualHeight == 0 {
            itemHeight = (UIScreen.main.bounds.width - Const.collectionInsets) * Const.fixedHeightWidthRatio
        } else {
            let padding = Constants.dashboardCollectionPadding * 2
            let isMaximumHeightDisabled = componentEntry?.isMaximumHeightDisabled ?? false
            if actualHeight < Constants.genericMaximumHeight || isMaximumHeightDisabled {
                itemHeight = actualHeight + padding
            } else {
                itemHeight = Constants.genericMaximumHeight + padding
            }
        }
    }

    private func editorialComponentEntry(item: VFGDashboardItem) {
        guard let groupEntry = componentEntry as? VFDashboardListEntryProtocol else {
            return
        }
        groupEntry.item = item
        let padding = Constants.dashboardCollectionPadding * 2
        guard let frameHeight = componentEntry?.cardView?.frame.height else {
            return
        }
        itemHeight = frameHeight + padding
    }

    private func upgradeComponentEntry(item: VFGDashboardItem) {
        guard let upgradeEntry = componentEntry as? VFDashboardListEntryProtocol else {
            return
        }
        upgradeEntry.item = item
        let padding = Constants.dashboardCollectionPadding * 2
        guard let frameHeight = componentEntry?.cardView?.frame.height else {
            return
        }
        itemHeight = frameHeight + padding
    }

    private func storyComponentEntry(item: VFGDashboardItem) {
        guard let cardView = componentEntry?.cardView as? VFGStoryContainerCard else {
            return
        }
        self.padding = 2 * -Constants.dashboardCollectionPadding
        let padding = self.padding * -1
        isShadowEnabled = false
        if cardView.storiesLayout == .card {
            itemHeight = 0
            cardView.collectionViewHeightCompletion = { [weak self] collectionViewHeight in
                var totalViewHeight = collectionViewHeight
                if totalViewHeight != 0 {
                    totalViewHeight += padding
                }
                self?.itemHeight = totalViewHeight
                self?.delegate?.reloadDashboardCollectionView()
            }
        } else {
            itemHeight = cardView.cellHeight ?? 0 + padding
        }
    }

    private func showItems(
        item: VFGDashboardItem,
        count: Int,
        isExpanded: Bool
    ) -> VFGDashboardItem {
        var newItem = item
        let subItemsKey = (item.componentId == "group") ?
            VFGroupedItemMetaDataKeys.subItems : VFGRelatedAppsMetaDataKeys.subItems
        let subItems = item.value(for: subItemsKey) as? [VFGSubItem]
        switch count {
        case ...minNumberOfItems:
            if let subItems = subItems, !(subItems.isEmpty) {
                newItem.sliceSubItemsArray(from: 0, to: subItems.count - 1)
            }
        case minNumberOfItems...maxNumberOfItems where isExpanded:
            newItem.sliceSubItemsArray(from: 0, to: count - 1)
        case maxNumberOfItems... where isExpanded:
            newItem.sliceSubItemsArray(from: 0, to: maxNumberOfItems - 1)
        default:
            newItem.sliceSubItemsArray(from: 0, to: minNumberOfItems - 1)
        }
        return newItem
    }

    private func listItemEntry(item: VFGDashboardItem) {
        guard let groupEntry = componentEntry as? VFDashboardListEntryProtocol else {
            return
        }
        isShadowEnabled = false
        let subItemsKey = (item.componentId == "group") ?
            VFGroupedItemMetaDataKeys.subItems : VFGRelatedAppsMetaDataKeys.subItems
        let subItems = item.value(for: subItemsKey) as? [VFGSubItem]
        let count = subItems?.count ?? 0
        groupEntry.hasShowMore = count > minNumberOfItems ? true : false
        groupEntry.item = showItems(item: item, count: count, isExpanded: false)
        let hasShowMore = groupEntry.hasShowMore ?? false
        showMoreHeight = hasShowMore ? (groupEntry.showMoreHeight ?? 0) : 0
        groupEntry.showMoreAction = { [weak self, weak groupEntry] isExpanded in
            guard let self = self else { return }
            if let groupEntry = groupEntry {
                groupEntry.item = self.showItems(item: item, count: count, isExpanded: isExpanded)
                self.updateItemHeight(
                    showMoreIsExpanded: isExpanded,
                    showMoreHeight: self.showMoreHeight,
                    item: groupEntry.item)
            }
            self.delegate?.reloadDashboardCollectionView()
        }
        updateItemHeight(showMoreIsExpanded: false, showMoreHeight: showMoreHeight, item: groupEntry.item)
    }

    private func seasonsalOfferEntry(item: VFGDashboardItem) {
        guard let cardView = componentEntry?.cardView as? VFGSeasonalOffersCardView else {
            genericComponentEntry(item: item)
            return
        }
        cardView.item = item
        genericComponentEntry(item: item)
    }

    private func scrollableCardEntry(item: VFGDashboardItem) {
        guard let cardView = componentEntry?.cardView as? ScrollableCardView else {
            return
        }
        self.padding = 2 * -Constants.dashboardCollectionPadding
        isShadowEnabled = false
        itemHeight = cardView.cardHeight
    }

    private func scrollableCTACardEntry(item: VFGDashboardItem) {
        guard let cardView = componentEntry?.cardView as? BannerCTACardsView else {
            genericComponentEntry(item: item)
            return
        }
        self.padding = 2 * -Constants.dashboardCollectionPadding
        let padding = self.padding * -1
        isShadowEnabled = false
        itemHeight = cardView.cardHeight + padding
    }

    private func horizonatalScrollableCardsEntry(item: VFGDashboardItem) {
        guard let cardView = componentEntry?.cardView as? HorizontalCarouselCardsView else {
            return
        }
        self.padding = 2 * -Constants.dashboardCollectionPadding
        isShadowEnabled = false
        itemHeight = cardView.cardHeight
    }

    private func horizontalDiscoverEntry(item: VFGDashboardItem) {
        guard let cardView = componentEntry?.cardView as? HorizontalDiscoverView else {
            genericComponentEntry(item: item)
            return
        }
        self.padding = 2 * -Constants.dashboardCollectionPadding
        let padding = self.padding * -1
        isShadowEnabled = false
        itemHeight = 0
        cardView.collectionViewHeightCompletion = { [weak self] collectionViewHeight in
            var totalViewHeight = collectionViewHeight
            if totalViewHeight != 0 {
                totalViewHeight += padding
            }
            self?.itemHeight = totalViewHeight
            self?.delegate?.reloadDashboardCollectionView()
        }
    }

    private func marketplaceEntry(item: VFGDashboardItem) {
        guard let marketplaceView = componentEntry?.cardView as? VFGMarketplaceView else {
            genericComponentEntry(item: item)
            return
        }
        padding = 2 * -Constants.dashboardCollectionPadding
        isShadowEnabled = false
        itemHeight = marketplaceView.itemSize.height + 16
    }

    private func loginTilesEntry(item: VFGDashboardItem) {
        guard let loginTilesView = componentEntry?.cardView as? VFGLoginTilesView else {
            genericComponentEntry(item: item)
            return
        }
        isShadowEnabled = false
        itemHeight = loginTilesView.frame.height + 2 * Constants.dashboardCollectionPadding
    }

    private func superAppCategoriesEntry(item: VFGDashboardItem) {
        guard let cardView = componentEntry?.cardView as? VFGCategoriesView else {
            genericComponentEntry(item: item)
            return
        }
        self.padding = 2 * -Constants.dashboardCollectionPadding
        let padding = self.padding * -1
        isShadowEnabled = false

        cardView.cardViewHeightCompletion = { [weak self] cardHeight in
            self?.itemHeight = cardHeight + (cardHeight != 0 ? padding : 0)
            self?.delegate?.reloadDashboardCollectionView()
        }
    }

    private func productsCardEntry(item: VFGDashboardItem) {
        guard let cardView = componentEntry?.cardView as? ProductSwitcherCardView else {
            return
        }
        self.padding = 2 * -Constants.dashboardCollectionPadding
        isShadowEnabled = false
        itemHeight = cardView.cardHeight
        cardView.cardViewHeightCompletion = { [weak self] cardHeight in
            self?.itemHeight = cardHeight
            self?.delegate?.reloadDashboardCollectionView()
        }
    }

    private func otherVodafoneAppsEntry(item: VFGDashboardItem) {
        guard let cardView = componentEntry?.cardView as? OtherVodafoneAppsView else {
            return
        }
        isShadowEnabled = false
        itemHeight = cardView.cardHeight + itemMargins
        cardView.cardHeightDidChange = { [weak self] _ in
            guard let self = self else { return }
            self.itemHeight = cardView.cardHeight + self.itemMargins
            self.delegate?.reloadDashboardCollectionView()
        }
    }

    private func gallaryListComponentEntry(item: VFGDashboardItem) {
        guard let cardView = componentEntry?.cardView as? GalleryListCustomView else {
            return
        }
        self.padding = 2 * -Constants.dashboardCollectionPadding
        isShadowEnabled = false
        itemHeight = (cardView.cardHeight ?? 0) - self.padding
    }
}
/// Delegation protocol for *VFGDashboardItemViewModel*
protocol VFGDashboardItemViewModelDelegate: AnyObject {
    /// Responsible for reloading dashboard screen collection view
    func reloadDashboardCollectionView()
}

extension VFGDashboardItemViewModel {
    func actionBasedOnItem(_ item: VFGDashboardItem) {
        switch item.componentId {
        case _ where item.componentId.contains("group"), "connected-apps":
            listItemEntry(item: item)
        case _ where item.componentId.contains("editorial"):
            editorialComponentEntry(item: item)
        case "upgrade_component":
            upgradeComponentEntry(item: item)
        case "scrollable-cta-card":
            scrollableCTACardEntry(item: item)
        case "story-card-component",
            "story-circle-component",
            "load-component-stories-card":
            storyComponentEntry(item: item)
        case "funFacts":
            funFactComponentEntry(item: item)
        case "seasonal-offer-card":
            seasonsalOfferEntry(item: item)
        case "scrollable-card",
            "load-component-scrollable-card":
            scrollableCardEntry(item: item)
        case "horizontal-scrollable-cards",
            "horizontal-discover",
            "super-app-categories",
            "product-switcher",
            "marketplace-products",
            "login-tiles-card",
            "other-vodafone-apps",
            "gallery-list":
            moreActionsBasedOnItem(item)
        default:
            genericComponentEntry(item: item)
        }
    }

    func moreActionsBasedOnItem(_ item: VFGDashboardItem) {
        switch item.componentId {
        case "horizontal-scrollable-cards":
            horizonatalScrollableCardsEntry(item: item)
        case "horizontal-discover":
            horizontalDiscoverEntry(item: item)
        case "super-app-categories":
            superAppCategoriesEntry(item: item)
        case "product-switcher":
            productsCardEntry(item: item)
        case "marketplace-products":
            marketplaceEntry(item: item)
        case "login-tiles-card":
            loginTilesEntry(item: item)
        case "other-vodafone-apps":
            otherVodafoneAppsEntry(item: item)
        case "gallery-list":
            gallaryListComponentEntry(item: item)
        default:
            genericComponentEntry(item: item)
        }
    }

    /// Responsible for updating item height when expanding or collapsing
    /// - Parameters:
    ///    - showMoreIsExpanded: Determine whether item is expanded or not after pressing show more button
    ///    - showMoreHeight: Show more button height
    ///    - item: Selected item to update its height
    func updateItemHeight(showMoreIsExpanded: Bool, showMoreHeight: CGFloat, item: VFGDashboardItem?) {
        let subItemsKey = (item?.componentId == "group") ?
            VFGroupedItemMetaDataKeys.subItems : VFGRelatedAppsMetaDataKeys.subItems
        guard let subItems = item?.value(for: subItemsKey) as? [VFGSubItem] else {
            return
        }
        var subItemsCount = subItems.count
        subItemsCount = (subItemsCount > minNumberOfItems && !showMoreIsExpanded) ? minNumberOfItems : subItemsCount
        itemHeight = (CGFloat(subItemsCount) * Const.subItemHeight) + showMoreHeight + itemMargins
    }

    private func funFactComponentEntry(item: VFGDashboardItem) {
        itemHeight = 0
        isShadowEnabled = false
    }
}
