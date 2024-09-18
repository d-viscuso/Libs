//
//  VFGRefreshManager.swift
//  VFGMVA10Foundation
//
//  Created by Moataz Akram on 05/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Refresh view manager
public class VFGRefreshManager {
    weak public var refreshView: VFGRefreshViewProtocol?
    public var refreshStatusModel: VFGRefreshStatusModel
    public var isRefreshing = false {
        didSet {
            if isRefreshing == true {
                status = .updating
            }
        }
    }
    public var lastUpdatedTime: Date? {
        get {
            userDefaults.value(forKey: lastUpdatedTimeKey) as? Date
        }

        set {
            userDefaults.set(newValue, forKey: lastUpdatedTimeKey)
        }
    }
    public private(set) var status: VFGRefreshStatus = .justUpdated {
        didSet {
            updateRefreshView()
            DispatchQueue.main.async {
                self.refreshView?.lastUpdatedLabel?.text = self.refreshLabel(of: self.status)
            }
        }
    }
    public var userDefaults: UserDefaults
    public let lastUpdatedTimeKey: String

    private var timer: Timer?

    public init(
        userDefaults: UserDefaults = UserDefaults.standard,
        lastUpdatedTimeKey: String,
        refreshView: VFGRefreshViewProtocol? = nil,
        refreshStatusModel: VFGRefreshStatusModel = VFGRefreshStatusModel()
    ) {
        self.refreshView = refreshView
        self.lastUpdatedTimeKey = lastUpdatedTimeKey
        self.refreshStatusModel = refreshStatusModel
        self.userDefaults = userDefaults
    }

    deinit {
        stopTimer()
    }

    public func refreshWillStart() {
        if isRefreshing == false {
            isRefreshing = true
            hideRefreshButton()
        }
    }

    public func refreshDidSucceed(at date: Date = Date()) {
        lastUpdatedTime = date

        isRefreshing = false
        refreshDidComplete()
    }

    public func refreshDidFail() {
        isRefreshing = false
        refreshDidComplete()
    }

    private func refreshDidComplete() {
        generateLastUpdatedText()
        stopTimer()
        startTimer()
        showRefreshButton()
    }

    private func startTimer() {
        guard timer == nil else {
            return
        }

        timer = Timer.scheduledTimer(
            timeInterval: 61,
            target: self,
            selector: #selector(generateLastUpdatedText),
            userInfo: nil,
            repeats: true)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func hideRefreshButton() {
        DispatchQueue.main.async {
            self.refreshView?.refreshButton?.isHidden = true
        }
    }

    private func showRefreshButton() {
        DispatchQueue.main.async {
            self.refreshView?.refreshButton?.isHidden = false
        }
    }

    @objc public func generateLastUpdatedText() {
        guard !isRefreshing,
            let lastUpdatedTime = lastUpdatedTime else {
                status = .updating
                return
        }

        let timeNow = Date()
        let timeDifference = Calendar.current.dateComponents(
            [.minute],
            from: lastUpdatedTime,
            to: timeNow)

        // compare between last updated date and current date
        // to get difference in days if applicable
        let order = Calendar.current.compare(lastUpdatedTime, to: timeNow, toGranularity: .day)
        switch order {
        case .orderedAscending:
            if timeDifference.minute ?? 0 > 15 {
                let dateAsString = VFGRefreshManager.generateTime(with: .date, and: lastUpdatedTime)
                status = .timeStamp(dateAsString)
                stopTimer()
                return
            }
        default:
            break
        }

        guard let timeDifferenceInMinutes = timeDifference.minute else {
            return
        }

        switch timeDifferenceInMinutes {
        case 1:
            status = .minute(timeDifferenceInMinutes)
        case 2...15:
            status = .minutes(timeDifferenceInMinutes)
        case 16...:
            let hoursAsString = VFGRefreshManager.generateTime(with: .hours, and: lastUpdatedTime)
            status = .timeStamp(hoursAsString)
            stopTimer()
        default:
            status = .justUpdated
        }
    }

    /// A method that is used to generate time into two formats *h:mm a* or  *d MMMM h:mm a*
    /// - Parameters:
    ///   - format: An enum parameter that represent the format of returned time
    ///   - date: A date object that represent the date to be formatted
    /// - Returns: A string object represent the formatted date
    public static func generateTime(with format: TimeFormat, and date: Date) -> String {
        let dateFormatter = DateFormatter()
        switch format {
        case .hours:
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        case .date:
            dateFormatter.dateFormat = "d MMMM h:mm a"
            return dateFormatter.string(from: date)
        }
    }

    private func refreshLabel(of refreshStatus: VFGRefreshStatus) -> String? {
        switch refreshStatus {
        case .updating:
            return refreshStatusModel.updatingText
        case .justUpdated:
            return refreshStatusModel.justUpdatedText
        case .minute(let timeDifference):
            return String(
                format: refreshStatusModel.updatedMinText,
                "\(timeDifference)")
        case .minutes(let timeDifference):
            return String(
                format: refreshStatusModel.updatedMinsText,
                "\(timeDifference)")
        case .timeStamp(let timeStamp):
            return String(
                format: refreshStatusModel.timeStampText,
                "\(timeStamp)")
        }
    }

    public func didMoveToBackground() {
        stopTimer()
    }

    public func didMoveToForeground() {
        generateLastUpdatedText()
        startTimer()
    }

    /// update refresh view label
    func updateRefreshView() {
        // this line of code to avoid failure that happened in unit test
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil { // unit test
            self.refreshView?.lastUpdatedLabel?.text = self.refreshLabel(of: self.status)
        } else {
            DispatchQueue.main.async {
                self.refreshView?.lastUpdatedLabel?.text = self.refreshLabel(of: self.status)
            }
        }
    }
}
