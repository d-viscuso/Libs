//
//  VFGDatePicker+CollectionView.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 13/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

extension VFGDatePicker: UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        days.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: VFGDatePickerCollectionViewCell.reuseIdentifier,
                for: indexPath) as? VFGDatePickerCollectionViewCell else {
                    VFGErrorLog("Unable to initialize CalendarDateCollectionViewCell")
                    return UICollectionViewCell()
                }

        cell.appearance = appearance == nil ? self : appearance
        cell.day = days[indexPath.row]

        return cell
    }
}

extension VFGDatePicker: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        toggleDaySelection(at: indexPath.row)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = Int(collectionView.frame.width / 7)
        return CGSize(width: width, height: cellHeight)
    }
}

extension VFGDatePicker {
    func toggleRangeOfDaysSelection(state: Bool) {
        guard let startDateIndex = days.firstIndex(where: { day in
            self.isDateWithinSelectedRange(day.date)
        }) else { return }

        guard let endDateIndex = days.lastIndex(where: { day in
            self.isDateWithinSelectedRange(day.date)
        }) else { return }

        (startDateIndex...endDateIndex).forEach { index in
            toggleDaySelection(at: index, state: state)
        }
    }

    func toggleDaySelection(at index: Int) {
        guard isEnabledDate(days[index].date) else {
            return
        }

        if mode == .singleSelection, startDate != nil {
            if let previouslySelectedDayIndex = days.firstIndex(where: { $0.isFirstSelected }) {
                toggleDaySelection(at: previouslySelectedDayIndex, state: false)
            }
            self.startDate = days[index].date
            delegate?.datePicker(self, dateDidSelect: days[index].date)
        } else if startDate == nil {
            startDate = days[index].date
            delegate?.datePicker(self, dateDidSelect: days[index].date)
        } else if let startDate = startDate, startDate != days[index].date, endDate == nil {
            endDate = max(days[index].date, startDate)
            self.startDate = min(days[index].date, startDate)
            toggleRangeOfDaysSelection(state: true)

            if let startDate = self.startDate, let endDate = self.endDate {
                delegate?.datePicker(self, rangeDidSelect: startDate, endDate)
            }
        } else if startDate != nil, endDate != nil {
            toggleRangeOfDaysSelection(state: false)

            startDate = days[index].date
            endDate = nil

            delegate?.datePicker(self, dateDidSelect: days[index].date)
        }

        toggleDaySelection(at: index, state: true)
    }

    func toggleDaySelection(at index: Int, state: Bool) {
        days[index].isFirstSelected = state
        ? days[index].date.timeIntervalSince1970 == startDate?.timeIntervalSince1970
        : false
        days[index].isLastSelected = state
        ? days[index].date.timeIntervalSince1970 == endDate?.timeIntervalSince1970
        : false
        days[index].isWithinSelectedRange = state
        ? isDateWithinSelectedRange(days[index].date)
        : false
        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
}

extension VFGDatePicker: VFGDatePickerAppearance {}
