//
//  PrivacySettingsViewController.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 11/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import UIKit
/// Privacy settings main screen protocol
public protocol PrivacySettingsProtocol: AnyObject {
    /// Return a dictionary of each action key and its action
    func privacySettingsActions() -> VFGActions
}

public class PrivacySettingsViewController: UIViewController {
    @IBOutlet weak var privacySettingsTableView: UITableView!
    /// An instance of *PrivacySettingsViewModel*
    var viewModel: PrivacySettingsViewModel?
    /// *PrivacySettingsProtocol* delegate for *PrivacySettingsViewController*
    weak var delegate: PrivacySettingsProtocol?

    var headerTopBottomConstraints: CGFloat = 32
    var headerLeadingTrailingConstraints: CGFloat = 16

    public override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        fetchData()
    }

    private func registerCell() {
        let cellNib = UINib(
            nibName: "PrivacySettingsCell",
            bundle: .mva10Framework)
        privacySettingsTableView.register(
            cellNib,
            forCellReuseIdentifier: "PrivacySettingsCell")
    }

    private func fetchData() {
        viewModel?.fetchPrivacySettings { [weak self] in
            guard let self = self else {
                return
            }
            self.privacySettingsTableView.reloadData()
        }
    }

    private func headerView(for tableView: UITableView) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear

        let headerLabel = VFGLabel(frame: CGRect(
            x: headerLeadingTrailingConstraints,
            y: headerTopBottomConstraints,
            width: tableView.bounds.size.width - (2 * headerLeadingTrailingConstraints),
            height: 0))
        headerLabel.backgroundColor = .clear
        headerLabel.font = .vodafoneRegular(17)
        headerLabel.textColor = .VFGSecondaryText
        headerLabel.textAlignment = .left
        headerLabel.numberOfLines = 0
        headerLabel.text = viewModel?.privacySettingsHeaderTitle()
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)

        headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true

        tableView.estimatedSectionHeaderHeight = headerLabel.bounds.size.height + (2 * headerTopBottomConstraints)
        return headerView
    }
}

extension PrivacySettingsViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfContents() ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: PrivacySettingsCell.self),
            for: indexPath) as? PrivacySettingsCell else {
                return UITableViewCell()
            }
        guard let model = viewModel?.getContent(at: indexPath.row) else {
            return UITableViewCell()
        }
        cell.configure(with: model)
        cell.privacySettingsButtonAction = delegate?.privacySettingsActions()[model.actionKey]
        return cell
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView(for: tableView)
    }
}
