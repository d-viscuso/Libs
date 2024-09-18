//
//  VFGBarringViewController.swift
//  VFGMVA10Framework
//
//  Created by Trachani, Vasiliki, Vodafone on 17/5/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Barring view controller.
public class VFGBarringViewController: UIViewController, BaseTabsViewController {
    // MARK: Outlets
    @IBOutlet weak var barringHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var barringTitleLabel: VFGLabel!
    @IBOutlet weak var barringTableView: UITableView!
    @IBOutlet weak var barringTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var barringTitleHeightConstraint: NSLayoutConstraint!

    var heightObserver: NSKeyValueObservation?
    private var initialFrameHeight: CGFloat = 0
    public var updateHeightClosure: ((CGFloat) -> Void)?
    public var setHeightClosure: ((CGFloat) -> Void)?
    /// Delegate for handling result of barring status changes
    public weak var barringAskChangeResult: VFGBarringAskChangesResultProtocol?
    /// Barring view model
    public var barringViewModel: VFGBarringViewModel?
    var quickActionsResultView: VFGQuickActionsResultView?
    /// Error card view
    var errorCardView: VFGErrorView?
    /// Boolean to indicate if barring status changes successful or not
    var barringAskChangesStatus = false
    /// Current barring item model
    var currentBarringItemModel: VFGBarringItemViewModel?
    /// Distance between barring title and error view card
    let errorCardConstraintConstant: CGFloat = 60

    lazy var loadingLogoView: VFGLoadingLogoView? = {
        let loadingScreenView: VFGLoadingLogoView? = VFGLoadingLogoView.loadXib(bundle: Bundle.foundation)
        loadingScreenView?.configure(
            style: .white,
            view: navigationController?.view ?? view,
            backgroundColor: UIColor.black.withAlphaComponent(0.6)
        )

        return loadingScreenView
    }()

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public required init(
        nibName: String = String(
        describing: VFGBarringViewController.self),
        bundle: Bundle = Bundle.mva10Framework
    ) {
        super.init(nibName: nibName, bundle: bundle)
        title = "barring_screen_title".localized(bundle: .mva10Framework)
    }

    public var rootViewController: (UIViewController & BaseTabsViewControllerDelegate)?

    public func refresh() {
        guard barringTableView != nil else {
            return
        }
        barringViewModel?.fetchBarringDetails()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// When return back to this view controller, set observation for height change again
        setHeightObserver()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeHeightObserver()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        setupUI()
        setupTableView()
    }

    private func setupTableView() {
        barringTableView.delegate = self
        barringTableView.dataSource = self
        barringTableView.rowHeight = UITableView.automaticDimension
        barringTableView.estimatedRowHeight = 100.0
        registerBarringTableCell(name: VFGBarringTableViewCell.reuseIdentifier)
        registerBarringTableCell(name: VFGBarringShimmerTableViewCell.reuseIdentifier)
    }

    /// Method that is used to register barring cells
    ///  - Parameters:
    ///     - name: cell reuse identifier
    private func registerBarringTableCell(name: String) {
        let nib = UINib(nibName: name, bundle: Bundle.mva10Framework)
        barringTableView
            .register(
                nib,
                forCellReuseIdentifier: name
            )
    }

    private func removeHeightObserver() {
        heightObserver = nil
    }

    func initViewModel() {
        barringViewModel?.updateLoadingStatus = { [weak self] in
            guard let self = self else { return }

            let contentState = self.barringViewModel?.contentState
            switch contentState {
            case .loading:
                self.removeErrorCard()
                self.rootViewController?.dataFetchingWillStart()
                self.barringTableView.isHidden = false
                self.barringTableView.reloadData()
                self.setHeightClosure?(self.barringTableView.bounds.height)
            case .populated:
                self.barringTableView.isHidden = false
                self.updateHeightClosure?(self.barringTableView.bounds.height)
                self.barringTableView.reloadData()
                self.rootViewController?.dataFetchingDidComplete()
            case .error:
                self.barringTableView.isHidden = true
                self.setupErrorCardView()
                self.updateHeightClosure?(self.view.bounds.height)
                self.rootViewController?.dataFetchingDidComplete()
            default:
                break
            }
        }
        barringViewModel?.fetchBarringDetails()
    }

    /// Set Error Card View
    func setupErrorCardView() {
        guard errorCardView == nil else { return }
        let errorDescription = "barring_screen_error_message".localized(bundle: .mva10Framework)
        let tryAgainDescription = "barring_screen_try_again".localized(bundle: .mva10Framework)
        let errorModel = VFGErrorModel(
            title: "",
            description: errorDescription,
            tryAgainText: tryAgainDescription
        )
        errorCardView = VFGErrorView(
            error: errorModel,
            accessibilityIdInitial: "BABarringError"
        )
        errorCardView?.tryAgainLabel.text = tryAgainDescription

        guard let errorCardView = errorCardView else { return }
        errorCardView.refreshingClosure = { [weak self] in
            guard let self = self else { return }
            self.removeErrorCard()
            self.refresh()
        }
        errorCardView.alpha = 0
        view.addSubview(errorCardView)

        updateHeightClosure?(errorCardView.frame.height + initialFrameHeight)
        errorCardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorCardView.topAnchor.constraint(
                equalTo: barringTitleLabel.bottomAnchor,
                constant: errorCardConstraintConstant),
            errorCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])

        UIView.animate(withDuration: Constants.ErrorCard.visibilityDuration) { [weak self] in
            guard let self = self else { return }
            errorCardView.alpha = 1
            self.barringTableView.isHidden = true
        }
    }

    /// Remove Error Card View from superview
    func removeErrorCard() {
        barringTableView.isHidden = false
        errorCardView?.removeFromSuperview()
        errorCardView = nil
    }

    /// Method that is used to setup views
    func setupUI() {
        barringAskChangeResult = self
        initialFrameHeight = view.frame.height

        /// Set layer of barring list tableview
        barringTableView.layer.cornerRadius = 6
        barringTableView.addingShadow(size: CGSize(width: 0, height: 2), radius: 6, opacity: 0.16)
        /// Set barring title view
        guard let isPermissionsTitleHidden = barringViewModel?.viewDetails?.isBarringTitleHidden,
            !isPermissionsTitleHidden else {
                self.barringTitleLabel.isHidden = true
                self.barringTitleHeightConstraint.constant = 0
                self.barringTopConstraint.constant = 0
                return
            }

        barringTitleLabel.isHidden = false
        barringTitleHeightConstraint.constant = 27
        barringTopConstraint.constant = 16
        barringTitleLabel?.text = "barring_title".localized(bundle: .mva10Framework)
        barringTitleLabel.accessibilityIdentifier = "BAtitle"
        setupAccessibilityLabels()
    }

    private func setHeightObserver() {
        guard heightObserver == nil else { return }
        heightObserver = barringTableView?.observe(\.contentSize, options: [.new]) { [weak self]_, change in
            guard let self = self, let newHeight = change.newValue?.height else { return }
            self.barringHeightConstraint.constant = newHeight
            self.setHeightClosure?(newHeight + self.initialFrameHeight)
            self.barringTableView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }

    deinit {
        heightObserver = nil
    }
}

extension VFGBarringViewController {
    /// Method that is used to setup the flow of ask changes for barring item view model
    func confirmPermissionAskChangesAction(permissionViewModel: VFGBarringItemViewModel) {
        startLoading()
        barringViewModel?.viewDetails?.confirmButtonAction(id: permissionViewModel.id) { [weak self] isCompletedSuccess in
            self?.endLoading()
            guard let self = self, let isCompletedSuccess = isCompletedSuccess  else { return }
            if isCompletedSuccess {
                self.barringAskChangeResult?.showSuccessQuickResult()
            } else {
                self.barringAskChangeResult?.showErrorQuickResult(model: permissionViewModel)
            }
        }
    }

    /// Method that is used to start loader
    private func startLoading() {
        loadingLogoView?.startLoading()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    /// Method that is used to stop loader
    private func endLoading() {
        loadingLogoView?.endLoading()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

extension VFGBarringViewController: VFGBarringTableViewCellProtocol {
    func didPressToggle(for indexPath: IndexPath) {
        guard let permissionModel = barringViewModel?.barringDetails?[indexPath.row] else { return }
        let permissionAskChangesCard = VFGBarringAskChangesCardView(
            confirmAction: { [weak self] in
                guard let self = self else { return }
                self.confirmPermissionAskChangesAction(permissionViewModel: permissionModel)
            }, permissionViewModel: permissionModel
        )

        VFQuickActionsViewController.presentQuickActionsViewController(with: permissionAskChangesCard)
    }
}

extension VFGBarringViewController {
    func setupAccessibilityLabels() {
        barringTitleLabel.accessibilityLabel = barringTitleLabel.text ?? ""
    }
}
