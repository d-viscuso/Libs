//
//  VFGDashboardModel.swift
//  VFGMVA10Group
//
//  Created by Mahmoud Amer on 8/8/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//
import Foundation
import VFGMVA10Foundation

/// Dashboard model. Conforms *VFGDashboardItemsProtocol*.
public class VFGDashboardModel: VFGDashboardItemsProtocol {
    public var state: VFGContentState = .empty {
        didSet {
            switch state {
            case .loading:
                refreshManager?.refreshWillStart()
            case .populated:
                refreshManager?.refreshDidSucceed()
            default:
                refreshManager?.refreshDidFail()
            }
        }
    }

    public var lastUpdatedTime = Date() {
        didSet {
            userDefaults.dashboardLastUpdatedTime = lastUpdatedTime
        }
    }

    weak public var delegate: VFGDashboardManagerProtocol?

    var userDefaults = UserDefaults.standard
    /// Dashboard screen sections
    var sections: [BaseSectionViewModel]
    /// Dashboard screen data URL
    var dataStringUrl: String
    /// Dashboard screen data provider
    let dataProvider: VFGDashboardDataProviderProtocol
    /// Dashboard my products header model.
    public var dashboardMyProductsHeaderModel: VFGDashboardMyProductsHeaderModel?
    public var myProductsModel: VFGDashboardMyProductsHeaderModel? {
        dashboardMyProductsHeaderModel
    }
    /// *VFGDashboardModel* initializer based on URL and data provider
    /// - Parameters:
    ///    - stringURL: Dashboard screen data url (optional)
    ///    - dataProvider: Dashboard screen data provider
    public init?(
        stringURL: String? = Constants.dashboardItemsURL?.absoluteString ?? "",
        dataProvider: VFGDashboardDataProviderProtocol
    ) {
        guard let dashboardItemUrl = stringURL else {
            VFGErrorLog("Failed to create model with:\(stringURL ?? "")")
            return nil
        }
        dataStringUrl = dashboardItemUrl
        sections = []
        self.dataProvider = dataProvider
        refreshManager?.refreshStatusModel = refreshStatusModel ?? VFGRefreshStatusModel()
    }
    /// *VFGDashboardModel* initializer based on URL and data provider
    /// - Parameters:
    ///    - stringURL: Dashboard screen data url (required)
    ///    - dataProvider: Dashboard screen data provider
    public init?(
        stringURL: String,
        dataProvider: VFGDashboardDataProviderProtocol
    ) {
        sections = []
        dataStringUrl = stringURL
        self.dataProvider = dataProvider
        refreshManager?.refreshStatusModel = refreshStatusModel ?? VFGRefreshStatusModel()
    }
    /// *VFGDashboardModel* initializer based on model and data provider
    /// - Parameters:
    ///    - model: Dashboard screen data model
    ///    - dataProvider: Dashboard screen data provider
    public init(
        model: [BaseSectionViewModel],
        dataProvider: VFGDashboardDataProviderProtocol
    ) {
        sections = model
        dataStringUrl = ""
        self.dataProvider = dataProvider
        refreshManager?.refreshStatusModel = refreshStatusModel ?? VFGRefreshStatusModel()
    }

    public func setup() {
        setup(completion: nil)
    }
    /// Dashboard screen data request
    /// - Parameters:
    ///    - completion: A closure to hold data array of sections in case of request succeeded
    public func setup(completion: (([BaseSectionViewModel]?) -> Void)?) {
        if dataStringUrl.isEmpty {
            let error = URLError(.cannotFindHost)
            notify(error)
        } else {
            state = .loading
            dataProvider.requestData(with: dataStringUrl) { [weak self] sections, error in
                guard let self = self else {
                    return
                }

                guard error == nil else {
                    self.state = .error
                    if let sections = sections {
                        self.sections = sections
                    }
                    self.notify(error)
                    return
                }

                if let sections = sections {
                    self.sections = sections
                    self.state = .populated
                    self.setLastUpdatedTime(with: ProcessInfo.processInfo.environment["timeTravelInterval"])

                    if let completion = completion {
                        completion(sections)
                    }
                    self.notify()
                } else {
                    self.notify(error)
                }
            }
        }
    }
    /// Determine dashboard screen last updated time
    /// - Parameters:
    ///    - timeTravelInterval: Last time dashboard screen was updated
    func setLastUpdatedTime(with timeTravelInterval: String? = nil) {
        if let timeTravelInterval = Double(JSONString: timeTravelInterval) {
            lastUpdatedTime = Date().addingTimeInterval(timeTravelInterval)
        } else {
            lastUpdatedTime = Date()
        }
    }

    public func refresh(completion: @escaping (_ error: Error?) -> Void) {
        state = .loading
        dataProvider.requestData(with: dataStringUrl) { [weak self] sections, error in
            guard let self = self else { return }
            guard error == nil,
                let sections = sections else {
                self.state = .error
                let userInfo = [NSLocalizedDescriptionKey: "Refresh Failed"]
                completion(NSError(domain: "refresh", code: 1, userInfo: userInfo))
                return
            }
            self.sections = sections
            self.state = .populated
            completion(nil)
        }
    }
    /// Notification for data request
    /// - Parameters:
    ///    - error: Type of error if data request failed
    func notify(_ error: Error? = nil) {
        delegate?.dashboardItemsSetupFinished(error: error)
    }

    public func numberOfSections() -> Int {
        /*
        if there is no sections in the model, it will return 1,
        because the everyThingIsOk section must be visible.
        */
        return (sections.isEmpty) ? 1 : sections.count
    }

    public func numberOfItemsAtSection(section: Int) -> Int {
        /*
        if there is no sections in the model, it will return 1,
        because the everyThingIsOk section must be visible.
        */
        guard !sections.isEmpty else {
            return 1
        }

        return sections[section].items?.count ?? 0
    }

    public func removeItem(
        at index: IndexPath,
        completion: (_ isItemRemoved: Bool, _ isSectionRemoved: Bool) -> Void
    ) {
        guard
            sections.count > index.section,
            sections[index.section].items?.count ?? 0 > index.row else {
                completion(false, false)
                return
        }
        sections[index.section].items?.remove(at: index.row)
        if sections[index.section].items?.count ?? 0 == 0 {
            sections.remove(at: index.section)
            completion(true, true)
        } else {
            completion(true, false)
        }
    }

    public func sectionAtIndex(index: Int) -> BaseSectionViewModel? {
        if !sections.isEmpty {
            return sections[index]
        }

        return nil
    }

    public func cardAtIndex(indexPath: IndexPath) -> BaseItemViewModel? {
        /*
        cardAtIndex method can return nil now because the component supports failure scenarios.
        */
        if !sections.isEmpty {
            guard let item = sections[indexPath.section].items?[safe: indexPath.row] else {
                return BaseItemViewModel()
            }

            return item
        }
        return nil
    }

    public func titleForSection(at index: Int) -> String {
        let sectionsNotEmpty = !sections.isEmpty
        let indexWithinRange = index < sections.count
        if sectionsNotEmpty, indexWithinRange {
            return sections[index].title ?? ""
        }
        return ""
    }

    public func didSelectCardAtIndex(indexPath: IndexPath) {
        guard let entry = cardAtIndex(indexPath: indexPath)?.componentEntry else {
            return
        }
        if cardAtIndex(indexPath: indexPath)?.data?.error != nil {
            guard let dashboardManager = delegate as? VFGDashboardManager else {
                return
            }
            dashboardManager.dashboardController.refreshDashboard(dashboardManager.dashboardController)
        } else {
            didSelectCard(for: entry)
        }
    }

    /// Method responsible for navigating to the view controller of the card selected .
    /// - Parameters:
    ///     - componentEntry: The *VFGComponentEntry* object of the card selected.
    public func didSelectCard(for componentEntry: VFGComponentEntry?) {
        guard let entry = componentEntry else {
            return
        }

        guard let controller = entry.cardEntryViewController else {
            entry.didSelectCard()
            return
        }
        delegate?.presentSecondLevel(with: controller)
    }

    public func dashboardIndexInSections() -> Int? {
        if !sections.isEmpty {
            return sections.firstIndex { $0.type == VFGDashboardCardType.dashboard.rawValue }
        }
        return nil
    }

    public func discoverIndexInSections() -> Int? {
        if !sections.isEmpty {
            return sections.firstIndex { $0.type == VFGDashboardCardType.discover.rawValue }
        }
        return nil
    }

    public func typeForSection(at index: Int) -> String? {
        let sectionsNotEmpty = !sections.isEmpty
        let indexWithinRange = index < sections.count
        if sectionsNotEmpty, indexWithinRange {
            return sections[index].type ?? VFGDashboardCardType.none.rawValue
        }
        return VFGDashboardCardType.none.rawValue
    }

    public func enableHeaderForSection(at index: Int) -> Bool {
        return true
    }

    public func enableFooterForSection(at index: Int) -> Bool {
        return true
    }
}
/// Protocol for dashboard actions
protocol VFGDashboardModelDelegate: AnyObject {
    /// Actions to be done after refreshing operation ends
    func dashboardItemsRefreshFinished()
}
