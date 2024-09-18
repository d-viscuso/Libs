//
//  VFGDatePicker+DayGeneration.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 26/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

extension VFGDatePicker {
    func monthMetadata(for baseDate: Date) throws -> VFGMonthMetadata {
        guard
            let numberOfDaysInMonth = calendar.range(
                of: .day,
                in: .month,
                for: baseDate)?.count,
            let firstDayOfMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            throw VFGDatePickerError.metadataGeneration
        }

        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)

        return VFGMonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekday)
    }

    func generateDaysInMonth(for baseDate: Date) -> [VFGDay] {
        guard let metadata = try? monthMetadata(for: baseDate) else {
            preconditionFailure("An error occurred when generating the metadata for \(baseDate)")
        }

        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay

        var days: [VFGDay] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            let dayOffset =
                isWithinDisplayedMonth ?
                day - offsetInInitialRow :
                -(offsetInInitialRow - day)

            return generateDay(
                offsetBy: dayOffset,
                for: firstDayOfMonth,
                isWithinDisplayedMonth: isWithinDisplayedMonth)
        }

        if gapless {
            days += generateStartOfNextMonth(using: firstDayOfMonth)
        }

        return days
    }

    func generateDay(
        offsetBy dayOffset: Int,
        for baseDate: Date,
        isWithinDisplayedMonth: Bool
    ) -> VFGDay {
        let date = calendar.date(
            byAdding: .day,
            value: dayOffset,
            to: baseDate)
            ?? baseDate

        return VFGDay(
            date: date,
            number: dateFormatter.string(from: date),
            isFirstSelected: date.timeIntervalSince1970 == startDate?.timeIntervalSince1970,
            isLastSelected: date.timeIntervalSince1970 == endDate?.timeIntervalSince1970,
            isWithinSelectedRange: isDateWithinSelectedRange(date),
            isWithinDisplayedMonth: isWithinDisplayedMonth,
            isWithinMinMax: isEnabledDate(date),
            isHidden: !gapless && !isWithinDisplayedMonth,
            isToday: calendar.isDate(date, inSameDayAs: Date())
        )
    }

    func generateStartOfNextMonth(
        using firstDayOfDisplayedMonth: Date
    ) -> [VFGDay] {
        guard
            let lastDayInMonth = calendar.date(
                byAdding: DateComponents(month: 1, day: -1),
                to: firstDayOfDisplayedMonth)
        else {
            return []
        }

        let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
        guard additionalDays > 0 else {
            return []
        }

        let days: [VFGDay] = (1...additionalDays)
            .map {
                generateDay(
                    offsetBy: $0,
                    for: lastDayInMonth,
                    isWithinDisplayedMonth: false)
            }

        return days
    }

    func isDateWithinSelectedRange(_ date: Date) -> Bool {
        guard let startDate = startDate, let endDate = endDate else {
            return false
        }

        return startDate.timeIntervalSince1970...endDate.timeIntervalSince1970 ~= date.timeIntervalSince1970
    }

    // Rounding collectionView's width floating point value
    func adjustCollectionViewWidthIfNeeded() {
        var collectionViewWidth = Int(collectionView.frame.size.width)
        guard collectionViewWidth % 7 != 0 else {
            return
        }

        while collectionViewWidth % 7 != 0 {
            collectionViewWidth += 1
        }

        NSLayoutConstraint.deactivate([
            collectionViewTrailingAnchor,
            headerViewTrailingAnchor
        ])

        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: CGFloat(collectionViewWidth)),
            headerView.widthAnchor.constraint(equalTo: collectionView.widthAnchor)
        ])

        collectionView.layoutIfNeeded()
    }

    func isEnabledDate(_ date: Date) -> Bool {
        guard
            let minimumDate = minimumDate,
            let maximumDate = maximumDate,
            let dateTimeInterval = calendar.date(
                from: calendar.dateComponents([.year, .month, .day], from: date)
            )?.timeIntervalSince1970,
            let minimumTimeInterval = calendar.date(
                from: calendar.dateComponents([.year, .month, .day], from: minimumDate)
            )?.timeIntervalSince1970,
            let maximumTimeInterval = calendar.date(
                from: calendar.dateComponents([.year, .month, .day], from: maximumDate)
            )?.timeIntervalSince1970 else {
            return true
        }

        return dateTimeInterval >= minimumTimeInterval && dateTimeInterval <= maximumTimeInterval
    }

    enum VFGDatePickerError: Error {
        case metadataGeneration
    }
}
