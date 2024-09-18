//
//  AddOnsViewController+TimelineLayoutDelegate.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 7/12/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

protocol TimelineLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        widthForItemAtIndexPath indexPath: IndexPath
    ) -> CGFloat
    func collectionView(
        _ collectionView: UICollectionView,
        heightForItemAtIndexPath indexPath: IndexPath
    ) -> CGFloat
    func collectionView(
        _ collectionView: UICollectionView,
        yPositionForItemAtIndexPath indexPath: IndexPath
    ) -> CGFloat
    func collectionView(
        _ collectionView: UICollectionView,
        xPositionForItemAtIndexPath indexPath: IndexPath
    ) -> CGFloat
    func getNumberOfDateLines() -> Int
}

extension AddOnsViewController: TimelineLayoutDelegate {
    func getNumberOfDateLines() -> Int {
        return addOnsDates.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        xPositionForItemAtIndexPath indexPath: IndexPath
    ) -> CGFloat {
        if isTimelineView && indexPath.row < timelineProducts.count {
            let product = timelineProducts[indexPath.row]
            if isDailyView {
                return getCellXPositionByDate(productDate: product.addOnDetails?.startDate ?? "")
            } else {
                return getCellXPositionByDateForMonthlyView(productDate: product.addOnDetails?.startDate ?? "")
            }
        }
        return 0
    }

    func getCellXPositionByDate(productDate: String) -> CGFloat {
        if let xPosition = dictOfDatesAndXPositions[productDate] {
            return xPosition
        } else {
            guard let itemDate = getDateFromString(productDate) else { return 0 }
            for (dateStr, _) in dictOfDatesAndXPositions {
                if let date = getDateFromString(dateStr) {
                    let firstDate = Calendar.current.dateComponents([.day, .month], from: itemDate)
                    let secondDate = Calendar.current.dateComponents([.day, .month], from: date)
                    if firstDate.day == secondDate.day && firstDate.month == secondDate.month {
                        dictOfDatesAndXPositions[productDate] = dictOfDatesAndXPositions[dateStr]
                        return dictOfDatesAndXPositions[dateStr] ?? 0
                    }
                }
            }
        }
        return 0
    }

    func getCellXPositionByDateForMonthlyView(productDate: String) -> CGFloat {
        let xPosition = getCellXPositionByDate(productDate: productDate)
        if xPosition != 0 {
            return xPosition
        } else {
            guard let itemDate = getDateFromString(productDate) else { return 0 }
            for (dateStr, _) in dictOfDatesAndXPositions {
                if let date = getDateFromString(dateStr) {
                    let firstDate = Calendar.current.dateComponents([.day, .month], from: itemDate)
                    let secondDate = Calendar.current.dateComponents([.day, .month], from: date)
                    if firstDate.month == secondDate.month {
                        if let firstDay = firstDate.day, let secondDay = secondDate.day {
                            if  ((1..<8).contains(firstDay) && secondDay == 1) ||
                                ((8..<15).contains(firstDay) && secondDay == 8) ||
                                ((15..<22).contains(firstDay) && secondDay == 15) ||
                                ((22...31).contains(firstDay) && secondDay == 22) {
                                dictOfDatesAndXPositions[productDate] = dictOfDatesAndXPositions[dateStr]
                                return dictOfDatesAndXPositions[dateStr] ?? 0
                            }
                        }
                    }
                }
            }
        }
        return 0
    }

    func getCellXEndPositionByDateForMonthlyView(
        productDate: String,
        addonPeriod: Int,
        startDateString: String
    ) -> CGFloat {
        let xPosition = getCellXPositionByDate(productDate: productDate)
        if xPosition != 0 {
            return xPosition
        } else {
            guard let expireDate = getDateFromString(productDate) else { return 0 }
            for (dateStr, _) in dictOfDatesAndXPositions {
                if let date = getDateFromString(dateStr) {
                    guard let startDate = getDateFromString(startDateString) else { return 0 }
                    let startDateDay = Calendar.current.dateComponents([.day], from: startDate)
                    let firstDate = Calendar.current.dateComponents([.day, .month], from: expireDate)
                    let secondDate = Calendar.current.dateComponents([.day, .month], from: date)
                    if firstDate.month == secondDate.month {
                        var xPotition: CGFloat = 0
                        if addonPeriod % 7 > 3 && Set([1, 8, 15, 22]).contains(startDateDay.day) {
                            xPotition = ((Constants.AddOnsTimeline.timelineDateViewsHorizontalSpacing
                                + Constants.AddOnsTimeline.timelineDateViewWidth) / 2) +
                                (dictOfDatesAndXPositions[dateStr] ?? 0)
                        } else {
                            let numberOfWeeks = Double(addonPeriod) / 7.0
                            let diff = CGFloat(numberOfWeeks.rounded())
                            xPotition = ((Constants.AddOnsTimeline.timelineDateViewsHorizontalSpacing
                                + Constants.AddOnsTimeline.timelineDateViewWidth) * diff) +
                                (dictOfDatesAndXPositions[startDateString] ?? 0)
                        }
                        if  Date() > startDate && Date() < expireDate {
                            xPotition += (Constants.AddOnsTimeline.timelineDateViewsHorizontalSpacing
                                + Constants.AddOnsTimeline.timelineDateViewWidth)
                        }
                        dictOfDatesAndXPositions[productDate] = xPotition
                        return xPotition
                    }
                }
            }
        }
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        yPositionForItemAtIndexPath indexPath: IndexPath
    ) -> CGFloat {
        var yPosition: CGFloat = 0
        if isTimelineView && indexPath.row < timelineProducts.count {
            let product: AddOnsProductModel = timelineProducts[indexPath.row]
            if indexPath.row == 0 {
                yPosition = 0
            } else {
                if !product.toBeRenewedProduct && !product.expiredAndRenewedProduct {
                    yPosition =
                        timeLineCollectionViewCellsYPosition[indexPath.row - 1] +
                        Constants.AddOnsTimeline.timelineCellHeight +
                        Constants.AddOnsTimeline.timelineCellVerticallSpacing
                    if indexPath.row == 1 {
                        yPosition += Constants.AddOnsTimeline.timelineCellStartYPosition
                    }
                } else { // -- if toBeRenewed or Expired cell
                    if product.addonType == AddOnsTypeLocalize.myPlan.localizedString {
                        // if myPlan && toBeRenewed/Expired
                        yPosition = Constants.AddOnsTimeline.timelineCellStartYPosition
                    } else {
                        yPosition = getYPositionForToBeRenewedCell(product: product)
                    }
                }
            }
            timeLineCollectionViewCellsYPosition.append(yPosition)
            return yPosition
        }
        return 0
    }

    func getYPositionForToBeRenewedCell(product: AddOnsProductModel) -> CGFloat {
        let addonPeriod = calculateAddonPeriod(product)
        if timelineProducts.isEmpty {
            return 0
        }
        for (index, element) in timelineProducts.enumerated() {
            if element.identifier == product.identifier
                && calculateAddonPeriod(element) == calculateAddonPeriod(product) {
                if addonPeriod == 0 && (element.addOnDetails?.startDate ==
                    getPreviousDateString(product.addOnDetails?.startDate ?? "") ||
                    element.addOnDetails?.expirationDate ==
                    getNextDateString(product.addOnDetails?.expirationDate ?? "")) {
                    if timeLineCollectionViewCellsYPosition.count > index {
                        return timeLineCollectionViewCellsYPosition[index]
                    }
                } else if element.addOnDetails?.expirationDate
                    == product.addOnDetails?.startDate || element.addOnDetails?.startDate
                    == product.addOnDetails?.expirationDate {
                    if timeLineCollectionViewCellsYPosition.count > index {
                        return timeLineCollectionViewCellsYPosition[index]
                    }
                } else if product.addOnDetails?.renewalType == .monthly {
                    if timeLineCollectionViewCellsYPosition.count > index {
                        return timeLineCollectionViewCellsYPosition[index]
                    }
                }
            }
        }
        return 0
    }

    func collectionView( _ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        if isTimelineView && indexPath.row < timelineProducts.count {
            let product = timelineProducts[indexPath.row] // height changes for MY plan cell type
            if product.addonType == AddOnsTypeLocalize.myPlan.localizedString &&
                !product.expiredAndRenewedProduct &&
                !product.toBeRenewedProduct { // if cell is my plan
                return Constants.AddOnsTimeline.timelineCurrentPlanCellHeight
            } else {
                return Constants.AddOnsTimeline.timelineCellHeight
            }
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, widthForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellPadding: CGFloat = 10
        var cellWidth = CGFloat((Constants.AddOnsTimeline.timelineDateViewsHorizontalSpacing +
            Constants.AddOnsTimeline.timelineDateViewWidth))
        if isTimelineView && indexPath.row < timelineProducts.count {
            let product: AddOnsProductModel = timelineProducts[indexPath.row]
            let productStartDate = product.addOnDetails?.startDate
            let productExpiryDate = product.addOnDetails?.expirationDate
            let titleWidth = product.title?.widthOfString(usingFont: UIFont.vodafoneBold(16)) ?? 0
            let addonperiod = calculateAddonPeriod(product)
            if isDailyView {
                if addonperiod > 1 {
                    let xPositionStartDate = getCellXPositionByDate(productDate: productStartDate ?? "")
                    let xPositionEndDate = getCellXPositionByDate(productDate: productExpiryDate ?? "")
                    cellWidth = xPositionEndDate - xPositionStartDate
                } else if addonperiod < 1 {
                    cellWidth = cellWidth / 2 + titleWidth + cellPadding
                } else { // addonPeriod = 1
                    cellWidth += titleWidth + cellPadding
                }
                return cellWidth
            } else {
                if addonperiod > 8 {
                    let xPositionStartDate = getCellXPositionByDateForMonthlyView(productDate: productStartDate ?? "")
                    let xPositionEndDate = getCellXEndPositionByDateForMonthlyView(
                        productDate: productExpiryDate ?? "",
                        addonPeriod: addonperiod,
                        startDateString: productStartDate ?? "")
                    cellWidth = xPositionEndDate - xPositionStartDate
                } else if addonperiod < 8 {
                    cellWidth = cellWidth / 2 + titleWidth + cellPadding

                    if  Date() > getDateFromString(productStartDate ?? "") ?? Date() &&
                        Date() < getDateFromString(productExpiryDate ?? "") ?? Date() {
                        cellWidth = 1.5 * (Constants.AddOnsTimeline.timelineDateViewsHorizontalSpacing
                        + Constants.AddOnsTimeline.timelineDateViewWidth)
                    }
                } else {
                    cellWidth += titleWidth + cellPadding
                }
                return cellWidth
            }
        }
        return 0
    }

    func calculateAddonPeriod(_ product: AddOnsProductModel) -> Int {
        var addOnPeriod = 0
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let expirationDate = dateFormatter.date(from: product.addOnDetails?.expirationDate ?? "") {
            if let startDate = dateFormatter.date(from: product.addOnDetails?.startDate ?? "") {
                let diff = calendar.dateComponents([.day], from: startDate, to: expirationDate)
                addOnPeriod = diff.day ?? 0
            }
        }
        return addOnPeriod
    }
}
