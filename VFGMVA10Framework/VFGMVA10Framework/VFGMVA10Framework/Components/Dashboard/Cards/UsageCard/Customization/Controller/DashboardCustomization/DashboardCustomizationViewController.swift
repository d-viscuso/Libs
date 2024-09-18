//
//  DashboardCustomizationViewController.swift
//  VFGMVA10Framework
//
//  Created by Yasser Soliman on 10/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

// MARK: DashboardCustomizationViewController
/// Controller responsible for editing displayed cards in main dashboard main tile
class DashboardCustomizationViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subTitleLabel: VFGLabel!
    @IBOutlet weak var confirmButton: VFGButton!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

    // MARK: Properties
    /// *DashboardCustomizationViewController* navigation controller
    lazy var mva10navigationController: MVA10NavigationController? = {
        return navigationController as? MVA10NavigationController
    }()
    /// *DashboardCustomizationViewController* table view sections
    let sections = (visible: 0, hidden: 1)
    /// Minimum number allowed for usage cards
    let minimumVisibleUsageCards = 0
    /// *DashboardCustomizationViewController* table view current cell index
    var initialIndex = 0
    /// Array list of dashboard usage cards
    var usageCardsConfiguration: [CustomizationCardConfigurationModel] = []
    /// Array list of dashboard previous usage cards
    var previousVisibleUsageCards: [CustomizationCardConfigurationModel] = []
    /// Array list of dashboard current usage cards
    var visibleUsageCards: [CustomizationCardConfigurationModel] {
        self.usageCardsConfiguration.filter { !$0.isHidden }
    }
    /// Array list of dashboard hidden usage cards
    var hiddenUsageCards: [CustomizationCardConfigurationModel] {
        self.usageCardsConfiguration.filter { $0.isHidden }
    }
    /// *DashboardCustomizationViewController* table view height observer
    var tableViewHeightObserver: NSKeyValueObservation?

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigation()
        setupUI()
        setupTableView()
        confirmButton.isEnabled = false
        previousVisibleUsageCards = visibleUsageCards
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

    @IBAction func confirmButtonDidPress(_ sender: VFGButton) {
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

    // MARK: Private Methods
    private func configureNavigation() {
        mva10navigationController?.navigationDelegate = self
        mva10navigationController?.setTitle(
            title: "edit_usage_cards_screen_title".localized(bundle: .mva10Framework),
            for: self
        )
    }

    private func setupUI() {
        titleLabel.font = .vodafoneBold(25)
        subTitleLabel.font = .vodafoneRegular(16.6)
    }
    /// *DashboardCustomizationViewController* table view configuration
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

    @objc func appBecomeActive() {
        tableView.reloadData()
    }
    /// Add or remove button action
    /// - Parameters:
    ///    - indexPath: Current index of pressed button
    func addOrRemoveButtonDidPress(at indexPath: IndexPath) {
        if indexPath.section == sections.visible && visibleUsageCards.count == minimumVisibleUsageCards {
            return
        }

        var visibleUsageCards = self.visibleUsageCards
        var hiddenUsageCards = self.hiddenUsageCards

        if indexPath.section == sections.visible {
            var movedItem = visibleUsageCards.remove(at: indexPath.row)
            movedItem.isHidden = true
            hiddenUsageCards.append(movedItem)
        } else if indexPath.section == sections.hidden {
            var movedItem = hiddenUsageCards.remove(at: indexPath.row)
            movedItem.isHidden = false
            visibleUsageCards.append(movedItem)
        }
        usageCardsConfiguration = visibleUsageCards + hiddenUsageCards
        for index in usageCardsConfiguration.indices {
            usageCardsConfiguration[index].index = index
        }

        confirmButton.isEnabled = isVisibleUsageCardsChanged()

        tableView.reloadData()
    }
    /// Notification center observers
    /// - Parameters:
    ///    - name: Notification name
    func notifyObservers(with name: Notification.Name) {
        NotificationCenter.default.post(
            name: name,
            object: visibleUsageCards + hiddenUsageCards
        )
    }
    /// Determine whether usage cards were rearranged or not
    func isVisibleUsageCardsChanged() -> Bool {
        !(previousVisibleUsageCards.sortedArrayByPosition() == visibleUsageCards.sortedArrayByPosition())
    }
}

extension DashboardCustomizationViewController: VFGNavigationControllerProtocol {
    func closeButtonDidPress() {
        mva10navigationController?.dismiss(animated: true, completion: nil)
        notifyObservers(with: .UsageCardsCloseButtonDidPress)
    }

    func backButtonDidPress() {
        _ = mva10navigationController?.popViewController(animated: true)
        notifyObservers(with: .UsageCardsBackButtonDidPress)
    }
}

extension DashboardCustomizationViewController: VFGTrayContainerProtocol {
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
