//
//  SettingsViewController.swift
//  VFGMVA10Group
//
//  Created by Mohamed Mahmoud Zaki on 6/26/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// Delegation for *SettingsViewController* actions
public protocol SettingsViewControllerDelegate: AnyObject {
    /// Reload *SettingsViewController* table view
    func reloadTableView()
    /// Push view controller from *SettingsViewController*
    /// - Parameters:
    ///    - viewController: View controller to be pushed
    ///    - animated: Determine whether pushed view controller should be animated or not
    func push(viewController: UIViewController, animated: Bool)
}
/// Settings screen view controller
public class SettingsViewController: UIViewController {
    // MARK: - Local properties
    /// Index of selected section
    var selectedSectionIndex: Int?

    // MARK: - Public properties
    /// Array list of *SettingsViewController* table view sections
    public var sections: [TableViewSectionProtocol] = []

    // MARK: - TableView Constants
    private let tableViewTopInset: CGFloat = 16

    @IBOutlet weak var tableView: UITableView!

    override public func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setAccessibilityIdentifier()
        registerCells()
        AppSettingsManager.trackView(
            pageName: "analytics_framework_page_name_app_settings".localized(bundle: .mva10Framework)
        )
    }

    private func registerCells() {
        for (index, section) in sections.enumerated() {
            if section.numberOfRows() != 0 {
                section.registerCells(in: tableView)
            } else if sections[safe: index] != nil {
                sections.remove(at: index)
            }
        }
    }

    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: tableViewTopInset, left: 0, bottom: 0, right: 0)
        tableView.sectionHeaderHeight = UITableView.automaticDimension
    }

    func setAccessibilityIdentifier() {
        view.accessibilityIdentifier = "AScontainerView"
    }
}

extension SettingsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        sections[indexPath.section].cellHeightFor(indexPath: indexPath)
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].numberOfRows()
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        sections[section].heightForHeader()
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        sections[indexPath.section].cellAt(indexPath: indexPath, tableView: tableView)
    }
}
extension SettingsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sections[section].headerView(for: tableView)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].didSelectRowAt(indexPath: indexPath, tableView: tableView)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        sections[indexPath.section].didDeselectRowAt(indexPath: indexPath, tableView: tableView)
    }

    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        guard selectedSectionIndex == indexPath.section else {
            return nil
        }
        return indexPath
    }

    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedSectionIndex = indexPath.section
        return indexPath
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        sections[indexPath.section].willDisplay(cell: cell, indexPath: indexPath, tableView: tableView)
    }
}

extension SettingsViewController: VFGTrayContainerProtocol {
    public var tobiKey: String {
        "SettingsViewController"
    }

    public var trayStyle: VFGTrayStyle {
        .TOBI
    }

    public var tobiContainerVC: UIViewController? {
        return VFGManagerFramework.tobiDelegate?.helpViewController(for:
            "\(SettingsViewController.self)")
    }
}

extension SettingsViewController: SettingsViewControllerDelegate {
    public func reloadTableView() {
        guard tableView != nil else {
            return
        }
        tableView.reloadData()
        tableView.layoutIfNeeded()
    }

    public func push(viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
