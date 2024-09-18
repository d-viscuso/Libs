//
//  VFGCustomizedPermissionsViewController.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 12/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Privacy settings 3rd level screen for personalized permissions
class VFGCustomizedPermissionsViewController: UIViewController {
    @IBOutlet weak var permissionsTableView: UITableView!
    @IBOutlet weak var confirmButton: VFGButton!
    var entryPoint: PermissionsEntryPoint = .personalizedRecommendations
    /// *VFGCustomizedPermissionsViewController* view model
    var viewModel: VFGCustomizedPermissionsViewModel?
    /// Quick action view showing result of confirming permissions changes
    public var quickActionsResultView: VFGQuickActionsResultView?

    private let infoSectionTableViewCell = "VFGInfoSectionTableViewCell"
    private let infoSectionTableViewCellID = "VFGInfoSectionTableViewCellID"
    private let privacyPermissionTableViewCell = "VFGPrivacyPermissionTableViewCell"
    private let privacyPermissionTableViewCellID = "VFGPrivacyPermissionTableViewCellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        confirmButton.setTitle("personal_preferences_confirm_button".localized(bundle: .mva10Framework), for: .normal)
        confirmButton.isEnabled = false
        initViewModel()
    }

    func initViewModel() {
        viewModel?.updateStatus = { [weak self] in
            guard let self = self else { return }
            switch self.viewModel?.contentState {
            case .populated:
                self.permissionsTableView.reloadData()
            default:
                break
            }
        }
        viewModel?.fetchPersonalizedData(entryPoint: entryPoint)
    }

    private func setupTableView() {
        permissionsTableView.delegate = self
        permissionsTableView.dataSource = self
        permissionsTableView.register(
            UINib(nibName: infoSectionTableViewCell, bundle: .mva10Framework),
            forCellReuseIdentifier: infoSectionTableViewCellID
        )
        permissionsTableView.register(
            UINib(nibName: privacyPermissionTableViewCell, bundle: .mva10Framework),
            forCellReuseIdentifier: privacyPermissionTableViewCellID
        )
        permissionsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    /// Responsible for presenting quick action success view after pressing on confirm button
    func presentQuickActionSuccessView() {
        let model = VFGQuickActionsResultModel(
            type: .success,
            delegate: self,
            titleText: "privacy_settings_quick_action_title".localized(bundle: .mva10Framework),
            descriptionText: "privacy_settings_quick_action_description".localized(bundle: .mva10Framework),
            primaryButtonTitle: "privacy_settings_quick_action_primary_button_text".localized(bundle: .mva10Framework),
            secondaryButtonTitle: "privacy_settings_quick_action_secondary_button_text"
                .localized(bundle: .mva10Framework),
            titleFont: .vodafoneBold(30),
            descriptionFont: .vodafoneRegular(19),
            primaryButtonFont: .vodafoneRegular(19),
            secondaryButtonFont: .vodafoneRegular(19))

        quickActionsResultView = VFGQuickActionsResultView(
            title: "privacy_settings_title".localized(bundle: .mva10Framework),
            isCloseButtonHidden: true,
            model: model
        )

        guard let quickActionsResultView = quickActionsResultView else { return }

        VFQuickActionsViewController.presentQuickActionsViewController(with: quickActionsResultView)
    }

    @IBAction func confirmButtonDidPress(_ sender: Any) {
        let topNavigationView = UIApplication.topViewController()?.trayViewController()?.view
        topNavigationView?.startLoadingAnimation(
            backgroundColor: .VFGWhiteBackground,
            title: "privacy_settings_loading_screen_title".localized(bundle: .mva10Framework),
            titleFont: .vodafoneRegular(17),
            titleTextColor: .VFGRedWhiteText)
        viewModel?.resetConfirmButton()
        confirmButton.isEnabled = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            topNavigationView?.endLoadingAnimation()
            self?.presentQuickActionSuccessView()
        }
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension VFGCustomizedPermissionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRowInSection(section: section, entryPoint: entryPoint) ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return setupInfoSectionCell(with: indexPath)
        case 1:
            return setupBasicPermissionCell(with: indexPath)
        case 2:
            if entryPoint == .contactPreferences {
                return setupSinglePermissionsCell(with: indexPath)
            } else {
                return setupAdvancedPreferencesCell(with: indexPath)
            }
        case 3:
            if entryPoint == .contactPreferences {
                return setupAdvancedPreferencesCell(with: indexPath)
            } else {
                return setupSinglePermissionsCell(with: indexPath)
            }
        default:
            return UITableViewCell()
        }
    }

    private func setupInfoSectionCell(with indexPath: IndexPath) -> UITableViewCell {
        if viewModel?.model?.infoSection?[indexPath.row].isExpanded == nil {
            viewModel?.model?.infoSection?[indexPath.row].isExpanded = false
        }
        guard let cell = permissionsTableView
            .dequeueReusableCell(
                withIdentifier: infoSectionTableViewCellID,
                for: indexPath) as? VFGInfoSectionTableViewCell,
            let model = viewModel?.model?.infoSection?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.model = model
        cell.setup(with: model, indexPath: indexPath, delegate: self)
        if indexPath.row != 0 {
            cell.infoSectionTopConstraint.constant = 0
        }
        return cell
    }

    private func setupBasicPermissionCell(with indexPath: IndexPath) -> UITableViewCell {
        guard let cell = permissionsTableView
            .dequeueReusableCell(
                withIdentifier: privacyPermissionTableViewCellID,
                for: indexPath) as? VFGPrivacyPermissionTableViewCell,
            let model = viewModel?.model?.basicPermission else {
            return UITableViewCell()
        }
        cell.setup(with: model, indexPath: indexPath, delegate: self)
        cell.containerTopConstraint.constant = 33
        cell.itemContainer.configureShadow()
        return cell
    }

    private func setupAdvancedPreferencesCell(with indexPath: IndexPath) -> UITableViewCell {
        guard let cell = permissionsTableView
            .dequeueReusableCell(
                withIdentifier: privacyPermissionTableViewCellID,
                for: indexPath) as? VFGPrivacyPermissionTableViewCell,
            let model = viewModel?.model?.advancedPermissions else {
            return UITableViewCell()
        }
        cell.itemContainer.configureShadow()
        cell.setup(with: model[indexPath.row], indexPath: indexPath, delegate: self)
        if indexPath.row != 0 {
            cell.separatorLeadingConstraint.constant = 64
        }
        let arrayCount = viewModel?.model?.advancedPermissions?.count ?? 1
        return configureCornerRadius(
            for: indexPath,
            cell: cell,
            arrayCount: arrayCount)
    }

    func configureCornerRadius(
        for indexPath: IndexPath,
        cell: VFGPrivacyPermissionTableViewCell,
        arrayCount: Int
    ) -> VFGPrivacyPermissionTableViewCell {
        switch arrayCount {
        case 1:
            cell.itemContainer.layer.cornerRadius = 6
        case 2:
            if indexPath.row == 0 {
                cell.separator.isHidden = false
                cell.containerBottomConstraint.constant = 0
                cell.itemContainer.roundUpperCorners(cornerRadius: 6)
            } else {
                cell.containerTopConstraint.constant = 0
                cell.itemContainer.roundBottomCorners(cornerRadius: 6)
            }
        default:
            if indexPath.row == 0 {
                cell.containerBottomConstraint.constant = 0
                cell.separator.isHidden = false
                cell.itemContainer.roundUpperCorners(cornerRadius: 6)
            } else if indexPath.row + 1 == arrayCount {
                cell.containerTopConstraint.constant = 0
                cell.itemContainer.roundBottomCorners(cornerRadius: 6)
            } else {
                cell.separator.isHidden = false
                cell.itemContainer.layer.cornerRadius = 0
                cell.containerTopConstraint.constant = 0
                cell.containerBottomConstraint.constant = 0
            }
        }

        cell.itemContainer.layer.shadowColor = UIColor.black.cgColor
        cell.itemContainer.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cell.itemContainer.layer.shadowOpacity = 0.12
        cell.itemContainer.layer.masksToBounds = false
        return cell
    }

    private func setupSinglePermissionsCell(with indexPath: IndexPath) -> UITableViewCell {
        guard let cell = permissionsTableView
            .dequeueReusableCell(
                withIdentifier: privacyPermissionTableViewCellID,
                for: indexPath) as? VFGPrivacyPermissionTableViewCell,
            let cellModel = viewModel?.model?.singlePermissions?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.setup(with: cellModel, indexPath: indexPath, delegate: self)
        if entryPoint != .personalizedRecommendations {
            let arrayCount = viewModel?.model?.singlePermissions?.count ?? 1
            return configureCornerRadius(for: indexPath, cell: cell, arrayCount: arrayCount)
        } else {
            cell.itemContainer.configureShadow()
        }
        return cell
    }
}

// MARK: VFGInfoSectionTableViewCellProtocol
extension VFGCustomizedPermissionsViewController: VFGInfoSectionTableViewCellProtocol {
    func learnMoreButtonDidPressed(indexPath: IndexPath?) {
        permissionsTableView.beginUpdates()
        guard let indexPath = indexPath else {
            return
        }
        viewModel?.model?.infoSection?[indexPath.row].isExpanded?.toggle()
        permissionsTableView.endUpdates()
    }
}

// MARK: VFGInfoSectionTableViewCellProtocol
extension VFGCustomizedPermissionsViewController: VFGPrivacyPermissionTableViewCellProtocol {
    func didPressOnToggle(for indexPath: IndexPath) {
        viewModel?.didPressOnToggle(for: indexPath, entryPoint: entryPoint)
        confirmButton.isEnabled = viewModel?.isConfirmButtonEnabled() ?? false
        permissionsTableView.reloadData()
    }
}

extension VFGCustomizedPermissionsViewController: VFGResultViewProtocol {
    public func resultViewPrimaryButtonAction() {
        quickActionsResultView?.closeQuickAction()
        dismiss(animated: true)
    }

    public func resultViewSecondaryButtonAction() {
        _ = (self.navigationController as? MVA10NavigationController)?.popViewController(animated: true)
        quickActionsResultView?.closeQuickAction()
    }
}
