//
//  VFGAppointmentSummaryViewController.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/8/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import Lottie

class VFGAppointmentSummaryViewController: UIViewController, VFGBaseStepsViewControllerProtocol {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var subtitleLabel: VFGLabel!
    @IBOutlet weak var serviceIconImageView: VFGImageView!
    @IBOutlet weak var serviceTitleLabel: VFGLabel!
    @IBOutlet weak var addressView: VFGAddressView!
    @IBOutlet weak var dateTimeLabel: VFGLabel!
    @IBOutlet weak var confirmView: VFGConfirmView!

    static var instance: VFGBaseStepsViewControllerProtocol {
        UIStoryboard(
            name: "VFGAppointmentSummaryViewController",
            bundle: .mva10Framework
        ).instantiateViewController(withIdentifier: "SummaryView")
        as? VFGAppointmentSummaryViewController ?? VFGAppointmentSummaryViewController()
    }

    lazy var viewModel: VFGAppointmentSummaryViewModel = {
        VFGAppointmentSummaryViewModel(
            dataProvider: VFGYourAppointmentsManager.shared.summaryProvider ?? VFGAppointmentSummaryDataProvider()
        )
    }()
    var appointment: VFGAppointmentModelProtocol?
    let tobiMargin: CGFloat = 20

    var stepTitle: String = "book_appointment_summary_step_title".localized(bundle: .mva10Framework)
    var onStepComplete: ((Any) -> Void)?
    var onContentHeightChange: ((CGFloat) -> Void)?
    lazy var contentHeight: CGFloat = {
        contentView.frame.height + contentView.frame.origin.y + tobiMargin
    }()
    lazy var loadingLogoView: VFGLoadingLogoView? = VFGLoadingLogoView.loadXib(bundle: .foundation)

    override func viewDidLoad() {
        super.viewDidLoad()

        confirmView.delegate = self
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onContentHeightChange?(contentHeight)
    }

    func initViewModel() {
        viewModel.updateLoadingStatus = { [weak self] in
            guard let self = self else {
                return
            }

            switch self.viewModel.contentState {
            case .loading:
                self.toggleLoadingVisibility(true)
            case .populated:
                self.toggleLoadingVisibility(false)
            case .empty:
                VFGDebugLog("empty")
            case .error:
                self.toggleLoadingVisibility(false)
            case .filtered:
                VFGDebugLog("filter")
            }
        }
    }

    func configureUI() {
        subtitleLabel.text = "book_appointment_summary_step_subtile".localized(bundle: .mva10Framework)
    }

    func toggleLoadingVisibility(_ state: Bool) {
        if state {
            guard let topView = UIApplication.topViewController()?.view else {
                return
            }
            loadingLogoView?.configure(
                style: .white,
                view: topView,
                backgroundColor: UIColor.black.withAlphaComponent(0.6)
            )
            loadingLogoView?.startLoading()
        } else {
            loadingLogoView?.endLoading()
        }
    }
}

extension VFGAppointmentSummaryViewController: VFGSummaryStepViewControllerProtocol {
    func summarize(with appointment: VFGAppointmentModelProtocol) {
        self.appointment = appointment
        serviceIconImageView.image = VFGImage(named: appointment.service?.summaryIconImageName ?? "")
        serviceTitleLabel.text = appointment.service?.title

        if let store = appointment.store {
            addressView.setup(with: store)
        }

        if let date = appointment.dateTime?.date,
            let timeSlot = appointment.dateTime?.timeSlot.asString,
            let dateAsString = VFGBookAppointmentViewController.stringFrom(date: date) {
                dateTimeLabel.text = "\(dateAsString) \(timeSlot)"
        }

        (view.superview?.superview as? UIScrollView)?.contentOffset.y = 0
    }
}

extension VFGAppointmentSummaryViewController: VFGWebViewDelegate {
    public func close(sender viewController: VFGWebViewController) {
        dismiss(animated: true)
    }
}

extension VFGAppointmentSummaryViewController: VFGConfirmViewDelegate {
    func confirmButtonDidPress(_ confirmView: VFGConfirmView) {
        initViewModel()
        viewModel.saveAppointment(with: appointment ?? VFGAppointmentModel()) { [weak self] in
            guard let self = self else {
                return
            }

            self.viewModel.contentState = .populated
            self.onStepComplete?(self)
        }
    }

    func hyperLinkDidPress(_ confirmView: VFGConfirmView, url: String) {
        let viewController = webViewController(with: url)
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true)
    }

    func webViewController(with url: String) -> UIViewController {
        let viewModel = VFGWebViewModel(urlString: url)
        return VFGWebViewController.instance(with: viewModel, delegate: self)
    }
}
