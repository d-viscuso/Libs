//
//  AppPermissionTableViewCellBuilder.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 06/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Construct app permission cell
public class AppPermissionTableViewCellBuilder: TableViewCellBuilderProtocol {
    /// Permissions view model
    var viewModel: VFPermissionsViewModel?
    /// App permission cell height
    private let height: CGFloat
    /// App permissions list
    private let permissions: [VFGPermission]
    /// App custom permissions list
    private var customPermissions: [VFGPermissionProtocol]?
    /// Delegation for *SettingsViewController* actions
    weak private var delegate: SettingsViewControllerDelegate?
    /// Delegation for permission tracking
    weak private var trackingDelegate: VFGPermissionsTrackingProtocol?
    weak var networkPermissionDelegate: VFGNetworkPermissionDelegate?
    /// *AppPermissionTableViewCellBuilder* initializer
    /// - Parameters:
    ///    - permissions: App permissions list
    ///    - customPermissions: App custom permissions list
    ///    - height: App permission cell height
    ///    - delegate: Delegation for *SettingsViewController* actions
    ///    - trackingDelegate: Delegation for permission tracking
    public init(
        permissions: [VFGPermission],
        customPermissions: [VFGPermissionProtocol]? = nil,
        height: CGFloat,
        delegate: SettingsViewControllerDelegate? = nil,
        trackingDelegate: VFGPermissionsTrackingProtocol? = nil,
        networkPermissionDelegate: VFGNetworkPermissionDelegate? = nil
    ) {
        self.permissions = permissions
        self.height = height
        self.delegate = delegate
        self.customPermissions = customPermissions
        self.trackingDelegate = trackingDelegate
        self.networkPermissionDelegate = networkPermissionDelegate
        buildPermissionViewModel()
    }

    public func cellHeight() -> CGFloat {
        height
    }

    public func registerCell(in tableView: UITableView) {
    }
    /// Permission view model configuration
    public func buildPermissionViewModel() {
        viewModel = VFPermissionsViewModel(
            permissions: permissions,
            config: nil,
            msisdn: OAuth2Authentication.getMSISDIN(key: "token"),
            permissionManager: VFGPermissionManager(
                customPermissions: customPermissions,
                delegate: networkPermissionDelegate),
            trackingDelegate: trackingDelegate
        )

        viewModel?.delegate = self
        viewModel?.setupPermissionCards()
    }

    public func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        guard
            let permissionCardViewModel = viewModel?.getPermissionCardViewModel(at: indexPath.row),
            let permissionCardView: VFPermissionViewCard =
                VFPermissionViewCard.loadXib(bundle: .mva10Framework) else {
            return cell
        }

        permissionCardView.configureForSettings(
            with: permissionCardViewModel,
            isReadOnly: false,
            isFirstCell: indexPath.row == 0,
            accessibilityIdentifierPrefix: "AP")

        if !cell.contentView.subviews.isEmpty {
            cell.contentView.removeSubviews()
        }

        let isFirstRow = indexPath.row == 0
        let isLastRow = (indexPath.row + 1) == tableView.numberOfRows(inSection: indexPath.section)

        cell.contentView.embed(
            view: permissionCardView,
            top: isFirstRow ? 17 : 0,
            bottom: isLastRow ? -10 : 0,
            leading: 16,
            trailing: -16
        )

        cell.selectionStyle = .none
        return cell
    }

    public func willDisplay(cell: UITableViewCell, indexPath: IndexPath, tableView: UITableView) {
        guard let permissionCardView = cell.contentView.subviews.first as? VFPermissionViewCard else {
            return
        }

        var cornersToRound = CACornerMask()

        if indexPath.row == 0 {
            cornersToRound.insert(.layerMinXMinYCorner)
            cornersToRound.insert(.layerMaxXMinYCorner)
        }

        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cornersToRound.insert(.layerMinXMaxYCorner)
            cornersToRound.insert(.layerMaxXMaxYCorner)
        }

        permissionCardView.layer.cornerRadius = 4
        permissionCardView.layer.maskedCorners = cornersToRound
        permissionCardView.addingShadow(size: CGSize(width: 0, height: 2), radius: 4, opacity: 0.16)
    }
}

extension AppPermissionTableViewCellBuilder: VFPermissionViewModelProtocol {
    func dependentPermissionStatusDidChange(state: Bool, index: Int) {
        viewModel?.setPermission(at: index, state: state)
    }

    func hideView(at index: Int) {
        switchViewState()
    }

    func showView(at index: Int) {
        viewModel?.permissionCards[index].shouldRequestPermission = false
        switchViewState()
    }

    private func switchViewState() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else {
                return
            }
            self.viewModel?.setPermissions()
            self.viewModel?.setupPermissionCards()
        }
    }

    func permissionCardsDidSetup() {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.reloadTableView()
        }
    }
}
