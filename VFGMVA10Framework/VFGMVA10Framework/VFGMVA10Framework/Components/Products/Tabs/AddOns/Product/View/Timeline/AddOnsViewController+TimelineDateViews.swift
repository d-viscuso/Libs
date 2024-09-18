//
//  AddOnsViewController+TimelineDateViews.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 7/20/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension AddOnsViewController {
    func updateArrayOfProductsForTimeline() {
        // refresh timeline dates and array when more addons are added
        if numberOfAddOns != addOnsViewModel?.numberOfMyProducts() ?? 0 ||
            (addOnsViewModel?.myProducts?.isEmpty ?? false) || firstTimeDisplay ||
            (enterTimelineFromList && viewDidDisappear) {
            enterTimelineFromList = false
            viewDidDisappear = false
            firstTimeDisplay = false
            numberOfAddOns = addOnsViewModel?.numberOfMyProducts() ?? 0
            timelineProducts = addOnsViewModel?.myProducts ?? []
            guard let myplan = myPlanModel else { return }
            timelineProducts.insert(myplan, at: 0)
            resetTimelineArrays()

            checkIfDailyOrMonthlyView()
            setupOldAddons()
            addModelForRenewedCell()
            drawTimeLineStucture()
        } else if enterTimelineFromList {
            enterTimelineFromList = false
            scrollCollectionToTodayIndex()
        }
    }

    func checkIfDailyOrMonthlyView() {
        isDailyView = false
        for addon in timelineProducts where calculateAddonPeriod(addon) <= 1 {
            isDailyView = true
            break
        }
    }

    func getUniqueDatesForTimeline() {
        addOnsDates.removeAll()
        for product in timelineProducts {
            guard let startDate = product.addOnDetails?.startDate else { return }
            addOnsDates.append(startDate)
            guard let endDate = product.addOnDetails?.expirationDate else { return }
            addOnsDates.append(endDate)
        }
        var dates = addOnsDates.compactMap { getDateFromString($0) }
        if isDailyView {
            dates.append(Date())
        }
        let sortedDates = dates.sorted { $0 < $1 }
        let uniqueDates = sortedDates
            .enumerated()
            .filter { sortedDates.firstIndex(of: $0.1) == $0.0 }
            .map { $0.1 }
        addOnsDates.removeAll()
        for date in uniqueDates {
            addOnsDates.append(getStringFromDate(date))
        }
    }

    func prepareTimelineDates() {
        getUniqueDatesForTimeline()
        var index = 0
        if addOnsDates.count > 1 {
            repeat {
                guard let firstDate = getDateFromString(addOnsDates[index]) else { return }
                guard let secondDate = getDateFromString(addOnsDates[index + 1]) else { return }
                let firstDateComponents = Calendar.current.dateComponents([.day, .month], from: firstDate)
                let secondDateComponetnts = Calendar.current.dateComponents([.day, .month], from: secondDate)
                if firstDateComponents.day == secondDateComponetnts.day &&
                    firstDateComponents.month == secondDateComponetnts.month {
                    addOnsDates.remove(at: index)
                } else {
                    index += 1
                }
            } while index < addOnsDates.count - 1
            addEmptyDatesLines()
        }
    }

    func prepareTimelineDatesMonthlyView() {
        getUniqueDatesForTimeline()
        var index = 0
        if addOnsDates.count > 1 {
            repeat {
                guard let firstDate = getDateFromString(addOnsDates[index]) else { return }
                guard let secondDate = getDateFromString(addOnsDates[index + 1]) else { return }
                let firstDateComponents = Calendar.current.dateComponents([.month], from: firstDate)
                let secondDateComponents = Calendar.current.dateComponents([.month], from: secondDate)
                if firstDateComponents.month == secondDateComponents.month {
                    addOnsDates.remove(at: index)
                } else {
                    index += 1
                }
            } while index < addOnsDates.count - 1
        }

        var newDatesArray: [Date] = []
        for dateStr in addOnsDates {
            guard let date = getDateFromString(dateStr) else { return }
            let dateMonth = Calendar.current.dateComponents([.month, .year], from: date)
            newDatesArray.append(makeDate(year: dateMonth.year ?? 1991, month: dateMonth.month ?? 1, day: 1))
            newDatesArray.append(makeDate(year: dateMonth.year ?? 1991, month: dateMonth.month ?? 1, day: 8))
            newDatesArray.append(makeDate(year: dateMonth.year ?? 1991, month: dateMonth.month ?? 1, day: 15))
            newDatesArray.append(makeDate(year: dateMonth.year ?? 1991, month: dateMonth.month ?? 1, day: 22))
        }
        if shouldAddDateToMonthView() {
            newDatesArray.append(Date())
        }
        let newArraySorted = newDatesArray.sorted { $0 < $1 }
        addOnsDates.removeAll()
        for date in newArraySorted {
            addOnsDates.append(getStringFromDate(date))
        }
    }

    func shouldAddDateToMonthView(date: Date = Date()) -> Bool {
        let dateComponents = Calendar.current.dateComponents([.day], from: date)
        if ![1, 8, 15, 22].contains(dateComponents.day) {
            return true
        }
        return false
    }

    func addEmptyDatesLines() {
        let calendar = Calendar.current
        var index = 0
        if addOnsDates.count > 1 {
            repeat {
                guard let startDate = getDateFromString(addOnsDates[index]) else { return }
                guard let endDate = getDateFromString(addOnsDates[index + 1]) else { return }
                let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
                let differenceOfDate = Calendar.current.dateComponents(components, from: startDate, to: endDate)

                let firstDate = calendar.dateComponents([.day, .month], from: startDate)
                let secondDate = calendar.dateComponents([.day, .month], from: endDate)
                if secondDate.month != firstDate.month && differenceOfDate.day ?? 0 > 1 { // if months aren't equal
                    addOnsDates.insert("No Date", at: index + 1)
                    index += 2
                } else if (secondDate.day ?? 0) - (firstDate.day ?? 0) > 1 { // if date2 day > date1 day
                    addOnsDates.insert("No Date", at: index + 1)
                    index += 2
                } else {
                    index += 1
                }
            } while index < addOnsDates.count - 1
        }
    }

    func addTimelineDatesView(_ completion: (() -> Void)? = nil) {
        resetTimelineDatesAndSeparatorsView()
        var dateSeparatorView: AddOnsTimelineDateView?
        var xPostion: CGFloat = Constants.AddOnsTimeline.timelineDateStartViewXPosition
        for addonDate in addOnsDates {
            dateSeparatorView = AddOnsTimelineDateView.loadXib(bundle: Bundle.mva10Framework)
            guard let dateSeparatorView = dateSeparatorView else {
                return
            }
            dateSeparatorView.frame.origin.x = xPostion
            dictOfDatesAndXPositions[addonDate] = xPostion + (Constants.AddOnsTimeline.timelineDateViewWidth / 2)
            xPostion += (Constants.AddOnsTimeline.timelineDateViewsHorizontalSpacing + dateSeparatorView.frame.width)
            dateSeparatorView.frame.origin.y = 0
            dateSeparatorView.frame.size.height = timelineSeparatorsView.frame.height
            dateSeparatorView.date = addonDate
            if let date = getDateFromString(addonDate) {
                if isDailyView {
                    if Calendar.current.isDateInToday(date) {
                        dateSeparatorView.setupView(isToday: true)
                    } else {
                        dateSeparatorView.datelabel.text = changeDateStringFormat(dateString: addonDate)
                        dateSeparatorView.setupView(isToday: false)
                    }
                } else {
                    if let date = getDateFromString(addonDate) {
                        let dateComponents = Calendar.current.dateComponents([.day], from: date)
                        if dateComponents.day == 1, !Calendar.current.isDateInToday(date) {
                            dateSeparatorView.datelabel.text = changeDateStringFormat(dateString: addonDate)
                            dateSeparatorView.setupView(isToday: false)
                        } else if Calendar.current.isDateInToday(date) {
                            dateSeparatorView.setupView(isToday: true)
                        } else {
                            dateSeparatorView.datelabel.text = ""
                        }
                    }
                }
            }
            timelineDatesViews.append(dateSeparatorView)
            timelineSeparatorsView.addSubview(dateSeparatorView)
        }
        addOnsTimelineCollectionView.addSubview(timelineSeparatorsView)
        addOnsTimelineCollectionView.sendSubviewToBack(timelineSeparatorsView)
        guard let completion = completion else { return }
        completion()
    }

    func addModelForRenewedCell() {
        for product in timelineProducts where product.addOnDetails?.isAutoRenewable ?? false {
            let productAddonPeriod = calculateAddonPeriod(product)
            var renewedProduct = createRenewedProduct(product: product)
            var expiredAndRenewedProduct = createExpiredProduct(product: product)
            // add cells dates for oneday addons
            if productAddonPeriod == 0 {
                renewedProduct.addOnDetails?.startDate =
                    getNextDateString(product.addOnDetails?.startDate ?? "")
                renewedProduct.addOnDetails?.expirationDate =
                    getNextDateString(product.addOnDetails?.expirationDate ?? "")
                expiredAndRenewedProduct.addOnDetails?.startDate =
                    getPreviousDateString(product.addOnDetails?.startDate ?? "")
                expiredAndRenewedProduct.addOnDetails?.expirationDate =
                    getPreviousDateString(product.addOnDetails?.expirationDate ?? "")
            }
            // append new cells
            timelineProducts.append(renewedProduct)
            timelineProducts.append(expiredAndRenewedProduct)
        }
    }

    func createRenewedProduct(product: AddOnsProductModel) -> AddOnsProductModel {
        let productAddonPeriod = calculateAddonPeriod(product)
        var renewedProduct: AddOnsProductModel = product
        renewedProduct.toBeRenewedProduct = true
        renewedProduct.addOnDetails?.isAutoRenewable = false
        if let renewalType = product.addOnDetails?.renewalType, renewalType == .monthly {
            renewedProduct.addOnDetails?.startDate = getNextDateString(
                product.addOnDetails?.startDate ?? "", component: .month)
            let expirationDate = calculateAddonMissingDate(
                dateString: renewedProduct.addOnDetails?.startDate ?? "",
                addonPeriod: productAddonPeriod)
            renewedProduct.addOnDetails?.expirationDate = expirationDate
        } else {
            renewedProduct.addOnDetails?.startDate = product.addOnDetails?.expirationDate
            let expirationDate = calculateAddonMissingDate(
                dateString: renewedProduct.addOnDetails?.startDate ?? "",
                addonPeriod: productAddonPeriod)
            renewedProduct.addOnDetails?.expirationDate = expirationDate
        }
        return renewedProduct
    }

    func createExpiredProduct(product: AddOnsProductModel) -> AddOnsProductModel {
        let productAddonPeriod = calculateAddonPeriod(product)
        var expiredAndRenewedProduct: AddOnsProductModel = product
        expiredAndRenewedProduct.expiredAndRenewedProduct = true
        expiredAndRenewedProduct.addOnDetails?.isAutoRenewable = false
        if let renewalType = product.addOnDetails?.renewalType, renewalType == .monthly {
            expiredAndRenewedProduct.addOnDetails?.startDate =
                getPreviousDateString(product.addOnDetails?.startDate ?? "", component: .month)
            let expiryDate = calculateAddonMissingDate(
                dateString: expiredAndRenewedProduct.addOnDetails?.startDate ?? "",
                addonPeriod: productAddonPeriod)
            expiredAndRenewedProduct.addOnDetails?.expirationDate = expiryDate
        } else {
            expiredAndRenewedProduct.addOnDetails?.expirationDate = product.addOnDetails?.startDate
            let startDate = calculateAddonMissingDate(
                dateString: expiredAndRenewedProduct.addOnDetails?.startDate ?? "",
                addonPeriod: productAddonPeriod,
                startDate: false)
            expiredAndRenewedProduct.addOnDetails?.startDate = startDate
        }
        return expiredAndRenewedProduct
    }

    func setupOldAddons() {
        for (index, element) in timelineProducts.enumerated() {
            let expireDate = getDateFromString(element.addOnDetails?.expirationDate ?? "") ?? Date()
            if expireDate < Date() {
                if element.addOnDetails?.isAutoRenewable ?? false {
                    renewAutoRenewableAddons(index: index, element: element, expireDate: expireDate)
                } else {
                    timelineProducts[index].expiredProduct = true
                }
            }
        }
    }

    // if array is autorenewable but expired before today's date
    func renewAutoRenewableAddons(index: Int, element: AddOnsProductModel, expireDate: Date) {
        var addonPeriod = calculateAddonPeriod(element)
        if addonPeriod == 0 {
            addonPeriod = 1
        }
        var newExpireDate = getStringFromDate(expireDate)
        repeat {
            timelineProducts[index].addOnDetails?.startDate = newExpireDate
            newExpireDate =
                calculateAddonMissingDate(dateString: newExpireDate, addonPeriod: addonPeriod)
            timelineProducts[index].addOnDetails?.expirationDate = newExpireDate
        } while getDateFromString(newExpireDate) ?? Date() < Date()
    }

    func drawTimeLineStucture() {
        if isDailyView {
            prepareTimelineDates()
        } else {
            prepareTimelineDatesMonthlyView()
        }
        addTimelineDatesView {
            self.addOnsTimelineCollectionView.reloadData()
            self.scrollCollectionToTodayIndex()
        }
    }

    func scrollCollectionToTodayIndex() {
        let calculatedOffset: CGFloat = self.getCellXPositionByDate(productDate: self.getStringFromDate(Date()))
            - self.view.frame.width / 2
        self.addOnsTimelineCollectionView.setContentOffset(CGPoint(x: calculatedOffset, y: 0.0), animated: true)
    }

    func resetTimelineDatesAndSeparatorsView() {
        timelineSeparatorsView.removeSubviews()
        timelineDatesViews.removeAll()
        dictOfDatesAndXPositions.removeAll()
        timeLineCollectionViewCellsYPosition.removeAll()
        let dateSeparatorViewYConstant: CGFloat = 48
        timelineSeparatorsView.frame = CGRect(
            x: addOnsTimelineCollectionView.frame.origin.x,
            y: -dateSeparatorViewYConstant,
            width: addOnsTimelineCollectionView.contentSize.width,
            height: addOnsTimelineCollectionView.contentSize.height
                + UIScreen.main.bounds.size.height )
    }

    func resetTimelineArrays() {
        timelineDatesViews.removeAll()
        addOnsDates.removeAll()
        timeLineCollectionViewCellsYPosition.removeAll()
        dictOfDatesAndXPositions.removeAll()
    }

    // MARK: - Date methods
    func calculateAddonMissingDate(dateString: String, addonPeriod: Int, startDate: Bool = true) -> String {
        guard let dateString = getDateFromString(dateString) else { return "No Date" }
        var dateComponent = DateComponents()
        dateComponent.day = addonPeriod
        var date = Calendar.current.date(byAdding: .day, value: -addonPeriod, to: dateString)
        if startDate {
            date = Calendar.current.date(byAdding: .day, value: addonPeriod, to: dateString)
        }
        return getStringFromDate(date ?? Date())
    }

    // MARK: - Generic Date methods
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

    func changeDateStringFormat(dateString: String) -> String? {
        VFGDateHelper.changeDateStringFormat(
            dateString: dateString,
            format: "dd MMM",
            dateFormatString: Constants.AddOnsTimeline.dateFormat,
            locale: Constants.AddOnsTimeline.localeUS)
    }

    func getNextDateString(_ string: String, component: Calendar.Component = .day) -> String {
        VFGDateHelper.nextDateString(
            from: string,
            component: component,
            format: Constants.AddOnsTimeline.dateFormat,
            locale: Constants.AddOnsTimeline.localeUS)
    }

    func getPreviousDateString(_ string: String, component: Calendar.Component = .day) -> String {
        VFGDateHelper.previousDateString(
            from: string,
            component: component,
            format: Constants.AddOnsTimeline.dateFormat,
            locale: Constants.AddOnsTimeline.localeUS)
    }

    func makeDate(year: Int, month: Int, day: Int, hour: Int? = 0, min: Int? = 0, sec: Int? = 0) -> Date {
        VFGDateHelper.date(
            from: year,
            month: month,
            day: day,
            hour: hour,
            min: min,
            sec: sec)
    }
}
