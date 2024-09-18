//
//  VFGSwitchAccountTableViewFooter.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 02/08/2022.
//

import UIKit
import VFGMVA10Foundation

class VFGSwitchAccountTableViewFooter: UITableViewHeaderFooterView {
    var manageButtonDidTap: (() -> Void)?
    var addAccountButtonDidTap: (() -> Void)?
    var  logOutButtonDidTap: (() -> Void)?

    @IBOutlet weak var manageAccountLabel: VFGLabel!
    @IBOutlet weak var addAccountLabel: VFGLabel!
    @IBOutlet weak var manageAccountImageView: VFGImageView!
    @IBOutlet weak var addAccountImageView: VFGImageView!
    @IBOutlet weak var logOutButton: VFGButton!

    @IBAction func addAccountButtonAction(_ sender: Any) {
        addAccountButtonDidTap?()
    }

    @IBAction func manageAccountButtonAction(_ sender: Any) {
        manageButtonDidTap?()
    }

    @IBAction func logOutButtonAction(_ sender: Any) {
        logOutButtonDidTap?()
    }

    public func configure(_ dataSource: VFGSwitchAccountDataSource?) {
        guard let dataSource = dataSource else { return }
        addAccountLabel.text = dataSource.addAccountTitle
        addAccountImageView.image = dataSource.addAccountIcon
        manageAccountLabel.text = dataSource.manageAccountTitle
        manageAccountImageView.image = dataSource.manageAccountIcon
        addAccountImageView.isHidden = dataSource.isAddAccountButtonHidden ?? false
        addAccountLabel.isHidden = dataSource.isAddAccountButtonHidden ?? false
        manageAccountImageView.isHidden = dataSource.isManageAccountButtonHidden ?? false
        manageAccountLabel.isHidden = dataSource.isManageAccountButtonHidden ?? false
        logOutButton.isHidden = dataSource.isLogOutButtonHidden ?? false
        logOutButton.setTitle(dataSource.logOutButtonTitle, for: .normal)
    }
}
