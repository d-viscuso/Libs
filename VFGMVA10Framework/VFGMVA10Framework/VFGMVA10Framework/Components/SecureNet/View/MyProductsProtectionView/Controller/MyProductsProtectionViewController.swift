//
//  MyProductsProtectionViewController.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 15/02/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// A view controller which represents my products protection screen
public class MyProductsProtectionViewController: UIViewController, BaseMultiTabsViewController {
    @IBOutlet weak var myProductsProtectionTableView: UITableView!

    var heightObserver: NSKeyValueObservation?
    /// *MyProductsProtectionViewModel* view model instance
    var viewModel: VFGMyProductsProtectionViewModelProtocol?
    weak var delegate: VFGMyProductsProtectionProtocol?

    let sectionHeaderHeight: CGFloat = 124

    public var rootViewController: (UIViewController & BaseMultiTabsViewControllerDelegate)?
    public var updateHeightClosure: ((CGFloat) -> Void)?
    public var setHeightClosure: ((CGFloat) -> Void)?
    public func refresh() {}

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupMyProductsTableView()
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
                self?.myProductsProtectionTableView.reloadData()
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
        viewModel?.fetchMyProducts()
    }

    private func setupMyProductsTableView() {
        myProductsProtectionTableView.delegate = self
        myProductsProtectionTableView.dataSource = self
        myProductsProtectionTableView.rowHeight = UITableView.automaticDimension
        myProductsProtectionTableView.estimatedRowHeight = 160.0
        registerMyProductsTableViewCells()
    }

    private func registerMyProductsTableViewCells() {
        let headerNib = UINib(
            nibName: String(describing: MyProductsProtectionSectionHeader.self),
            bundle: .mva10Framework
        )
        let cellNib = UINib(
            nibName: String(describing: MyProductsProtectionCell.self),
            bundle: .mva10Framework
        )
        myProductsProtectionTableView.register(
            headerNib,
            forHeaderFooterViewReuseIdentifier: String(describing: MyProductsProtectionSectionHeader.self)
        )
        myProductsProtectionTableView.register(
            cellNib,
            forCellReuseIdentifier: String(describing: MyProductsProtectionCell.self)
        )
    }

    private func setHeightObserver() {
        guard heightObserver == nil else { return }
        heightObserver = myProductsProtectionTableView.observe(
            \.contentSize,
            options: [.new]
        ) { [weak self] _, change in
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

extension MyProductsProtectionViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfCards() ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: MyProductsProtectionCell.self),
                for: indexPath
            ) as? MyProductsProtectionCell,
            let card = viewModel?.getCard(at: indexPath)
        else { return UITableViewCell() }
        cell.delegate = delegate
        cell.setup(with: card)
        return cell
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(
                describing: MyProductsProtectionSectionHeader.self
            )) as? MyProductsProtectionSectionHeader
        else {
            return nil
        }
        headerView.setup(
            title: viewModel?.getTitle(),
            subTitle: viewModel?.getSubTitle()
        )
        return headerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        sectionHeaderHeight
    }
}
