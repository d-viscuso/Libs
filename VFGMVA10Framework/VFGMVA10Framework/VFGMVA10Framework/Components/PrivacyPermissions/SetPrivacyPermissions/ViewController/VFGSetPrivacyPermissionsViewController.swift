//
//  VFGSetPrivacyPermissionsViewController.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 26/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// Set Privacy Permissions View Controller 
public class VFGSetPrivacyPermissionsViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet var permissionTableHeaderView: UIView!
    @IBOutlet weak var backButton: VFGButton!
    @IBOutlet weak var closeButton: VFGButton!
    @IBOutlet weak var permissionsTableView: UITableView!
    @IBOutlet weak var happyButton: VFGButton!
    @IBOutlet var permissionsTableViewFooter: UIView!

    /// Model Object
    var model = VFGPrivacyPermissionsManager.model?.privacyPermissionsSettings
    var viewModel: VFGSetPrivacyPermissionsViewModel?
    weak var navigationDelegate: PrivacyPermissionsNavigationProtocol?

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupTableView()
        setAccessibilityForVoiceOver()
    }
    /// Method that is used to setup view model
    private func setupViewModel() {
        guard let model = model else { return }
        viewModel = VFGSetPrivacyPermissionsViewModel(model: model)
    }
    /// Method that is used to setup table view
    private func setupTableView() {
        permissionsTableView.delegate = self
        permissionsTableView.dataSource = self
        setupTableViewHeader()
        setupTableViewFooter()
        registerPermissionsTableCell(name: String(describing: VFGPrivacyPermissionsInfoCell.self))
        registerPermissionsTableCell(name: String(describing: VFGProfilePrivacyPermissionCell.self))
        registerPermissionsTableCell(name: String(describing: VFGContactPrivacyPermissionCell.self))
        registerContactsHeaderView()
        permissionsTableView.reloadData()
    }
    /// Method that is used to setup header
    private func setupTableViewHeader() {
        backButton.setImage(VFGFrameworkAsset.Image.icArrowLeft, for: .normal)
        closeButton.setImage(VFGFrameworkAsset.Image.icClose, for: .normal)
        permissionsTableView.tableHeaderView = permissionTableHeaderView
    }
    /// Method that is used to setup footer
    private func setupTableViewFooter() {
        happyButton.setTitle("privacy_permissions_happy_with_this".localized(bundle: .mva10Framework), for: .normal)
        permissionsTableView.tableFooterView = permissionsTableViewFooter
    }
    /// Method that is used to register permission cell
    ///  - Parameters:
    ///     - name: cell reuse identifier
    private func registerPermissionsTableCell(name: String) {
        let nib = UINib(nibName: name, bundle: Bundle.mva10Framework)
        permissionsTableView
            .register(
                nib,
                forCellReuseIdentifier: name
            )
    }
    /// Method that is register contacts header
    private func registerContactsHeaderView() {
        let nib = UINib(nibName: String(describing: VFGContactsSectionHeaderView.self), bundle: Bundle.mva10Framework)
        permissionsTableView
            .register(
                nib,
                forHeaderFooterViewReuseIdentifier: String(describing: VFGContactsSectionHeaderView.self)
            )
    }

    /// Back more button action
    @IBAction func backButtonDidPressed(_ sender: Any) {
        backButtonPressed()
    }
    @objc func backButtonPressed() {
        if let privacyPermissionVC = self.parent as? VFGPrivacyPermissionViewController {
            privacyPermissionVC.outerStackView.isHidden = false
            privacyPermissionVC.setupAccessibilityCustomActions()
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }

    /// Close button action
    @IBAction func closeButtonDidPressed(_ sender: Any) {
        closeButtonPressed()
    }
    @objc func closeButtonPressed() {
        navigationDelegate?.closeButtonDidPressed()
    }

    /// Happy button action
    @IBAction func happyButtonDidPressed(_ sender: Any) {
        happyAction()
    }

    @objc func happyAction() {
        navigationDelegate?.closeButtonDidPressed()
    }
}

extension VFGSetPrivacyPermissionsViewController: VFGPrivacyPermissionsInfoCellProtocol {
    /// Learn more button action
    func learnMoreButtonDidPressed(indexPath: IndexPath?) {
        if let indexPath = indexPath {
            switch indexPath.section {
            case 0:
                viewModel?.infoSection?[indexPath.row].isExpanded.toggle()
            case 2:
                viewModel?.contactPreferences?[indexPath.row].isExpanded.toggle()
            default:
                break
            }
        }
        permissionsTableView.beginUpdates()
        permissionsTableView.endUpdates()
    }
}

extension VFGSetPrivacyPermissionsViewController: VFGPrivacyPermissionsSettingsProtocol {
    /// Toggle button action
    func didPressToggleButton(indexPath: IndexPath?) -> Bool? {
        guard let indexPath = indexPath else { return nil }
        let result = viewModel?.toggleState(with: indexPath)
        if result?.shouldReloadSection ?? false {
            UIView.performWithoutAnimation {
                permissionsTableView.reloadSections([indexPath.section], with: .automatic)
            }
            return nil
        } else {
            return result?.state
        }
    }
}
// MARK: Voice-Over
extension VFGSetPrivacyPermissionsViewController {
    /// set accessibility for voice over
    func setAccessibilityForVoiceOver() {
        backButton.accessibilityLabel = "Back"
        closeButton.accessibilityLabel = "Close"
        happyButton.accessibilityLabel = happyButton.titleLabel?.text ?? ""
        accessibilityCustomActions = [
            backButtonVoiceAction(),
            closeButtonVoiceAction(),
            happyVoiceAction()
        ]
    }
    /// action for back button in voice over
    /// - Returns: action for back button in voice over
    func backButtonVoiceAction() -> UIAccessibilityCustomAction {
        let actionName = "Back"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(backButtonPressed))
    }
    /// action for close button in voice over
    /// - Returns: action for close button in voice over
    func closeButtonVoiceAction() -> UIAccessibilityCustomAction {
        let actionName = "Close"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(closeButtonPressed))
    }
    /// action for toggle button in voice over
    /// - Returns: action for happy button in voice over
    func happyVoiceAction() -> UIAccessibilityCustomAction {
        let actionName = happyButton.titleLabel?.text ?? "happy action"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(happyAction))
    }
}
