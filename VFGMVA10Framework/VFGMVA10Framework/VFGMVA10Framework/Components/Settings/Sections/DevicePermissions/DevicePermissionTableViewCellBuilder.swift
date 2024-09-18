//
//  DevicePermissionTableViewCellBuilder.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 06/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Construct device permission cell
public class DevicePermissionTableViewCellBuilder: TableViewCellBuilderProtocol {
    private var viewModel: VFPermissionsViewModel?
    private let height: CGFloat
    private let target: VFGSettingItemProtocol.Type?
    private let permissions: [VFGPermission]
    private var customPermissions: [VFGPermissionProtocol]?
    private weak var delegate: SettingsViewControllerDelegate?
    private weak var trackingDelegate: VFGPermissionsTrackingProtocol?
    /// *DevicePermissionTableViewCellBuilder* initializer
    /// - Parameters:
    ///    - permissions: Device permissions list
    ///    - customPermissions: Device custom permissions list
    ///    - height: Device permission cell height
    ///    - delegate: Delegation for *SettingsViewController* actions
    ///    - trackingDelegate: Delegation for permission tracking
    public init(
        permissions: [VFGPermission],
        customPermissions: [VFGPermissionProtocol]? = nil,
        height: CGFloat,
        target: VFGSettingItemProtocol.Type? = nil,
        delegate: SettingsViewControllerDelegate? = nil,
        trackingDelegate: VFGPermissionsTrackingProtocol? = nil
    ) {
        self.permissions = permissions
        self.height = height
        self.target = target
        self.delegate = delegate
        self.trackingDelegate = trackingDelegate
        self.customPermissions = customPermissions

        buildPermissionViewModel()
    }

    public func registerCell(in tableView: UITableView) {
        tableView.register(
            UINib(
                nibName: String(describing: VFGChevronCell.self),
                bundle: .mva10Framework),
            forCellReuseIdentifier: String(describing: VFGChevronCell.self)
        )
    }

    public func cellHeight() -> CGFloat {
        height
    }

    public func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        guard let devicePermissionsCell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: VFGChevronCell.self),
                for: indexPath) as? VFGChevronCell else {
            return UITableViewCell()
        }
        devicePermissionsCell.configure(
            title: "settings_device_permissions_title".localized(bundle: .mva10Framework),
            subtitle: "settings_device_permissions_subtitle".localized(bundle: .mva10Framework),
            iconImageName: "padlock_close",
            type: .oneCard
        )
        devicePermissionsCell.selectionStyle = .none
        return devicePermissionsCell
    }

    public func didSelectRowAt(indexPath: IndexPath, tableView: UITableView) {
        guard let target = target,
            let viewController = target.viewController() else {
            return
        }

        if let viewController = viewController as? VFGPermissionsViewController {
            viewController.viewModel = viewModel
        }

        AppSettingsManager.trackAction(
            eventLabel: "analytics_framework_event_label_device_permissions".localized(bundle: .mva10Framework),
            pageName: "analytics_framework_page_name_app_settings".localized(bundle: .mva10Framework)
        )
        delegate?.push(viewController: viewController, animated: true)
    }

    public func willDisplay(cell: UITableViewCell, indexPath: IndexPath, tableView: UITableView) {
        guard let cell = cell as? VFGChevronCell else { return }
        cell.type = .oneCard
    }
}

// MARK: - Private Methods
extension DevicePermissionTableViewCellBuilder {
    private func buildPermissionViewModel() {
        viewModel = VFPermissionsViewModel(
            permissions: permissions,
            config: nil,
            msisdn: OAuth2Authentication.getMSISDIN(key: "token"),
            permissionManager: VFGPermissionManager(customPermissions: customPermissions),
            trackingDelegate: trackingDelegate)

        viewModel?.setupPermissionCards()
    }
}
