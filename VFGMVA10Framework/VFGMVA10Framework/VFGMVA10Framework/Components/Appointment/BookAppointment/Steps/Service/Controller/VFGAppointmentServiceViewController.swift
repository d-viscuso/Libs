//
//  VFGAppointmentServiceViewController.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/8/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGAppointmentServiceViewController: UIViewController, VFGBaseStepsViewControllerProtocol {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var subtitleLabel: VFGLabel!

    var onStepComplete: ((Any) -> Void)?
    var onContentHeightChange: ((CGFloat) -> Void)?
    static var instance: VFGBaseStepsViewControllerProtocol {
        UIStoryboard(
            name: "VFGAppointmentServiceViewController",
            bundle: .mva10Framework
        ).instantiateViewController(withIdentifier: "ServiceView")
        as? VFGAppointmentServiceViewController ?? VFGAppointmentServiceViewController()
    }

    var selectedTimeSlot: IndexPath?
    let collectionBottomPadding: CGFloat = 35
    var stepTitle: String = "book_appointment_service_step_title".localized(bundle: .mva10Framework)
    lazy var viewModel: VFGAppointmentServiceViewModel = {
        VFGAppointmentServiceViewModel(
            dataProvider: VFGYourAppointmentsManager
                .shared
                .serviceProvider ?? VFGAppointmentServiceDataProvider())
    }()

    lazy var contentHeight: CGFloat = {
        collectionView.contentSize.height + collectionView.frame.origin.y + collectionBottomPadding
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        initViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.contentState == .populated {
            onContentHeightChange?(contentHeight)
        }
    }

    private func initViewModel() {
        viewModel.updateLoadingStatus = { [weak self] in
            guard let self = self else {
                return
            }

            switch self.viewModel.contentState {
            case .loading:
                self.onContentHeightChange?(0)
                VFGDebugLog("loading")
            case .populated:
                self.collectionView.reloadData()
                self.onContentHeightChange?(self.contentHeight)
            case .empty:
                VFGDebugLog("empty")
            case .error:
                VFGDebugLog("error")
            case .filtered:
                VFGDebugLog("filter")
            }
        }

        viewModel.fetchServices()
    }

    private func configureUI() {
        subtitleLabel.text = "book_appointment_service_step_subtile".localized(bundle: .mva10Framework)
        subtitleLabel.accessibilityLabel = subtitleLabel.text
    }
}

// MARK: UICollectionViewDataSource
extension VFGAppointmentServiceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.contentState == .loading ? 3 : viewModel.numberOfServices()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.contentState {
        case .loading:
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ShimmerCell",
                    for: indexPath) as? VFGAppointmentServiceShimmerCell {
                cell.startShimmer()
                cell.accessibilityIdentifier = "APServiceShimmerCell_\(indexPath.row)"
                return cell
            }
        case .populated:
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ServiceCell",
                    for: indexPath) as? VFGAppointmentServiceCollectionCell {
                (collectionView.dequeueReusableCell(
                    withReuseIdentifier: "ShimmerCell",
                    for: indexPath) as? VFGAppointmentServiceShimmerCell)?.stopShimmer()
                cell.setup(with: viewModel.service(at: indexPath.row))
                cell.isAccessibilityElement = false
                cell.accessibilityIdentifier = "APserviceCell_\(indexPath.row)"
                cell.setupAccessibilityIds(with: indexPath.row)
                return cell
            }
        default:
            return UICollectionViewCell()
        }

        return UICollectionViewCell()
    }
}

// MARK: UICollectionViewDelegate
extension VFGAppointmentServiceViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onStepComplete?(viewModel.service(at: indexPath.row))
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension VFGAppointmentServiceViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: collectionView.frame.width,
            height: Constants.Appointment.Size.ServiceCell.height
        )
    }
}
