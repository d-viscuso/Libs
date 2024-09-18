//
//  VFGMVA12DashboardModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 11/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

/// Dashboard model. Conforms *VFGDashboardItemsProtocol*.
public class VFGMVA12DashboardModel: VFGDashboardItemsProtocol {
    public var floatingTOBIModel: VFGMVA12DashboardFloatingTOBIModel?

    public var state: VFGContentState = .empty

    public var lastUpdatedTime = Date()

    weak public var delegate: VFGDashboardManagerProtocol?

    var userDefaults = UserDefaults.standard
    /// Dashboard screen sections
    var mva12Sections: [BaseSectionViewModel]
    /// Dashboard screen data URL
    var dataStringUrl: String
    /// Dashboard screen data provider
    let mva12DataProvider: VFGDashboardDataProviderProtocol

    /// *VFGDashboardModel* initializer based on URL and data provider
    /// - Parameters:
    ///    - stringURL: Dashboard screen data url (optional)
    ///    - dataProvider: Dashboard screen data provider
    public init?(
        stringURL: String? = Constants.dashboardItemsMVA12URL?.absoluteString ?? "",
        dataProvider: VFGDashboardDataProviderProtocol,
        floatingTOBIModel: VFGMVA12DashboardFloatingTOBIModel? = nil
    ) {
        guard let dashboardItemUrl = stringURL else {
            VFGErrorLog("Failed to create model with:\(stringURL ?? "")")
            return nil
        }
        dataStringUrl = dashboardItemUrl
        mva12Sections = []
        self.mva12DataProvider = dataProvider
        self.floatingTOBIModel = floatingTOBIModel
    }
    /// *VFGDashboardModel* initializer based on URL and data provider
    /// - Parameters:
    ///    - stringURL: Dashboard screen data url (required)
    ///    - dataProvider: Dashboard screen data provider
    public init?(
        stringURL: String,
        dataProvider: VFGDashboardDataProviderProtocol
    ) {
        mva12Sections = []
        dataStringUrl = stringURL
        self.mva12DataProvider = dataProvider
    }
    /// *VFGDashboardModel* initializer based on model and data provider
    /// - Parameters:
    ///    - model: Dashboard screen data model
    ///    - dataProvider: Dashboard screen data provider
    public init(
        model: [BaseSectionViewModel],
        dataProvider: VFGDashboardDataProviderProtocol
    ) {
        mva12Sections = model
        dataStringUrl = ""
        self.mva12DataProvider = dataProvider
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
            mva12DataProvider.requestData(with: dataStringUrl) { [weak self] sections, error in
                guard let self = self else {
                    return
                }

                guard error == nil else {
                    self.state = .error
                    if let sections = sections {
                        self.mva12Sections = sections
                    }
                    self.notify(error)
                    return
                }

                if let sections = sections {
                    self.mva12Sections = sections
                    self.state = .populated

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

    public func refresh(completion: @escaping (_ error: Error?) -> Void) {
        state = .loading
        mva12DataProvider.requestData(with: dataStringUrl) { [weak self] sections, error in
            guard let self = self else { return }
            guard error == nil,
                let sections = sections else {
                self.state = .error
                let userInfo = [NSLocalizedDescriptionKey: "Refresh Failed"]
                completion(NSError(domain: "refresh", code: 1, userInfo: userInfo))
                return
            }
            self.mva12Sections = sections
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
        return (mva12Sections.isEmpty) ? 1 : mva12Sections.count
    }

    public func numberOfItemsAtSection(section: Int) -> Int {
        /*
        if there is no sections in the model, it will return 1,
        because the everyThingIsOk section must be visible.
        */
        guard !mva12Sections.isEmpty else {
            return 1
        }

        return mva12Sections[section].items?.count ?? 0
    }

    public func removeItem(
        at index: IndexPath,
        completion: (_ isItemRemoved: Bool, _ isSectionRemoved: Bool) -> Void
    ) {
        guard
            mva12Sections.count > index.section,
            mva12Sections[index.section].items?.count ?? 0 > index.item else {
                completion(false, false)
                return
        }
        mva12Sections[index.section].items?.remove(at: index.item)
        if mva12Sections[index.section].items?.count ?? 0 == 0 {
            mva12Sections.remove(at: index.section)
            completion(true, true)
        } else {
            completion(true, false)
        }
    }

    public func sectionAtIndex(index: Int) -> BaseSectionViewModel? {
        if !mva12Sections.isEmpty {
            return mva12Sections[index]
        }

        return nil
    }

    public func cardAtIndex(indexPath: IndexPath) -> BaseItemViewModel? {
        /*
        cardAtIndex method can return nil now because the component supports failure scenarios.
        */
        if !mva12Sections.isEmpty {
            guard let item = mva12Sections[indexPath.section].items?[safe: indexPath.row] else {
                return BaseItemViewModel()
            }

            return item
        }
        return nil
    }

    public func titleForSection(at index: Int) -> String {
        let sectionsNotEmpty = !mva12Sections.isEmpty
        let indexWithinRange = index < mva12Sections.count
        if sectionsNotEmpty, indexWithinRange {
            return mva12Sections[index].title ?? ""
        }
        return ""
    }

    public func didSelectCardAtIndex(indexPath: IndexPath) {
        guard let componentEntry = cardAtIndex(indexPath: indexPath)?.componentEntry else {
            return
        }
        if cardAtIndex(indexPath: indexPath)?.data?.error != nil {
            guard let dashboardManager = delegate as? VFGDashboardManager else {
                return
            }
            dashboardManager.dashboardController.refreshDashboard(dashboardManager.dashboardController)
        } else {
            didSelectCard(for: componentEntry)
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

    public func discoverIndexInSections() -> Int? {
        if !mva12Sections.isEmpty {
            return mva12Sections.firstIndex { $0.type == VFGDashboardCardType.discover.rawValue }
        }
        return nil
    }

    public func typeForSection(at index: Int) -> String? {
        let sectionsNotEmpty = !mva12Sections.isEmpty
        let indexWithinRange = index < mva12Sections.count
        if sectionsNotEmpty, indexWithinRange {
            return mva12Sections[index].type ?? VFGDashboardCardType.none.rawValue
        }
        return VFGDashboardCardType.none.rawValue
    }

    public func seansonalOfferIndexInSections() -> Int? {
        if !mva12Sections.isEmpty {
            return mva12Sections.firstIndex { $0.type == VFGDashboardCardType.seasonalOffer.rawValue }
        }
        return nil
    }

    public func enableHeaderForSection(at index: Int) -> Bool {
        if !mva12Sections.isEmpty {
            return !(mva12Sections[index].title?.isEmpty ?? true)
        }
        return false
    }

    public func enableFooterForSection(at index: Int) -> Bool {
        if !mva12Sections.isEmpty {
            return mva12Sections[index].type != VFGDashboardCardType.scrollableCard.rawValue &&
            mva12Sections[index].type != VFGDashboardCardType.discover.rawValue
        }
        return false
    }
}
