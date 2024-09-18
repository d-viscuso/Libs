//
//  BalanceHistoryViewController.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 11/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

public class BalanceHistoryViewController: UIViewController, BaseTabsViewController {
    @IBOutlet weak var autoTopupCVMView: UIView!
    @IBOutlet var bannerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterView: VFGFilterView!
    @IBOutlet weak var balanceHistoryTitleLabel: VFGLabel!
    @IBOutlet weak var datesLabel: VFGLabel!
    @IBOutlet weak var calendarImageView: VFGImageView!
    @IBOutlet weak var datesView: UIView!
    @IBOutlet weak var balanceFilterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var balanceHistoryTableView: UITableView!
    @IBOutlet weak var balanceHistoryHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var selectedDateLabel: VFGLabel!
    @IBOutlet weak var selectedDateViewHeight: NSLayoutConstraint!
    @IBOutlet weak var clearButton: VFGButton!
    @IBOutlet weak var selectedDateStack: UIStackView!

    private var heightObserver: NSKeyValueObservation?
    private var initialFrameHeight: CGFloat = 0
    private var balanceHistoryItemCell = "BalanceHistoryItemCell"
    var balanceHistoryItemCellShimmer = "BalanceHistoryItemCellShimmer"
    var balanceHistorySectionHeader = "BalanceHistorySectionHeader"
    private var balanceHistorySectionHeaderShimmer = "BalanceHistorySectionHeaderShimmer"
    let sectionHeight: CGFloat = 60
    public var autoTopUpModel: AutoTopUpModelProtocol?
    var activeAutoTopUpModel: VFGActiveAutoTopUpProtocol?
    public weak var rootViewController: (UIViewController & BaseTabsViewControllerDelegate)?
    public var updateHeightClosure: ((CGFloat) -> Void)?
    public var setHeightClosure: ((CGFloat) -> Void)?
    public var historyViewModel: BalanceHistoryViewModel?
    var rangeStartDate: Date?
    var rangeEndDate: Date?
    var minimumHistoryDate: Date?
    var maximumHistoryDate: Date?

    var isCVMActive = false
    var balanceFilterHight: CGFloat = 45
    var errorCardView: VFGErrorView?
    var noBalanceView: VFGNoDataView?
    var cvmView: VFGCVM?
    let errorCardConstraintConstant: CGFloat = 60
    let bannerHeightConstraintConstant: CGFloat = 160
    let footerViewHeight: CGFloat = 110

    public required init(
        nibName: String = String(describing: BalanceHistoryViewController.self),
        bundle: Bundle = Bundle.mva10Framework
    ) {
        super.init(nibName: nibName, bundle: bundle)
        title = "balance_screen_title".localized(bundle: Bundle.mva10Framework)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        initViewModel()
        setupFilterView()
        setupUI()
        setHeightObserver()
        setupAccessibilityLabels()
    }

    private func initViewModel() {
        historyViewModel?.updateLoadingStatus = { [weak self] in
            guard
                let self = self,
                let historyViewModel = self.historyViewModel else {
                return
            }

            self.removeNoBalanceViewIfNeeded()

            switch historyViewModel.contentState {
            case .loading:
                self.rootViewController?.dataFetchingWillStart()
                self.filterView.triggerShimmerMode = true
                self.balanceHistoryTableView?.reloadData()
            case .populated:
                self.rootViewController?.dataFetchingDidComplete()
                self.filterView.triggerShimmerMode = false
                self.reloadCategories()
                self.balanceHistoryTableView?.reloadData()

                if historyViewModel.autoTopUpCVMEnabled {
                    if !self.isCVMActive {
                        self.showAutoTopUpCVMView()
                    }
                } else {
                    self.hideAutoTopUpCVMView()
                }
                self.datesView.isHidden = historyViewModel.shouldHideDateFilterView ?? false

            case .filtered:
                self.balanceHistoryTableView?.reloadData()
            case .empty:
                self.rootViewController?.dataFetchingDidComplete()
                self.setHeightClosure?(self.initialFrameHeight)
                self.addNoDataView()
                self.hideAutoTopUpCVMView()
                self.balanceHistoryTableView?.reloadData()
            case .error:
                self.rootViewController?.dataFetchingDidComplete()
                self.showErrorCard()
                self.hideAutoTopUpCVMView()
            }
        }

        historyViewModel?.fetchBalanceHistory()
    }

    public func refresh() {
        guard balanceHistoryTableView != nil else {
            return
        }
        historyViewModel?.fetchBalanceHistory()
    }

    func reloadCategories() {
        guard let categories = historyViewModel?.balanceCategories else {
            return
        }

        filterView?.categories.removeAll()
        let categoriesRawValues = categories
        filterView?.categories.append(contentsOf: categoriesRawValues)
        if categories.count > 1 {
            filterView.categories.insert(BalanceHistoryLocalize.all.localizedString, at: 0)
        }

        balanceFilterHeightConstraint.constant = categories.count >= 1
            ? balanceFilterHight
            : 0
    }

    func addNoDataView() {
        noBalanceView = VFGNoDataView.loadXib(bundle: .mva10Framework)
        noBalanceView?.configure(
            title: "balance_screen_no_history_title".localized(bundle: .mva10Framework),
            description: "balance_screen_no_history_subtitle".localized(bundle: .mva10Framework))

        guard let noBalanceView = noBalanceView else { return }
        view.addSubview(noBalanceView)
        noBalanceView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noBalanceView.topAnchor.constraint(equalTo: balanceHistoryTitleLabel.topAnchor),
            noBalanceView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noBalanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noBalanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }

    private func removeNoBalanceViewIfNeeded() {
        if noBalanceView != nil, historyViewModel?.contentState != .error {
            noBalanceView?.removeFromSuperview()
            noBalanceView = nil
        }
    }

    func balanceHistoryCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = balanceHistoryTableView.dequeueReusableCell(
            withIdentifier: balanceHistoryItemCell,
                for: indexPath) as? BalanceHistoryItemCell else {
            return UITableViewCell()
        }
        cell.balanceIconImageView.accessibilityIdentifier = "BHicon\(indexPath.row)"
        cell.balanceTitleLabel.accessibilityIdentifier = "BHtitleLabel\(indexPath.row)"
        cell.balanceSubtitleLabel.accessibilityIdentifier = "BHsubtitleLabel\(indexPath.row)"
        cell.balanceAmountLabel.accessibilityIdentifier = "BHamountLabel\(indexPath.row)"
        cell.configure(with: historyViewModel?.cellViewModel(at: indexPath))
        return cell
    }

    public func configureDatePicker(
        minimumHistoryDate: Date,
        maximumHistoryDate: Date
    ) {
        self.minimumHistoryDate = minimumHistoryDate
        self.maximumHistoryDate = maximumHistoryDate
    }

    @IBAction func datePickerButtonDidPress(_ sender: Any) {
        let historyDatePickerViewController = HistoryDatePickerViewController(
            minimumDate: minimumHistoryDate,
            maximumDate: maximumHistoryDate,
            rangeStartDate: rangeStartDate,
            rangeEndDate: rangeEndDate
        )
        historyDatePickerViewController.delegate = self

        let navController = MVA10NavigationController(rootViewController: historyDatePickerViewController)
        navController.modalPresentationStyle = .fullScreen
        let navigationTitle = "balance_history_title".localized(bundle: Bundle.mva10Framework)
        navController.setTitle(title: navigationTitle, for: historyDatePickerViewController)
        present(navController, animated: true, completion: nil)
    }

    @IBAction func clearSelectedDateButtonDidPress(_ sender: Any) {
        rangeStartDate = nil
        rangeEndDate = nil
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.selectedDateViewHeight.constant = 0
            self?.selectedDateStack.isHidden = true
            self?.view.layoutIfNeeded()
        }
        historyViewModel?.fetchBalanceHistory()
    }
    deinit {
        heightObserver = nil
    }
}

/// Setup
extension BalanceHistoryViewController {
    func setupBalanceTableView() {
        balanceHistoryTableView.delegate = self
        balanceHistoryTableView.dataSource = self
        balanceHistoryTableView.register(
            UINib(
                nibName: balanceHistoryItemCell,
                bundle: Bundle.mva10Framework),
            forCellReuseIdentifier: balanceHistoryItemCell)
        balanceHistoryTableView.register(
            UINib(
                nibName: balanceHistoryItemCellShimmer,
                bundle: Bundle.mva10Framework),
            forCellReuseIdentifier: balanceHistoryItemCellShimmer)
        balanceHistoryTableView.register(
            UINib(
                nibName: balanceHistorySectionHeader,
                bundle: Bundle.mva10Framework),
            forHeaderFooterViewReuseIdentifier: balanceHistorySectionHeader)
        balanceHistoryTableView.register(
            UINib(
                nibName: balanceHistorySectionHeaderShimmer,
                bundle: Bundle.mva10Framework),
            forHeaderFooterViewReuseIdentifier: balanceHistorySectionHeaderShimmer)

        let footerView =
            UIView(frame: CGRect(x: 0, y: 0, width: balanceHistoryTableView.bounds.width, height: footerViewHeight))
        balanceHistoryTableView.tableFooterView = footerView
    }

    func setupLocalizationForCVMBanner() {
        let viewModel = VFGCVMViewModel(
            title: "auto_top_up_cvm_title".localized(bundle: .mva10Framework),
            description: "auto_top_up_cvm_description".localized(bundle: .mva10Framework),
            buttonTitle: "auto_top_up_cvm_button_text".localized(bundle: .mva10Framework),
            delegate: self
        )
        cvmView?.configure(with: viewModel)
    }

    func setupFilterView() {
        filterView?.collectionViewDelegate = self
        filterView?.selectedCategories = [BalanceHistoryLocalize.all.localizedString]
        filterView?.selectCell(at: IndexPath(row: 0, section: 0))
        filterView.filterUnselectedBorderColor = .VFGPrimaryText
    }

    private func setHeightObserver() {
        guard heightObserver == nil else { return }
        heightObserver = balanceHistoryTableView?.observe(\.contentSize, options: [.new]) { [weak self]_, change in
            guard let self = self, let newHeight = change.newValue?.height else { return }
            self.balanceHistoryHeightConstraint.constant = newHeight
            self.updateHeightClosure?(newHeight + self.initialFrameHeight)
            self.balanceHistoryTableView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }

    func setupUI() {
        initialFrameHeight = view.frame.height
        balanceHistoryTitleLabel?.text = "balance_history_title".localized(bundle: .mva10Framework)
        datesLabel.text = "balance_screen_date_filter_title".localized(bundle: .mva10Framework)
        clearButton.setTitle(
            "balance_screen_date_filter_clear_button_title".localized(bundle: .mva10Framework),
            for: .normal)
        balanceHistoryTitleLabel.accessibilityIdentifier = "BHtitle"
        setupBalanceTableView()
        selectedDateViewHeight.constant = 0
        selectedDateStack.isHidden = true

        let tapGesture: UITapGestureRecognizer = .init(target: self, action: #selector(datePickerButtonDidPress))
        datesView.addGestureRecognizer(tapGesture)
    }

    func showErrorCard() {
        separatorView.isHidden = true
        let errorDescription = "balance_screen_error_message".localized(bundle: .mva10Framework)
        let tryAgainDescription = "balance_screen_try_again".localized(bundle: .mva10Framework)
        let errorConfig = VFGErrorModel(
            title: "",
            description: errorDescription,
            tryAgainText: tryAgainDescription
        )

        errorCardView = VFGErrorView(
            error: errorConfig,
            accessibilityIdInitial: "DBerror"
        )
        errorCardView?.tryAgainLabel.text = tryAgainDescription

        guard let errorCardView = errorCardView else { return }

        errorCardView.refreshingClosure = { [weak self] in
            guard let self = self else { return }
            self.removeErrorCard()
            self.historyViewModel?.fetchBalanceHistory()
        }
        errorCardView.alpha = 0
        view.addSubview(errorCardView)

        updateHeightClosure?(errorCardView.frame.height + initialFrameHeight)
        errorCardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorCardView.topAnchor.constraint(
                equalTo: balanceHistoryTitleLabel.bottomAnchor,
                constant: errorCardConstraintConstant),
            errorCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        UIView.animate(withDuration: Constants.ErrorCard.visibilityDuration) { [weak self] in
            guard let self = self else { return }
            errorCardView.alpha = 1
            self.balanceHistoryTableView.isHidden = true
            self.filterView.isHidden = true
        }
    }

    func removeErrorCard() {
        balanceHistoryTableView.isHidden = false
        filterView.isHidden = false
        separatorView.isHidden = false
        errorCardView?.removeFromSuperview()
        errorCardView = nil
    }

    func setupAccessibilityLabels() {
        balanceHistoryTitleLabel.accessibilityLabel = balanceHistoryTitleLabel.text ?? ""
        datesLabel.accessibilityLabel = datesLabel.text ?? ""
        calendarImageView.accessibilityLabel = "Icon for calendar"
        clearButton.accessibilityLabel = clearButton.titleLabel?.text ?? ""
        accessibilityCustomActions = [clearVoiceOverAction()]
    }
    /// action for  Balance History voice over
    /// - Returns: action for Balance History clear  button in voice over
    func clearVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "clear"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(clearSelectedDateButtonDidPress))
    }
}

extension BalanceHistoryViewController: HistoryDatePickerViewControllerDelegate {
    func dateRangeDidSelect(startDate: Date, endDate: Date?, dateRange: String) {
        rangeStartDate = startDate
        rangeEndDate = endDate
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.selectedDateViewHeight.constant = 20
            self?.selectedDateStack.isHidden = false
            self?.selectedDateLabel.text = dateRange
            self?.selectedDateLabel.accessibilityLabel = dateRange
            self?.view.layoutIfNeeded()
        }
        historyViewModel?.fetchBalanceHistory(dateRange: (from: startDate, to: endDate ?? startDate))
    }
}
