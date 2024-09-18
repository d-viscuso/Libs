//
//  VFGAppointmentStoreViewController.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/8/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//
import MapKit
import VFGMVA10Foundation

class VFGAppointmentStoreViewController: UIViewController, VFGBaseStepsViewControllerProtocol {
    @IBOutlet weak var locationPicker: VFGLocationPicker?

    var pinImage = VFGFrameworkAsset.Image.redPin
    var dotImage = VFGFrameworkAsset.Image.redDot
    lazy var viewModel: VFGAppointmentStoreViewModel = {
        VFGAppointmentStoreViewModel(
            dataProvider: VFGYourAppointmentsManager
                .shared
                .storeProvider ?? VFGAppointmentStoreDataProvider(baseURL: ""))
    }()

    var stepTitle = "book_appointment_store_step_title".localized(bundle: .mva10Framework)
    var onStepComplete: ((Any) -> Void)?
    var onContentHeightChange: ((CGFloat) -> Void)?
    static var instance: VFGBaseStepsViewControllerProtocol {
        UIStoryboard(
            name: "VFGAppointmentStoreViewController",
            bundle: .mva10Framework
        ).instantiateViewController(withIdentifier: "StoreView")
        as? VFGAppointmentStoreViewController ?? VFGAppointmentStoreViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationPicker()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onContentHeightChange?(0)
    }

    func fetchData() {
        onContentHeightChange?(0)
        initViewModel()
    }

    func initViewModel() {
        viewModel.updateLoadingStatus = { [weak self] in
            guard let self = self else {
                return
            }

            switch self.viewModel.contentState {
            case .loading:
                self.locationPicker?.contentState = .loading
            case .populated:
                self.locationPicker?.contentState = .populated
            case .empty:
                VFGDebugLog("empty")
            case .error:
                VFGDebugLog("error")
            case .filtered:
                VFGDebugLog("filter")
            }
        }

        viewModel.fetchStores()
    }

    func configureLocationPicker() {
        locationPicker?.dataSource = self
        locationPicker?.delegate = self
        locationPicker?.appearance = self
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                pinImage = VFGFrameworkAsset.Image.redPin
                dotImage = VFGFrameworkAsset.Image.redDot
            }
        }
    }
}
