//
//  BalanceHistoryDataProvider.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 11/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Balance history data provider.
public class BalanceHistoryDataProvider: BalanceHistoryDataProviderProtocol {
    private let networkClient: VFGNetworkClientProtocol? = VFGNetworkClient(baseURL: "")
    /// balance history model.
    public var balanceHistory: BalanceHistoryModel?
    var config: [String: String]
    var currentDate = Date()

    public init(
        config: [String: String] = [
            "balanceFileName": "balance_history",
            "filteredBalanceFileName": "balance_history_filtered"
        ],
        request: VFGRequest? = nil
    ) {
        self.config = config
    }

    func getPath(fileName: String? = "balance_history", bundle: Bundle = Bundle.main) -> String? {
        return bundle.url(
            forResource: fileName,
            withExtension: "json")?.absoluteString
    }

    func getDefaultRequest() -> VFGRequest? {
        guard let path = getPath(fileName: config["balanceFileName"]) else { return nil }
        return VFGRequest(path: path)
    }

    func getFilteredRequest() -> VFGRequest? {
        guard let path = getPath(fileName: config["filteredBalanceFileName"]) else { return nil }
        return VFGRequest(path: path)
    }

    func getRequest(dateRange: (from: Date, to: Date)?) -> VFGRequest? {
        (dateRange == nil) ? getDefaultRequest() : getFilteredRequest()
    }

    /// Method to fetch balance history in a specific date range.
    /// - Parameters:
    ///     - dateRange: A tuple of two dates.
    ///     - completion: *FetchBalanceFetchCompletion* is atypealias for *((BalanceHistoryModelProtocol?, Error?) -> Void)*
    public func fetchBalanceHistory(dateRange: (from: Date, to: Date)?, completion: FetchBalanceFetchCompletion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            guard let request = self.getRequest(dateRange: dateRange) else {
                completion?(nil, nil)
                return
            }

            self.networkClient?.executeData(
                request: request,
                model: BalanceHistoryModel.self,
                progressClosure: nil
            ) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let model):
                    self.balanceHistory = model
                    self.setUpBalanceHistorySections(completion: completion)
                case .failure(let error):
                    completion?(nil, error)
                }
            }
        }
    }

    func setUpBalanceHistorySections(completion: FetchBalanceFetchCompletion) {
        self.balanceHistory?.balanceSections = []
        /// get array of sections date
        var arrayOfSectionsTitles: [String] = []
        balanceHistory?.balanceSectionItems?.forEach { item in
            arrayOfSectionsTitles.append(item.balanceDate ?? "")
        }
        /// get array of unique dates
        arrayOfSectionsTitles = getArrayOfSortedUniqueSectionsTitles(datesStr: arrayOfSectionsTitles)

        guard let balanceSectionItems = balanceHistory?.balanceSectionItems
            else { return }
        let dictionary = Dictionary(grouping: balanceSectionItems) { item in
            return getBalanceSectionTitle(from: item.balanceDate ?? "")
        }

        var balanceSections: [BalanceHistorySection] = []
        for item in dictionary {
            balanceSections.append(BalanceHistorySection(title: item.key, items: item.value))
        }
        /// sort balance selectction type
        balanceSections = balanceSections.sorted { item1, item2 in
            guard
                let balanceSectionType1 = item1.balanceSectionItems?.first?.balanceDate,
                let balanceSectionType2 = item2.balanceSectionItems?.first?.balanceDate
                else { return false }
            return balanceSectionType1 > balanceSectionType2
        }
        /// sort balance Section items
        for index in 0..<balanceSections.count {
            var section = balanceSections[index]
            let items = section.balanceSectionItems?.sorted { $0.balanceDate ?? "" > $1.balanceDate ?? "" }
            section.balanceSectionItems = items
            balanceSections[index] = section
        }

        self.balanceHistory?.balanceSections? = balanceSections
        completion?(balanceHistory, nil)
    }

    // MARK: - Date methods
    func getArrayOfSortedUniqueSectionsTitles(datesStr: [String]) -> [String] {
        let dates = datesStr.compactMap { getDateFromString($0) }
        let sortedDates = dates.sorted { $0 > $1 }
        let uniqueDates = sortedDates
            .enumerated()
            .filter { sortedDates.firstIndex(of: $0.1) == $0.0 }
            .map { $0.1 }

        var uniqueDateStr: [String] = []
        for date in uniqueDates {
            uniqueDateStr.append(getStringFromDate(date))
        }
        return uniqueDateStr
    }

    func getDateFromString(_ string: String) -> Date? {
        VFGDateHelper.getDateFromString(
            dateString: string,
            format: Constants.AddOnsTimeline.dateFormat,
            locale: Constants.AddOnsTimeline.localeUS)
    }

    func getStringFromDate(_ date: Date) -> String {
        VFGDateHelper.getStringFromDate(
            date: date,
            dateFormat: Constants.AddOnsTimeline.dateFormat,
            locale: Constants.AddOnsTimeline.localeUS)
    }

    func getBalanceSectionTitle(from dateString: String) -> String? {
        guard let date = VFGDateHelper.getDateFromString(dateString: dateString)
            else { return nil }
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: date)
        let currentDateComponents = calendar.dateComponents([.day, .month, .year], from: currentDate)

        if calendar.isDateInToday(date) {
            return "balance_history_section_title_today".localized(bundle: .mva10Framework)
        } else if calendar.isDateInYesterday(date) && dateComponents.month == currentDateComponents.month {
            return "balance_history_section_title_yesterday".localized(bundle: .mva10Framework)
        } else if dateComponents.month == currentDateComponents.month &&
            dateComponents.year == currentDateComponents.year {
            return changeDateFormate(title: dateString, format: "dd MMMM")
        } else if dateComponents.year == currentDateComponents.year {
            return changeDateFormate(title: dateString, format: "MMMM YYYY")
        } else {
            return changeDateFormate(title: dateString, format: "YYYY")
        }
    }

    func changeDateFormate(title: String, format: String) -> String {
        return VFGDateHelper.changeDateStringFormat(
            dateString: title,
            format: format,
            dateFormatString: Constants.AddOnsTimeline.dateFormat,
            locale: Constants.AddOnsTimeline.localeUS) ?? ""
    }
}
