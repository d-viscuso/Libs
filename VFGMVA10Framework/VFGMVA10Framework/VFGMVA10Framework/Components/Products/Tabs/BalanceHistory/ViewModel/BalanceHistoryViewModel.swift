//
//  BalanceHistoryViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 11/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

/// Balance history view model.
public class BalanceHistoryViewModel {
    var balanceHistoryDataProvider: BalanceHistoryDataProviderProtocol?
    var balanceSections: [BalanceHistorySection] = []
    var filteredBalanceSections: [BalanceHistorySection] = []
    var autoTopUpCVMEnabled = false
    var autoTopUpModel: VFGAutoTopUpProtocol?
    var autoTopUpCVMDescription: String?
    var shouldHideDateFilterView: Bool?

    var contentState: VFGContentState = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var updateLoadingStatus: (() -> Void)?
    var balanceCategories: [String] = []

    public init(
        balanceHistoryDataProvider: BalanceHistoryDataProviderProtocol? = BalanceHistoryDataProvider(),
        autoTopUpCVMEnabled: Bool = false,
        autoTopUpModel: VFGAutoTopUpProtocol? = nil,
        shouldHideDateFilterView: Bool = false
    ) {
        self.balanceHistoryDataProvider = balanceHistoryDataProvider
        self.autoTopUpCVMEnabled = autoTopUpCVMEnabled
        self.autoTopUpModel = autoTopUpModel
        self.shouldHideDateFilterView = shouldHideDateFilterView
    }

    func setupBalanceCategories() {
        for section in balanceSections {
            if let existingTypes = section.balanceSectionItems?
                .compactMap({ $0.balanceType }) {
                self.balanceCategories.append(contentsOf: existingTypes)
            }
        }
        balanceCategories = balanceCategories.unique()
    }

    open func fetchBalanceHistory(dateRange: (from: Date, to: Date)? = nil) {
        contentState = .loading
        self.balanceHistoryDataProvider?.fetchBalanceHistory(
            dateRange: dateRange) { [weak self] model, error in
            guard let self = self else {
                return
            }

            guard
                error == nil,
                let balanceSections = model?.balanceSections else {
                self.contentState = .error
                return
            }

            guard !balanceSections.isEmpty else {
                self.contentState = .empty
                return
            }

            self.balanceSections = balanceSections
            self.filteredBalanceSections = balanceSections
            self.setupBalanceCategories()
            self.contentState = .populated
        }
    }

    func filter(with balanceTypesStrings: [String]) {
        var balanceTypes: [String] = []
        for balanceTypeStr in balanceTypesStrings {
            balanceTypes.append( balanceTypeStr )
        }

        filteredBalanceSections = balanceSections
        guard !balanceTypes.contains(BalanceHistoryLocalize.all.localizedString) else {
            contentState = .filtered
            return
        }

        for (index, section) in balanceSections.enumerated() {
            filteredBalanceSections[index].balanceSectionItems = section.balanceSectionItems?.filter { item -> Bool in
                balanceTypes.contains(item.balanceType ?? BalanceHistoryLocalize.all.localizedString)
            }
        }

        filteredBalanceSections = filteredBalanceSections.filter { $0.balanceSectionItems?.count ?? 0 > 0 }
        contentState = .filtered
    }

    func numberOfBalanceSectionItems(at section: Int) -> Int {
        return filteredBalanceSections[section].balanceSectionItems?.count ?? 0
    }

    func cellViewModel(at indexPath: IndexPath) -> BalanceHistoryItemViewModel {
        let balanceItem = filteredBalanceSections[indexPath.section].balanceSectionItems?[indexPath.row]
        let amount = balanceItem?.balanceAmount
        let amountInfo = balanceItem?.balanceAmountInfo
        let title = balanceItem?.balanceTitle
        let description = balanceItem?.balanceDescription
        let subTitle = getItemTime(
            itemDate: filteredBalanceSections[indexPath.section].title ?? "")
        let imageName = balanceItem?.balanceImage
        return BalanceHistoryItemViewModel(
            iconName: imageName,
            title: title,
            balanceDescription: description,
            subtitle: subTitle,
            amount: amount,
            amountInfo: amountInfo,
            balanceType: balanceItem?.balanceType,
            iconBundle: balanceItem?.balanceImageBundle,
            amountColor: balanceItem?.balanceAmountColor)
    }

    // MARK: Dates display format
    func getItemTime(itemDate: String) -> String? {
        guard let date = VFGDateHelper.getDateFromString(dateString: itemDate)
            else { return nil }
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: date)
        let currentDateComponents = calendar.dateComponents([.day, .month, .year], from: Date())

        if calendar.isDateInToday(date) ||
            calendar.isDateInYesterday(date) && dateComponents.month == currentDateComponents.month ||
            dateComponents.month == currentDateComponents.month &&
            dateComponents.year == currentDateComponents.year {
            return changeDateFormate(title: itemDate, format: "hh:mm a")
        } else {
            return changeDateFormate(title: itemDate, format: "dd/MM/yyyy")
        }
    }

    func changeDateFormate(title: String, format: String) -> String {
        return VFGDateHelper.changeDateStringFormat(
            dateString: title,
            format: format,
            dateFormatString: Constants.AddOnsTimeline.dateFormat,
            locale: Constants.AddOnsTimeline.localeUS) ?? ""
    }

    func setupLocalizationForActiveCVMBanner(
        autoTopUpType: String,
        exactOccurrence: String,
        autoTopUpAmount: Double,
        delegate: VFGCVMProtocol?
    ) -> VFGCVMViewModel {
        var exactOccurrence = exactOccurrence
        switch autoTopUpType {
        case AutoTopUpType.weekly:
            exactOccurrence = exactOccurrence.getFullDayName().capitalizingFirstLetter()
            let date = findDayDate(dayName: exactOccurrence)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            let month = dateFormatter.string(from: date)

            autoTopUpCVMDescription = String(
                format: "auto_top_up_edit_cvm_weekly_description".localized(bundle: .mva10Framework),
                arguments: [
                    String(describing: autoTopUpAmount),
                    exactOccurrence,
                    VFGDateHelper.daySuffix(date: date),
                    month
                ]
            )
        case AutoTopUpType.monthly:
            let selectedDay = Int(exactOccurrence) ?? 0
            let nextPayment = daysToNextMonthlyAutoTopUp(selectedDay: selectedDay)
            autoTopUpCVMDescription = String(
                format: "auto_top_up_edit_cvm_monthly_description".localized(bundle: .mva10Framework),
                arguments: [
                    String(describing: autoTopUpAmount),
                    VFGDateHelper.daySuffix(day: selectedDay ),
                    String(describing: nextPayment)
                ]
            )
        default:
            autoTopUpCVMDescription = String(
                format: "auto_top_up_edit_cvm_amount_description".localized(bundle: .mva10Framework),
                arguments: [String(describing: autoTopUpAmount), String(exactOccurrence)]
            )
        }

        guard let autoTopUpCVMDescription = autoTopUpCVMDescription else {
            return VFGCVMViewModel(title: "", description: "", buttonTitle: "")
        }
        let viewModel = VFGCVMViewModel(
            title: "auto_top_up_edit_cvm_title_on".localized(bundle: .mva10Framework),
            titleWhenDisabled: "auto_top_up_edit_cvm_title_off".localized(bundle: .mva10Framework),
            description: autoTopUpCVMDescription,
            buttonTitle: "auto_top_up_edit_cvm_button_text".localized(bundle: .mva10Framework),
            delegate: delegate
        )
        return viewModel
    }

    func findDayDate(dayName: String) -> Date {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        var dayInWeek = dateFormatter.string(from: date)
        var dateComponent = DateComponents()
        for difference in 1...7 {
            dateComponent.day = difference
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
            guard let futureDate1 = futureDate else { return date }
            dayInWeek = dateFormatter.string(from: futureDate1)
            if dayName == dayInWeek {
                return futureDate1
            }
        }
        return date
    }

    func daysToNextMonthlyAutoTopUp(selectedDay: Int) -> Int {
        let todaysDay = Calendar.current.component(.day, from: Date())
        var nextPayment = 0
        let daysNumberRange = Calendar.current.range(of: .day, in: .month, for: Date())
        let daysInMonth = daysNumberRange?.count
        if selectedDay > todaysDay {
            nextPayment = selectedDay - todaysDay
        } else if let daysInMonth = daysInMonth {
            nextPayment = daysInMonth - todaysDay + selectedDay
        }
        return nextPayment
    }
}
