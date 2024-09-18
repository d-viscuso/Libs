//
//  VFGBookAppointmentViewController.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/7/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation


class VFGBookAppointmentViewController: VFGBaseViewController {
    @IBOutlet weak var stepController: VFGHorizontalStepControl!
    @IBOutlet weak var collectionView: UICollectionView!

    lazy public var stepsViewControllers: [VFGBaseStepsViewControllerProtocol] = {
        [
            VFGAppointmentServiceViewController.instance,
            VFGAppointmentStoreViewController.instance,
            VFGAppointmentDateViewController.instance,
            VFGAppointmentSummaryViewController.instance
        ]
    }()


    let stepsCollectionCellId = "StepsCollectionCell"
    let stepsCollectionCellNibName = "StepsCollectionCell"
    var appointment = VFGAppointmentModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupStepController()
    }

    private func setupCollectionView() {
        collectionView.contentInset = UIEdgeInsets.zero
        collectionView.scrollIndicatorInsets = UIEdgeInsets.zero
        collectionView.delegate = self
        collectionView.dataSource = self

        registerCollectionCell()
    }

    private func registerCollectionCell() {
        collectionView.register(
            UINib(nibName: stepsCollectionCellNibName, bundle: .mva10Framework),
            forCellWithReuseIdentifier: stepsCollectionCellId
        )
    }

    private func setupStepController() {
        stepController.delegate = self
        stepController.dataSource = self

        // Index is only used and the stepController value is ignored
        // because it will cause a retain cycle when its used in the below closure
        stepsViewControllers.enumerated().forEach { index, _ in
            stepsViewControllers[index].onStepComplete = { [weak self] stepModel in
                guard let self = self else {
                    return
                }

                self.fillAppointmentModel(with: stepModel, for: self.stepsViewControllers[index])

                if self.stepsViewControllers[index] is VFGAppointmentSummaryViewController {
                    self.confirm()
                } else {
                    self.stepController.complete()
                }
            }
        }
    }

    private func fillAppointmentModel(
        with stepModel: Any,
        for stepViewController: VFGBaseStepsViewControllerProtocol
    ) {
        switch stepViewController {
        case is VFGAppointmentServiceViewController:
            if var service = stepModel as? VFGAppointmentServiceModel.Service {
                let assistance = "book_appointment_summary_step_assistance".localized(bundle: .mva10Framework)
                service.title += " \(assistance)"
                appointment.service = service
            }
        case is VFGAppointmentStoreViewController:
            appointment.store = stepModel as? VFGAppointmentStoreModel.Store
        case is VFGAppointmentDateViewController:
            if let dateTime = stepModel as? VFGAppointmentModel.DateTime {
                appointment.dateTime = dateTime
            }
        default:
            break
        }
    }

    private func confirm() {
        let confirmViewController: VFGAppointmentConfirmViewController = {
            UIStoryboard(
                name: "VFGAppointmentConfirmViewController",
                bundle: .mva10Framework
            ).instantiateViewController(withIdentifier: "ConfirmView")
            as? VFGAppointmentConfirmViewController ?? VFGAppointmentConfirmViewController()
        }()

        confirmViewController.appointment = appointment

        confirmViewController.closeDidTap = { [weak self] in
            (self?.navigationController as? MVA10NavigationController)?.closeTapped()
        }

        confirmViewController.backDidTap = { [weak self] in
            let yourAppointmentVC =
                (self?.navigationController?.viewControllers.first as? VFGYourAppointmentsViewController)
            yourAppointmentVC?.shouldReloadData = true
            (self?.navigationController as? MVA10NavigationController)?.backTapped()
        }
        confirmViewController.modalPresentationStyle = .fullScreen
        present(confirmViewController, animated: false)

        // Demo: This an appointment for demo purposes
        VFGYourAppointmentsManager.shared.demoAppointments.append(appointment)
    }

    static func stringFrom(date: Date, customText: String = "") -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"

        guard let day = formatter.string(from: date).ordinalNumber else {
            return nil
        }

        var dateFormate: String = ""
        if customText.isEmpty {
            dateFormate = String(format: "EEEE '%@ of' MMMM", day)
        } else {
            dateFormate = String(format: "EEEE '%@ of' '\(customText)' of MMMM", day)
        }

        return VFGDateHelper.getStringFromDate(date: date, dateFormat: dateFormate)
    }
}
