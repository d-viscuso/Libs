//
//  VFGLogoutConfirmationViewController.swift
//  VFGMVA10Framework
//
//  Created by AbdallahShaheen on 23/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGLogoutConfirmationViewController: UIViewController {
    var confirmationView: VFGConfirmationView?

    weak var delegate: VFGSwitchAccountDelegate?
    var themeType: VFSwitchAccount?
    var dataSource: VFGSwitchAccountDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .clear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.backgroundColor = .clear
    }

    init(delegate: VFGSwitchAccountDelegate?, themeType: VFSwitchAccount, dataSource: VFGSwitchAccountDataSource?) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.themeType = themeType
        self.dataSource = dataSource
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupUI() {
        confirmationView = UIView.loadXib(bundle: .mva10Framework)
        guard let confirmationView else {
            return
        }
        view.addSubview(confirmationView)
        confirmationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confirmationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confirmationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            confirmationView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor)
        ])

        let confirmationModel = VFGConfirmationViewModel(
            title: "account_switcher_logout_header_title".localized(bundle: Bundle.mva10Framework),
            description: "logout_description_text".localized(bundle: Bundle.mva10Framework),
            primaryButtonTitle: "confirm_logout_button_title".localized(bundle: Bundle.mva10Framework),
            secondaryButtonTitle: "logout_back_button_title".localized(bundle: Bundle.mva10Framework)
        )

        confirmationView.setup(with: confirmationModel, and: self)
    }
}

extension VFGLogoutConfirmationViewController: VFGConfirmationViewDelegate {
    func closeButtonDidPressed() {
        dismiss(animated: true)
    }

    func primaryButtonDidPressed() {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.logOutDidPressed()
        }
    }

    func secondaryButtonDidPressed() {
        dismiss(animated: true) { [weak self] in
            let switchAccountQuickActionViewModel = VFGSwitchAccountQuickActionViewModel(
                self?.delegate,
                themeType: self?.themeType ?? .mva12,
                dataSource: self?.dataSource)
            VFQuickActionsViewController.presentQuickActionsViewController(with: switchAccountQuickActionViewModel)
        }
    }
}
