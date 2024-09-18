//
//  VFGYourAppointmentsViewController.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 02/02/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Your appointment view controller.
public class VFGYourAppointmentsViewController: UIViewController {
    @IBOutlet weak var bookAppointmentButton: VFGButton!
    @IBOutlet weak var bookAppointmentButtonShimmerView: VFGShimmerView!
    @IBOutlet weak var appointmentsCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sectionTitleLabel: VFGLabel!
    @IBOutlet weak var sectionTitleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bookAppointmentButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var shimmerButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var customBottomView: UIView!
    @IBOutlet weak var customBottomViewHeightConstraint: NSLayoutConstraint!

    let defaultSectionTitleLabelHeight: CGFloat = 34
    let defaultBookAppointmentButtonHeight: CGFloat = 46
    let defaultButtonShimmerViewHeight: CGFloat = 30
    let leftInset: CGFloat = 16.0
    let rightSpacing: CGFloat = 8
    let customBottomViewHeight: CGFloat = 86
    var cellSize: CGSize = .zero
    var defaultCellSize: CGSize = .zero

    public lazy var viewModel: VFGYourAppointmentsViewModelProtocol = {
        VFGYourAppointmentsViewModel()
    }()
    weak var mva10navigationController: MVA10NavigationController?
    var shouldReloadData = false
    weak var delegate: VFGYourAppointmentsDelegate?

    private var isMVA10navigationController: Bool {
        if let mva10NavC = navigationController as?
            MVA10NavigationController {
            mva10navigationController = mva10NavC
            return true
        }
        return false
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        initViewModel()
        setupUI()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureCollectionView()

        if shouldReloadData {
            viewModel.fetchAppointments()
            shouldReloadData = false
        }
        addAccessibilityForVoiceOver()
    }

    /// *VFGYourAppointmentsViewController* configuration.
    /// - Parameters:
    ///    - delegate: *VFGYourAppointmentsDelegate?*.
    ///    - dataProvider: *VFGYourAppointmentsDataProviderProtocol?*.
    public func configure(
        delegate: VFGYourAppointmentsDelegate?,
        dataProvider: VFGYourAppointmentsDataProviderProtocol?
    ) {
        self.delegate = delegate
        guard let dataProvider = dataProvider else { return }
        viewModel.dataProvider = dataProvider
    }

    func initViewModel() {
        viewModel.updateLoadingStatus = updateLoadingStatus
        viewModel.fetchAppointments()
    }

    func updateLoadingStatus() {
        setupAppointmentButtonTitle()
        switch viewModel.contentState {
        case .loading:
            appointmentsCollectionView.reloadData()
            bookAppointmentButtonShimmerView?.startAnimation()
            appointmentsCollectionView.isScrollEnabled = false
            bookAppointmentButtonShimmerView.isHidden = false
            bookAppointmentButton.isHidden = true
        case .populated:
            appointmentsCollectionView.reloadData()
            bookAppointmentButton.isHidden = false
            appointmentsCollectionView.isScrollEnabled = true
            bookAppointmentButtonShimmerView.isHidden = true
        case .empty:
            appointmentsCollectionView.reloadData()
            bookAppointmentButtonShimmerView.isHidden = true
            bookAppointmentButton.isHidden = false
            guard viewModel.numberOfHistoryAppointments() > 0 && viewModel.customView != nil else { return }
            collectionViewHeightConstraint.constant = .zero
        case .error:
            appointmentsCollectionView.reloadData()
            bookAppointmentButton.isHidden = false
            bookAppointmentButtonShimmerView.isHidden = true
            setupAppointmentButtonTitle(viewModel.errorModel?.tryAgainLabel)
            VFGDebugLog("Failed fetching appointments")
        case .filtered:
            VFGDebugLog("filter")
        }
        setupCustomView()
    }

    func setupUI() {
        setupAppointmentButtonTitle()

        if isMVA10navigationController {
            navigationController?.setNavigationBarHidden(true, animated: true)
            mva10navigationController?.setTitle(
                title: "your_appointments_screen_title".localized(bundle: Bundle.mva10Framework),
                for: self
            )
        } else {
            let attributes = [
                NSAttributedString.Key.font: UIFont.vodafoneRegular(19.0),
                .foregroundColor: UIColor.VFGPrimaryText
            ]
            navigationController?.topViewController?.title =
                "your_appointments_screen_title"
                .localized(bundle: Bundle.mva10Framework)
            navigationController?.navigationBar.titleTextAttributes = attributes
        }
    }

    func setupAppointmentButtonTitle(_ title: String? = nil) {
        bookAppointmentButton?.setTitle(
            title ?? "your_appointments_book_button".localized(bundle: Bundle.mva10Framework),
            for: .normal)
    }

    func setupCustomView() {
        if viewModel.customView != nil && viewModel.numberOfHistoryAppointments() != 0 {
            setupCustomViewIfAvailable()
        } else {
            hideCustomView()
        }
    }

    func setupCustomViewIfAvailable() {
        guard let customAppointmentView = viewModel.customView else { return }
        bookAppointmentButtonBottomConstraint?.isActive = false
        shimmerButtonBottomConstraint?.isActive = false
        customBottomViewHeightConstraint?.constant = customBottomViewHeight
        customView.embed(view: customAppointmentView)
        customView.heightAnchor.constraint(equalTo: customAppointmentView.heightAnchor).isActive = true
        customView.isHidden = false
        customView.layoutIfNeeded()
        let isSectionTitleHidden = viewModel.numberOfHistoryAppointments() > 0 && viewModel.contentState == .empty
        sectionTitleLabel.isHidden = isSectionTitleHidden
        sectionTitleLabel.text = "your_appointments_header_title".localized(bundle: Bundle.mva10Framework)
        sectionTitleLabelHeightConstraint.constant = isSectionTitleHidden ? 0 : defaultSectionTitleLabelHeight
        customBottomView.isHidden = false
        customBottomView.configureShadow()
        bookAppointmentButtonShimmerView.removeFromSuperview()
        customBottomView.embed(view: bookAppointmentButtonShimmerView, top: 28, bottom: -28, leading: 20, trailing: -20)
        bookAppointmentButtonShimmerView.heightAnchor.constraint(
            equalToConstant: defaultButtonShimmerViewHeight
        ).isActive = true
        bookAppointmentButton.removeFromSuperview()
        customBottomView.embed(view: bookAppointmentButton, top: 20, bottom: -20, leading: 20, trailing: -20)
        bookAppointmentButton.heightAnchor.constraint(
            equalToConstant: defaultBookAppointmentButtonHeight
        ).isActive = true
    }

    func hideCustomView() {
        customView.isHidden = true
        customBottomView.isHidden = true
        customBottomViewHeightConstraint?.constant = 0
        sectionTitleLabelHeightConstraint.constant = 0
        bookAppointmentButtonBottomConstraint?.isActive = true
        shimmerButtonBottomConstraint?.isActive = true
    }

    @IBAction func bookAppointmentButtonPressed(_ sender: VFGButton) {
        guard viewModel.contentState == .error else {
            return bookAppointmentAction()
        }
        viewModel.errorModel?.tryAgainHandler()
    }

    @objc func bookAppointmentAction() {
        if let delegate = delegate {
            delegate.bookAppointmentButtonDidPress()
            return
        }
        let bookAppointmentVC = UIStoryboard(
            name: "VFGBookAppointment",
            bundle: .mva10Framework
        ).instantiateViewController(withIdentifier: "VFGBookAppointment")

        let navigation = navigationController as? MVA10NavigationController
        navigation?.setTitle(
            title: "your_appointments_book_button"
                .localized(bundle: .mva10Framework),
            for: bookAppointmentVC
        )

        navigation?.pushViewController(bookAppointmentVC, animated: true)
    }

    func configureCollectionView() {
        appointmentsCollectionView?.dataSource = self
        appointmentsCollectionView?.delegate = self

        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let itemSizeLeftInset = screenWidth - (leftInset + rightSpacing)

        defaultCellSize = CGSize(width: itemSizeLeftInset, height: 450)
        cellSize = CGSize(width: itemSizeLeftInset, height: appointmentsCollectionView?.layer.frame.height ?? 0)
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightSpacing)
        layout.minimumLineSpacing = -rightSpacing
        layout.scrollDirection = .horizontal

        appointmentsCollectionView?.collectionViewLayout = layout
        appointmentsCollectionView.registerVFGCell(with: ErrorCollectionViewCell.self)
    }
}
