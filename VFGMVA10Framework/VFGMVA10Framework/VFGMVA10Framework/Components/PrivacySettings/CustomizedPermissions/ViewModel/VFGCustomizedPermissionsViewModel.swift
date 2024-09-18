//
//  VFGCustomizedPermissionsViewModel.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 13/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public enum PermissionsEntryPoint {
    case personalizedRecommendations
    case contactPreferences
    case thirdPartyAppTracking
}

class VFGCustomizedPermissionsViewModel {
    var model: PrivacySettingsPermissionsModel?
    var initialModel: PrivacySettingsPermissionsModel?
    var dataProvider: PrivacySettingsDataProviderProtocol?

    var contentState: VFGContentState = .empty {
        didSet {
            self.updateStatus?()
        }
    }
    var updateStatus: (() -> Void)?

    init(dataProvider: PrivacySettingsDataProviderProtocol?) {
        self.dataProvider = dataProvider
    }

    func fetchPersonalizedData(
        entryPoint: PermissionsEntryPoint,
        completion: (() -> Void)? = nil
    ) {
        contentState = .loading
        switch entryPoint {
        case .personalizedRecommendations:
            fetchPersonalizedRecommendations(completion: completion)
        case .contactPreferences:
            fetchContactPreferences(completion: completion)
        case .thirdPartyAppTracking:
            fetchAppTracking(completion: completion)
        }
    }

    func fetchPersonalizedRecommendations(completion: (() -> Void)? = nil) {
        dataProvider?.fetchPersonalizedRecommendations { [weak self] model, error in
            guard let self = self else { return }
            if error != nil {
                self.contentState = .error
                return
            }
            guard let model = model else {
                return
            }
            self.model = model
            self.initialModel = model
            self.contentState = .populated
            completion?()
        }
    }

    func fetchContactPreferences(completion: (() -> Void)? = nil) {
        dataProvider?.fetchContactPreferences { [weak self] model, error in
            guard let self = self else { return }
            if error != nil {
                self.contentState = .error
                return
            }
            guard let model = model else {
                return
            }
            self.model = model
            self.initialModel = model
            self.contentState = .populated
            completion?()
        }
    }

    func fetchAppTracking(completion: (() -> Void)? = nil) {
        dataProvider?.fetchAppTracking { [weak self] model, error in
            guard let self = self else { return }
            if error != nil {
                self.contentState = .error
                return
            }
            guard let model = model else {
                return
            }
            self.model = model
            self.initialModel = model
            self.contentState = .populated
            completion?()
        }
    }

    func isConfirmButtonEnabled() -> Bool {
        return initialModel != model
    }

    func changeAdvancedPermissionsState(to state: Bool) {
        let count = model?.advancedPermissions?.count ?? 1
        for index in 0...count - 1 {
            model?.advancedPermissions?[index].state = state
        }
    }

    func resetConfirmButton() {
        initialModel = model
    }
}

extension VFGCustomizedPermissionsViewModel {
    func didPressOnToggle(for indexPath: IndexPath, entryPoint: PermissionsEntryPoint = .personalizedRecommendations) {
        switch indexPath.section {
        case 1:
            model?.basicPermission?.state.toggle()
        case 2:
            if entryPoint == .contactPreferences {
                model?.singlePermissions?[indexPath.row].state.toggle()
            } else {
                didPressOnAdvancedToggle(for: indexPath)
            }
        case 3:
            if entryPoint == .contactPreferences {
                didPressOnAdvancedToggle(for: indexPath)
            } else {
                model?.singlePermissions?[indexPath.row].state.toggle()
            }
        default:
            break
        }
    }

    func didPressOnAdvancedToggle(for indexPath: IndexPath) {
        // Toggle all secondary advanced permissions according to main advanced permission.
        if indexPath.row == 0 {
            model?.advancedPermissions?[indexPath.row].state.toggle()
            if model?.advancedPermissions?[indexPath.row].state ?? false {
                changeAdvancedPermissionsState(to: true)
            } else {
                changeAdvancedPermissionsState(to: false)
            }
            return
        }
        // Toggle the secondary advanced permissions, then check if all secondary are off the main will turn off automatically.
        if model?.advancedPermissions?[0].state ?? false {
            model?.advancedPermissions?[indexPath.row].state.toggle()
            let count = model?.advancedPermissions?.count ?? 2
            for index in 1...count - 1 where model?.advancedPermissions?[index].state ?? false {
                return
            }
            model?.advancedPermissions?[0].state = false
        } else {
            return
        }
    }
}

extension VFGCustomizedPermissionsViewModel {
    func numberOfRowInSection(section: Int, entryPoint: PermissionsEntryPoint) -> Int {
        switch section {
        case 0:
            return model?.infoSection?.count ?? 0
        case 1:
            return model?.basicPermission != nil ? 1 : 0
        case 2:
            if entryPoint == .contactPreferences {
                return model?.singlePermissions?.count ?? 0
            } else {
                return model?.advancedPermissions?.count ?? 0
            }
        case 3:
            if entryPoint == .contactPreferences {
                return model?.advancedPermissions?.count ?? 0
            } else {
                return model?.singlePermissions?.count ?? 0
            }
        default:
            return 0
        }
    }
}
