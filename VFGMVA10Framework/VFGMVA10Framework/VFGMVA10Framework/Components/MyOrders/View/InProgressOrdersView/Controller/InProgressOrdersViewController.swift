//
//  InProgressOrdersViewController.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 01/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// View controller screen that display in progress orders
public class InProgressOrdersViewController: UIViewController, BaseMultiTabsViewController {
    // MARK: - Outlets
    @IBOutlet weak var inProgressOrdersTableView: UITableView!
    @IBOutlet weak var emptyOrdersView: UIView!
    @IBOutlet weak var emptyOrdersTitle: VFGLabel!
    @IBOutlet weak var emptyOrdersSubTitle: VFGLabel!
    @IBOutlet weak var emptyOrdersViewHeightConstraint: NSLayoutConstraint!
    /// *InProgressOrdersViewController* view model instance
    var viewModel: InProgressOrdersViewModel?
    /// *InProgressOrdersViewController* height
    var heightObserver: NSKeyValueObservation?
    /// An instance of *VFGOrderDetailsViewController*
    var orderDetailVC: VFGOrderDetailsViewController?
    var emptyViewHeight: CGFloat = 400

    public var rootViewController: (UIViewController & BaseMultiTabsViewControllerDelegate)?
    public var updateHeightClosure: ((CGFloat) -> Void)?
    public var setHeightClosure: ((CGFloat) -> Void)?
    public func refresh() {}

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupInProgressOrdersTableView()
        initViewModel()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setHeightObserver()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeHeightObserver()
    }

    private func initViewModel() {
        viewModel?.updateLoadingStatus = { [weak self] in
            switch self?.viewModel?.contentState {
            case .loading:
                break
            case .populated:
                self?.inProgressOrdersTableView.isHidden = false
                self?.emptyOrdersView.isHidden = true
                self?.emptyOrdersViewHeightConstraint.constant = 0
                self?.inProgressOrdersTableView?.reloadData()
            case .empty:
                self?.setupEmptyView()
            case .error:
                break
            case .filtered:
                break
            case .none:
                break
            }
        }
        emptyOrdersView.isHidden = true
        viewModel?.fetchOrders()
    }

    private func setupEmptyView() {
        emptyOrdersViewHeightConstraint.constant = emptyViewHeight
        inProgressOrdersTableView.isHidden = true
        emptyOrdersView.isHidden = false
        removeHeightObserver()
        emptyOrdersTitle.text = "my_orders_empty_title".localized(bundle: .mva10Framework)
        emptyOrdersSubTitle.text = "my_orders_empty_subtitle".localized(bundle: .mva10Framework)
    }
    private func setupInProgressOrdersTableView() {
        inProgressOrdersTableView.delegate = self
        inProgressOrdersTableView.dataSource = self
        inProgressOrdersTableView.isAccessibilityElement = false
        inProgressOrdersTableView.sectionHeaderHeight = UITableView.automaticDimension
        inProgressOrdersTableView.rowHeight = UITableView.automaticDimension
        inProgressOrdersTableView.estimatedSectionHeaderHeight = 160.0
        inProgressOrdersTableView.estimatedRowHeight = 211.0
        registerInProgressTableViewViews()
    }

    private func registerInProgressTableViewViews() {
        let headerNib = UINib(
            nibName: String(describing: InProgressOrderSectionHeaderView.self),
            bundle: .mva10Framework)
        let cellNib = UINib(
            nibName: String(describing: InProgressOrderItemCell.self),
            bundle: .mva10Framework)
        inProgressOrdersTableView.register(
            headerNib,
            forHeaderFooterViewReuseIdentifier: String(describing: InProgressOrderSectionHeaderView.self))
        inProgressOrdersTableView.register(
            cellNib,
            forCellReuseIdentifier: String(describing: InProgressOrderItemCell.self))
    }

    private func setHeightObserver() {
        guard heightObserver == nil else { return }
        heightObserver = inProgressOrdersTableView?.observe(\.contentSize, options: [.new]) { [weak self]_, change in
            guard let self = self,
                let newHeight = change.newValue?.height else { return }
            self.setHeightClosure?(newHeight)
            self.view.layoutIfNeeded()
        }
    }

    private func removeHeightObserver() {
        heightObserver = nil
    }
}

extension InProgressOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.numberOfSections() ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfItems(in: section) ?? 0
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: InProgressOrderItemCell.self),
            for: indexPath) as? InProgressOrderItemCell,
            let model = viewModel?.getItem(at: indexPath) else {
            return UITableViewCell()
        }
        cell.indexPath = indexPath
        cell.setup(orderItem: model, delegate: self)
        return cell
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(
                describing: InProgressOrderSectionHeaderView.self)) as? InProgressOrderSectionHeaderView,
            let model = viewModel?.getItem(for: section) else {
            return UIView()
        }
        headerView.setup(order: model, delegate: self, isFirstOrder: section == 0)
        return headerView
    }
}

extension InProgressOrdersViewController: InProgressOrderSectionHeaderViewDelegate {
    func orderSummaryButtonDidPressed(for order: Order?) {
        guard let order = order else { return }
        let orderSummaryQuickActionModel = OrderSummaryQuickActionModel(order: order)
        VFQuickActionsViewController.presentQuickActionsViewController(
            with: orderSummaryQuickActionModel
        )
    }
}

extension InProgressOrdersViewController: InProgressOrderItemCellDelegate {
    func editButtonDidPressed(currentIndexPath: IndexPath) {
        // Handle edit order item pressed
    }

    func navigateToOrderDetails(currentIndexPath: IndexPath) {
        let orderId = viewModel?.getItem(for: currentIndexPath.section)?.id ?? 12345
        guard let item = viewModel?.getItem(at: currentIndexPath) else {
            return
        }
        let itemId = item.id
        let orderStatus = OrderItemStatus(rawValue: item.status)?.orderHeaderTitle ?? ""
        let orderDeliveryDate = getStatusDate(with: item) ?? ""
        let headerModel = MultiTabsHeaderViewModel(
            title: String(
                format: "order_progress_status".localized(bundle: .mva10Framework),
                arguments: [orderStatus]
            ),
            subtitleRegText: String(
                format: "order_progress_estimated_delivery".localized(bundle: .mva10Framework),
                arguments: [orderDeliveryDate]
            ),
            secondSubtitleText: VFGMyOrdersManager.shared.accountName
        )
        let multiTabsVC = VFGMultiTabsManager.shared.createMultiTabsController(
            headerViewModel: headerModel
        )
        let orderTitle = String(
            format: "order_progress_screen_title".localized(bundle: .mva10Framework),
            arguments: ["\(orderId)"]
        )
        if let navController = rootViewController?.navigationController as? MVA10NavigationController {
            navController.setTitle(
                title: orderTitle,
                accessibilityID: orderTitle,
                for: multiTabsVC)
        } else {
            rootViewController?.navigationController?.title = orderTitle
        }

        orderDetailVC = VFGOrderDetailsViewController.init(
            nibName: String(describing: VFGOrderDetailsViewController.self),
            bundle: .mva10Framework
        )
        if let orderDetailVC = orderDetailVC {
            orderDetailVC.orderNumber = orderId
            orderDetailVC.itemNumber = itemId
            multiTabsVC.tabsViewControllers = [orderDetailVC]

            navigationController?.pushViewController(multiTabsVC, animated: true)
        }
    }
}

extension InProgressOrdersViewController {
    // MARK: - getStatusDate for order Details Screen
    private func getStatusDate(with item: Order.OrderItem) -> String? {
        var dateString: String?
        dateString = item.date
        var dayOrdinal = ""
        if let dateString = dateString, let date = VFGDateHelper
            .getDateFromString(dateString: dateString) {
            let ordinalFormatter = NumberFormatter()
            ordinalFormatter.numberStyle = .ordinal
            let day = Calendar.current.component(.day, from: date)
            dayOrdinal = ordinalFormatter.string(from: NSNumber(value: day)) ?? ""
        }
        return VFGDateHelper.changeDateStringFormat(
            dateString: dateString ?? "",
            format: "'\(dayOrdinal)' MMMM",
            dateFormatString: Constants.AddOnsTimeline.dateFormat,
            locale: Constants.AddOnsTimeline.localeUS)
    }
}
