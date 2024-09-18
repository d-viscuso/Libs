//
//  VFGDashboardItemsProtocol.swift
//  VFGMVA10Group
//
//  Created by Mahmoud Amer on 8/7/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//
import VFGMVA10Foundation

/// Dashboard items protocol.
public protocol VFGDashboardItemsProtocol: AnyObject {
    /// Dashboard manager delegate.
    var delegate: VFGDashboardManagerProtocol? { get set }
    /// Determine the current dashboard state in each step.
    var state: VFGContentState { get }
    /// Determine the floating tobi behaviour .
    var floatingTOBIModel: VFGMVA12DashboardFloatingTOBIModel? { get }
    /// Set last updated time for dashboard.
    var lastUpdatedTime: Date { get set }
    /// Manager for dashboard refresh
    var refreshManager: VFGRefreshManager? { get }
    var myProductsModel: VFGDashboardMyProductsHeaderModel? { get }
    /// Refresh status model.
    var refreshStatusModel: VFGRefreshStatusModel? { get }
    /// Used to hide/show the refresh view.
    var isRefreshViewHidden: Bool { get }
    /// Returns the section at a specific index.
    /// - Parameters:
    ///     - index: The index of the wanted section.
    func sectionAtIndex(index: Int) -> BaseSectionViewModel?
    /// Returns the card of each item in each section.
    /// - Parameters:
    ///     - indexPath: The IndexPath of the wanted card.
    func cardAtIndex(indexPath: IndexPath) -> BaseItemViewModel?
    /// Returns each section title.
    /// - Parameters:
    ///     - index: The index of the wanted section.
    func titleForSection(at index: Int) -> String
    /// Returns dashbord sections count.
    func numberOfSections() -> Int
    /// Returns items count in each section.
    /// - Parameters:
    ///     - section: The index of the wanted section.
    func numberOfItemsAtSection(section: Int) -> Int
    func removeItem(
        at index: IndexPath,
        completion: (_ isItemRemoved: Bool, _ isSectionRemoved: Bool) -> Void
    )
    /// Responsible for constructing the view controller you wish to present when pressing on a card.
    func didSelectCardAtIndex(indexPath: IndexPath)
    /// function construct your dashboard cards and add them to your dataSource Call the *dashboardItemsSetupFinished* delegate.
    func setup()
    /// Method you can call to fetch the data from the data provider again. Changes the state to loading and when it finishes fetching the data, the state either become *error* if the fetch fails or *populated* if the fetch succeeded.
    func refresh(completion: @escaping (_ error: Error?) -> Void)
    /// Returns dashboard section index.
    func dashboardIndexInSections() -> Int?
    /// Returns discover section index.
    func discoverIndexInSections() -> Int?
    /// Returns seansonal offer section index.
    func seansonalOfferIndexInSections() -> Int?
    /// Returns each section type.
    func typeForSection(at index: Int) -> String?
    /// Returns if header of specific section is visible or not
    func enableHeaderForSection(at index: Int) -> Bool
    /// Returns if footer of specific section is visible or not
    func enableFooterForSection(at index: Int) -> Bool
}

extension VFGDashboardItemsProtocol {
    public var myProductsModel: VFGDashboardMyProductsHeaderModel? {
        nil
    }

    public var floatingTOBIModel: VFGMVA12DashboardFloatingTOBIModel? {
        nil
    }

    public var refreshStatusModel: VFGRefreshStatusModel? {
        VFGDashboardItemsProtocolDefaults.refreshStatusModel
    }

    public var refreshManager: VFGRefreshManager? {
        VFGDashboardItemsProtocolDefaults.refreshManager
    }

    public var isRefreshViewHidden: Bool {
        false
    }

    public func removeItem(
        at index: IndexPath,
        completion: (_ isItemRemoved: Bool, _ isSectionRemoved: Bool) -> Void
    ) {}

    public func refresh(completion: @escaping (_ error: Error?) -> Void) { completion(nil) }
    public func dashboardIndexInSections() -> Int? { nil }
    public func discoverIndexInSections() -> Int? { nil }
    public func seansonalOfferIndexInSections() -> Int? { nil }
    public func typeForSection(at index: Int) -> String? { VFGDashboardCardType.none.rawValue }
    public func enableHeaderForSection(at index: Int) -> Bool { true }
    public func enableFooterForSection(at index: Int) -> Bool { true }
}
