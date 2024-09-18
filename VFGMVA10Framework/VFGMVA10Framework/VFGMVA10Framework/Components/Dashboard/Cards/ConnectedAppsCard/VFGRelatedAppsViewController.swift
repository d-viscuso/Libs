//
//  VFGRelatedAppsViewController.swift
//  VFGMVA10
//
//  Created by Sandra Morcos on 1/16/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
/// Dashboard related apps view controller
class VFGRelatedAppsViewController: VFGBaseViewController {
    private enum Const {
        static let relatedAppTableViewCellID = "VFRelatedAppTableViewCellID"
    }

    var appRows: [VFGSubItem] = []
    @IBOutlet weak var relatedAppsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        relatedAppsTableView.accessibilityIdentifier = "DBotherAppsSection"
        relatedAppsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        relatedAppsTableView.reloadData()
    }
}

extension VFGRelatedAppsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appRows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.relatedAppTableViewCellID, for: indexPath)
        guard let relatedAppsCell = cell as? VFGRelatedAppTableViewCell else { return cell }

        relatedAppsCell.configureRelatedAppCell(appInfo: appRows[indexPath.row], for: indexPath.row)
        relatedAppsCell.separatorView.isHidden = indexPath.row == (appRows.count - 1)

        return relatedAppsCell
    }
}
