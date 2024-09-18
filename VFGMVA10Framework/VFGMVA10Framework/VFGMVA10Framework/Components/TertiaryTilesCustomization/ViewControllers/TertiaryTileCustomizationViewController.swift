//
//  TertiaryTileCustomizationViewController.swift
//  VFGMVA10Framework
//
//  Created by Yasser Soliman on 03/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// A view controller that is responsible for customizing tertiary tiles on dashboard.
class TertiaryTileCustomizationViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subTitleLabel: VFGLabel!
    @IBOutlet weak var confirmButton: VFGButton!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

    // MARK: Properties
    lazy var mva10navigationController: MVA10NavigationController? = {
        return navigationController as? MVA10NavigationController
    }()

    let sections = (visible: 0, hidden: 1)
    var tableViewHeightObserver: NSKeyValueObservation?
    /// tertiary tile customization view controller view model.
    public var viewModel: TertiaryTileCustomizationViewModel?

    override required init(
        nibName: String? = String(describing: TertiaryTileCustomizationViewController.self),
        bundle: Bundle? = Bundle.mva10Framework
    ) {
        super.init(nibName: nibName, bundle: bundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocalization()

        viewModel?.getOrderedTilesData()
        configureNavigation()
        setupUI()
        setupTableView()
        confirmButton.isEnabled = false
        setAccessibilityForVoiceOver()
        // foreground observer is used to fix
        // cell's reorder image change to default when coming from foreground
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.appBecomeActive),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        tableViewHeightObserver = tableView.observe(\.contentSize, options: [.new]) { [weak self]_, change in
            guard let self = self,
            let newHeight = change.newValue?.height else { return }
            self.tableViewHeightConstraint.constant = newHeight
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableViewHeightObserver = nil
    }

    /// A method used to set localization for tertiary tiles customization view controller.
    func setupLocalization() {
        titleLabel.text = "edit_tertiary_tiles_title".localized(bundle: .mva10Framework)
        subTitleLabel.text = "edit_tertiary_tiles_subtitle".localized(bundle: .mva10Framework)
        confirmButton.setTitle(
            "edit_tertiary_tiles_confirm_cta_button_title".localized(bundle: .mva10Framework),
            for: .normal
        )
    }

    /// A method used to setup tertiary tiles table view.
    func setupTableView() {
        tableView.register(
            UINib(
                nibName: String(describing: DashboardCustomizationTableViewCell.self),
                bundle: .mva10Framework),
            forCellReuseIdentifier: String(describing: DashboardCustomizationTableViewCell.self)
        )

        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .VFGLightGreyBackground
        tableView.setEditing(true, animated: false)
        tableView.dataSource = self
        tableView.delegate = self
    }

    func setAccessibilityForVoiceOver() {
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        subTitleLabel.accessibilityLabel = subTitleLabel.text ?? ""
        confirmButton.accessibilityLabel = confirmButton.titleLabel?.text ?? ""
    }

    @objc func appBecomeActive() {
        tableView.reloadData()
    }

    /// A method used to present tertiary tile customization view controller.
    /// - Parameter tertiaryCardsConfiguration: An array of type *TileModel* that holds a list of tile data.
    class func present(with tertiaryCardsConfiguration: [TileModel]) {
        let tertiaryTileCustomizationViewController = instance() as TertiaryTileCustomizationViewController
        let navController = MVA10NavigationController(rootViewController: tertiaryTileCustomizationViewController)
        navController.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.present(navController, animated: true, completion: nil)
    }

    @IBAction func confirmButtonDidPress(_ sender: VFGButton) {
        confirmButtonPressed()
    }
    @objc func confirmButtonPressed() {
        updateDashboardModel()
        let confirmModel = VFGConfirmModel(
            title: String(
                format: "edit_usage_cards_success_overlay_title".localized(bundle: .mva10Framework),
                "Phil"),
            details: "edit_usage_cards_success_overlay_subtitle".localized(bundle: .mva10Framework),
            subtitle: "",
            buttonTitle: "refer_a_friend_return_to_dashboard_button".localized( bundle: .mva10Framework)
        )

        let confirmViewController = VFGConfirmViewController.create(confirmModel: confirmModel)

        confirmViewController.closeDidTap = { [weak self] in
            (self?.navigationController as? MVA10NavigationController)?.closeTapped()
        }

        confirmViewController.modalPresentationStyle = .fullScreen
        present(confirmViewController, animated: false)
    }
    func confirmButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = confirmButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(confirmButtonPressed))
    }

    /// A method used to update dashboard model.
    func updateDashboardModel() {
        viewModel?.onConfirmCustomizedTiles()
        VFGManagerFramework.dashboardDelegate?.dashboardManager?.refetchDashboard(completion: nil)
    }

    // MARK: Private Methods
    private func configureNavigation() {
        mva10navigationController?.navigationDelegate = self
        mva10navigationController?.setTitle(
            title: "edit_usage_cards_screen_title".localized(bundle: .mva10Framework),
            for: self
        )
        mva10navigationController?.setAccessibilityLabels(
            closeButtonLabel: "Close",
            backButtonLabel: "Back",
            titleAccessibilityLabel: "Dashboard settings")
    }

    private func setupUI() {
        titleLabel.font = .vodafoneBold(25)
        subTitleLabel.font = .vodafoneRegular(16.6)
    }
}

extension TertiaryTileCustomizationViewController: VFGNavigationControllerProtocol {
    func closeButtonDidPress() {
        mva10navigationController?.dismiss(animated: true, completion: nil)
    }

    func backButtonDidPress() {
        _ = mva10navigationController?.popViewController(animated: true)
    }
}

extension TertiaryTileCustomizationViewController: VFGTrayContainerProtocol {
    public var tobiKey: String {
        className
    }

    public var trayStyle: VFGTrayStyle {
        .TOBI
    }

    public var tobiContainerVC: UIViewController? {
        return VFGManagerFramework.tobiDelegate?.helpViewController(for: "\(className)")
    }
}
