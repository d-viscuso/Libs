//
//  PastOrdersViewController.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 08/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// View controller screen that display past orders
public class PastOrdersViewController: UIViewController, BaseMultiTabsViewController {
    // MARK: - Outlets
    @IBOutlet weak var pastOrdersTableView: UITableView!
    /// *PastOrdersViewController* view model instance
    var viewModel: PastOrdersViewModel?
    /// *PastOrdersViewController* height
    var heightObserver: NSKeyValueObservation?

    public var rootViewController: (UIViewController & BaseMultiTabsViewControllerDelegate)?
    public var updateHeightClosure: ((CGFloat) -> Void)?
    public var setHeightClosure: ((CGFloat) -> Void)?
    public func refresh() {}

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupPastOrdersTableView()
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
                self?.pastOrdersTableView?.reloadData()
            case .empty:
                break
            case .error:
                break
            case .filtered:
                break
            case .none:
                break
            }
        }
        viewModel?.fetchPastOrders()
    }

    private func setupPastOrdersTableView() {
        pastOrdersTableView.delegate = self
        pastOrdersTableView.dataSource = self
        pastOrdersTableView.isAccessibilityElement = false
        pastOrdersTableView.rowHeight = UITableView.automaticDimension
        pastOrdersTableView.estimatedRowHeight = 442.0
        registerPastOrdersTableViewViews()
    }

    private func registerPastOrdersTableViewViews() {
        let cellNib = UINib(
            nibName: String(describing: PastOrderCell.self),
            bundle: .mva10Framework)
        pastOrdersTableView.register(
            cellNib,
            forCellReuseIdentifier: String(describing: PastOrderCell.self))
    }

    private func setHeightObserver() {
        guard heightObserver == nil else { return }
        heightObserver = pastOrdersTableView?.observe(\.contentSize, options: [.new]) { [weak self]_, change in
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

extension PastOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.numberOfSections() ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfItems(in: section) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: PastOrderCell.self),
            for: indexPath) as? PastOrderCell,
            let model = viewModel?.getItem(at: indexPath) else {
            return UITableViewCell()
        }
        cell.setup(with: model, delegate: self, isFirstOrder: indexPath.row == 0)
        cell.isAccessibilityElement = false
        return cell
    }
}

extension PastOrdersViewController: PastOrderCellDelegate {
    func orderSummaryButtonDidPressed(for order: Order?) {
    }
}
