//
//  VFPermissionsViewModel.swift
//  VFGMVA10Group
//
//  Created by Yahya Saddiq on 3/1/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import UIKit

/// Permissions view model.
public class VFPermissionsViewModel {
    var permissionManager: VFGPermissionManagerProtocol
    weak var delegate: VFPermissionViewModelProtocol?
    var permissionCards: [VFPermissionCardViewModel] = []
    var requiredPermissions: [VFGPermission] = []
    var msisdn: String?
    let userInfo: [String: Any]
    let stepTitle: String
    let headerTitle: String
    let customPermissionTypes: [VFGPermissionType] = [.network, .custom(type: "VFGPersonalizedNetworkPermission")]
    var grantedNativePermissionsCount = 0
    var receivedPermissionStatusCount = 0
    var analyticsManager = VFGAnalyticsManager.self
    var confirmationButtonColor: UIColor = .VFGRedDefaultBackground
    var defaultPermissionStatus = true

    weak var trackingDelegate: VFGPermissionsTrackingProtocol?

    /// Initializer for VFPermissionsViewModel.
    /// - Parameters:
    ///   - permissions: List of *VFGPermission*.
    ///   - config: Dictionary of *[String: Any]?*.
    ///   - msisdn: MSISDN is a unique string.
    ///   - permissionManager: *VFGPermissionManagerProtocol*.
    ///   - trackingDelegate: *VFGPermissionsTrackingProtocol*.
    ///   - confirmationButtonColor: confirmation button color, default is red.
    public init(
        permissions: [VFGPermission],
        config: [String: Any]?,
        msisdn: String? = nil,
        permissionManager: VFGPermissionManagerProtocol = VFGPermissionManager(),
        trackingDelegate: VFGPermissionsTrackingProtocol?,
        confirmationButtonColor: UIColor = .VFGRedDefaultBackground
    ) {
        self.stepTitle = (config?["title"] as? String) ?? ""
        self.headerTitle = (config?["description"] as? String) ?? ""
        self.requiredPermissions = permissions
        self.permissionManager = permissionManager
        self.msisdn = msisdn
        self.userInfo = ["msisdn": msisdn ?? ""]
        self.trackingDelegate = trackingDelegate
        self.confirmationButtonColor = confirmationButtonColor
    }

    public func setupPermissionCards() {
        permissionCards = []
        receivedPermissionStatusCount = 0
        setupPermissionCards(requiredPermissions)
    }
    /// Recursion method to fetch both parent and dependent permissions
    /// and append to permissionsCard which is used to draw the view
    /// - Parameters:
    ///   - permissions: contains both permissions and sub-permissions
    ///   - parentIndex: always nil, except when fetching defendant permissions
    private func setupPermissionCards(_ permissions: [VFGPermission], parentIndex: Int? = nil) {
        var dependentIndex: Int = 0
        if let parentIndex = parentIndex {
            dependentIndex = parentIndex + 1
        }

        for (index, permission) in permissions.enumerated() {
            let index = dependentIndex == 0 ? index : dependentIndex
            permissionManager.permissionStatus(type: permission.type) { [weak self] permissionsStatus, error in
                guard error == nil,
                    let self = self else {
                    return
                }
                let shouldRequestPermission = (permissionsStatus == .allowed
                    || (permissionsStatus == .notDetermined && permission.defaultStatus))

                var permissionCardViewModel = VFPermissionCardViewModel(
                    permission: permission,
                    permissionStatus: permissionsStatus,
                    cardIndex: index,
                    parentIndex: parentIndex,
                    shouldRequestPermission: shouldRequestPermission)

                permissionCardViewModel.toggleValueChanged = { [weak self] state in
                    guard let self = self else { return }
                    self.switchValueChanged(
                        state: state,
                        cardIndex: index,
                        parentIndex: parentIndex
                    )
                }
                self.permissionCards.append(permissionCardViewModel)
                dependentIndex = dependentIndex == 0 ? dependentIndex : dependentIndex + 1
                if !(permission.dependents.isEmpty) {
                    self.setupPermissionCards(permission.dependents, parentIndex: index)
                }
                self.receivedPermissionStatusCount += 1
                if self.receivedPermissionStatusCount == self.requiredPermissions.count {
                    self.delegate?.permissionCardsDidSetup()
                }
            }
        }
    }
    /// Request permissions from the Permissions Manager for enabled native permissions only
    /// Native permissions are those which ask for user acceptance with alert
    /// - Parameter completionBlock: empty completion
    func requestPermissions(_ completionBlock: @escaping () -> Void) {
        let enabledNativePermissionsTypes = permissionCards
            .filter { $0.shouldRequestPermission && !customPermissionTypes.contains( $0.type) }
            .map { $0.type }

        if enabledNativePermissionsTypes.isEmpty {
            completionBlock()
        } else {
            permissionManager.requestPermissions(types: enabledNativePermissionsTypes) { [weak self] result, error in
                guard let self = self,
                    error == nil else {
                        if let error = error {
                            VFGErrorLog(error.localizedDescription)
                        }
                        return
                }

                switch result.permissionStatus {
                case .allowed:
                    self.trackPermission(
                        result.permissionType,
                        for: "analytics_framework_permissions_pop_up".localized(bundle: .mva10Framework),
                        visitorPermissionFunctional:
                            "analytics_framework_visitor_permission_functional_enabled".localized(
                                bundle: .mva10Framework
                            ),
                        visitorPermissions: self.enabledPermissions(),
                        permissionName: "\(result.permissionType)")
                    self.grantedNativePermissionsCount += 1
                case .denied:
                    self.trackPermission(
                        result.permissionType,
                        for: "analytics_framework_permissions_pop_up".localized(bundle: .mva10Framework),
                        visitorPermissionFunctional:
                            "analytics_framework_visitor_permission_functional_disabled".localized(
                                bundle: .mva10Framework
                            ),
                        visitorPermissions: self.enabledPermissions(),
                        permissionName: "\(result.permissionType)")
                    self.grantedNativePermissionsCount += 1
                case .notDetermined:
                    break
                }
                if enabledNativePermissionsTypes.count == self.grantedNativePermissionsCount {
                    completionBlock()
                }
            }
        }
    }
    /// Request a permission of a type
    /// return the status of requested permission with a completionBlock
    /// - Parameter permissionType: permission type to be requested
    func requestPermission(
        permissionType: VFGPermissionType,
        _ completionBlock: @escaping (
        _ status: VFGPermissionStatus,
        _ error: NSError?) -> Void
    ) {
        permissionManager.requestPermission(type: permissionType) { status, error in
            guard error == nil else {
                return
            }
            completionBlock(status, nil)
        }
    }
    /// Set permissions from the Permissions Manager for enabled custom permissions only
    /// Custom permissions are alert-less permissions, which don't ask for user acceptance.
    func setPermissions() {
        let enabledCustomPermissionsTypes = permissionCards
            .filter { $0.shouldRequestPermission && customPermissionTypes.contains($0.type) }
            .map { $0.type }

        let disabledCustomPermissionsTypes = permissionCards
            .filter { !$0.shouldRequestPermission && customPermissionTypes.contains($0.type) }
            .map { $0.type }

        if !enabledCustomPermissionsTypes.isEmpty {
            // enable custom permissions
            permissionManager.setPermissions(
                types: enabledCustomPermissionsTypes,
                status: true,
                info: userInfo) { _, _ in }
        }
        if !disabledCustomPermissionsTypes.isEmpty {
            // disable custom permissions
            permissionManager.setPermissions(
                types: disabledCustomPermissionsTypes,
                status: false,
                info: userInfo) { _, _ in }
        }
    }

    func setPermission(at index: Int, state: Bool) {
        permissionManager.setPermission(
            type: permissionCards[index].type,
            status: state,
            info: userInfo) { status, error in
                guard error == nil else {
                    if let error = error {
                        // todo: on error, should reset toggle button
                        VFGErrorLog(error.localizedDescription)
                    }
                    return
                }

            self.permissionCards[index].permissionStatus = status
        }
    }
    /// hides views of dependents
    /// and, sets the dependents' states to false
    /// - Parameter dependentIndex: index of dependent
    func hideDependents(at dependentIndex: Int) {
        for index in dependentIndex..<permissionCards.count {
            delegate?.hideView(at: index)
        }
    }
    /// shows views of dependents
    /// and sets the dependents' state to true
    /// - Parameter dependentIndex: index of dependent
    func showDependents(at dependentIndex: Int) {
        for index in dependentIndex..<permissionCards.count {
            delegate?.showView(at: index)
        }
    }
    /// gets called when the state of parent or dependents change
    /// - Parameters:
    ///   - state: the new state
    ///   - cardIndex: the index of permissions card
    func switchValueChanged(state: Bool, cardIndex: Int, parentIndex: Int?) {
        guard let index = permissionCards.firstIndex(
            where: { $0.cardIndex == cardIndex && $0.parentIndex == parentIndex }) else { return }
        permissionCards[index].shouldRequestPermission = state
        // Checks if permission has dependents
        if permissionCards.indices.contains(cardIndex),
            !(permissionCards.filter { $0.parentIndex == cardIndex }.isEmpty) {
            let dependentIndex = cardIndex + 1
            if state == false {
                hideDependents(at: dependentIndex)
            } else {
                showDependents(at: dependentIndex)
            }
        } else {
            delegate?.dependentPermissionStatusDidChange(state: state, index: cardIndex)
        }

        if state == true {
            trackPermission(
                permissionCards[index].type,
                for: "analytics_framework_permissions_active".localized(bundle: .mva10Framework),
                visitorPermissionFunctional: "analytics_framework_visitor_permission_functional_enabled".localized(
                    bundle: .mva10Framework
                ),
                visitorPermissions: enabledPermissions(),
                permissionName: "\(permissionCards[index].type)")
        } else {
            trackPermission(
                permissionCards[index].type,
                for: "analytics_framework_permissions_active".localized(bundle: .mva10Framework),
                visitorPermissionFunctional: "analytics_framework_visitor_permission_functional_disabled".localized(
                    bundle: .mva10Framework
                ),
                visitorPermissions: enabledPermissions(),
                permissionName: "\(permissionCards[index].type)")
        }
    }
    /// Returns a permission from permission list
    /// - Parameter index: index of a permission in a list
    /// - Returns: a permission model or nil on invalid index
    func getPermissionCardViewModel(at index: Int) -> VFPermissionCardViewModel? {
        guard index < permissionCards.count else {
            return nil
        }
        return permissionCards[index]
    }
    /// Returns number of all permission cards in the permission list
    /// - Returns: an integer of count
    func numberOfPermissions() -> Int {
        return permissionCards.count
    }
    /// Returns number of parents and (allowed or denied) sub permission cards in the permission list
    /// - Returns: an integer of count
    func numberOfEnabledPermissions() -> Int {
        return permissionCards.filter { $0.parentIndex == nil
            || permissionCards[$0.parentIndex ?? 0].permissionStatus == .allowed
        }.count
    }
}
