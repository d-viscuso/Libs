//
//  EverythingIsOkStream.swift
//  VFGMVA10Group
//
//  Created by Mahmoud Amer on 3/19/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

/// EIO Status Enum
public enum EIOStatus: Int, Codable {
    case success
    case failed
    case inProgress
}

/// Everything Is Okay Stream Class
open class EverythingIsOkStream: VFGEIOModelProtocol {
    /// EIO Delegate Object
    weak public var EIOManagerDelegate: VFGEIOManagerProtocol?
    /// Dashboard Manager Delegate
    weak public var dashboardManagerDelegate: VFGDashboardManagerProtocol?
    /// EIO Model
    open var model: EverythingIsOkModel?

    /// EIO Status
    open var eioStatus: EIOStatus {
        return overallStatus()
    }

    /// EIO Enabled Ability
    public var isEIOEnabled: Bool?
    /// EIO Updated Item Status
    public var updatedItem: Int?
    /// EIO Ability to use Pull to show
    public var pullToShowEIO = true
    /// EIO has status
    var hasStatus = false
    /// EIO is created status
    var isSettingUp = false

    public init() {}

    /// Update Item creation
    /// - Parameters:
    ///    - itemId: The Id for the updated item
    ///    - status: The status for the updated item
    public func updateItem(itemId: String, status: Int) {
        guard let checks = model?.checks else {
            return
        }
        if let item = checks.enumerated().first(where: { $0.element.itemId == itemId }) {
            updatedItem = item.offset
            item.element.status = EIOStatus(rawValue: status)
        } else {
            let items = checks.compactMap { $0.subItems }.reduce([], +)
            if let item = items.first(where: { $0.subItemId == itemId }) {
                item.status = EIOStatus(rawValue: status)
                newParentStatus(item: item)
            }
        }
    }

    func newParentStatus(item: EverythingIsOkSubItem) {
        guard let checks = model?.checks else {
            return
        }
        if let parentItem = checks.enumerated().first(where: {
            $0.element.subItems?.contains(where: { $0.subItemId == item.subItemId }) ?? false
        }) {
            if let subItems = parentItem.element.subItems?.compactMap({ $0.status }) {
                parentItem.element.status = statusFrom(array: subItems)
            }
            updatedItem = parentItem.offset
        }
    }

    open func broadcastEIOKChanges() {
        EIOManagerDelegate?.statusUpdated()
        hasStatus = true
        if isSettingUp {
            dashboardManagerDelegate?.EIOSetupFinished(error: nil)
            isSettingUp = false
        }
    }

    private func overallStatus() -> EIOStatus {
        guard let checks = model?.checks else {
            return .failed
        }
        var status: [EIOStatus] = []
        checks.forEach { checkItem in
            guard let statusForEachItem = statusFromEach(item: checkItem) else {
                return
            }
            status.append(statusForEachItem)
            checkItem.status = statusForEachItem
        }
        return statusFrom(array: status)
    }

    func statusFrom(array: [EIOStatus]) -> EIOStatus {
        if !(array.filter { $0 == .inProgress }.isEmpty) {
            return .inProgress
        }
        if !(array.filter { $0 == .failed }.isEmpty) {
            return .failed
        }
        return .success
    }

    func statusFromEach(item: CheckItem) -> EIOStatus? {
        if let subItems = item.subItems {
            var status: [EIOStatus] = []
            status = subItems.compactMap { $0.status }
            return statusFrom(array: status)
        } else {
            return item.status
        }
    }

    /// EIO Setup Method 
    public func setup() {
        if hasStatus {
            dashboardManagerDelegate?.EIOSetupFinished(error: nil)
        } else {
            isSettingUp = true
            _ = overallStatus()
        }
    }
}
