//
//  VFGYourAppointmentsHistoryTableViewCell.swift
//  VFGMVA10Framework
//
//  Created by Samar Younan on 07/02/2022.
//

import UIKit
import VFGMVA10Foundation

class VFGYourAppointmentsHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceIconImageView: VFGImageView!
    @IBOutlet weak var appointmentTitleLabel: VFGLabel!
    @IBOutlet weak var addressView: VFGAddressView!
    @IBOutlet weak var appointmentDateLabel: VFGLabel!
    @IBOutlet weak var reviewButton: VFGButton!
    @IBOutlet weak var requestAgaiButton: VFGButton!
    var reviewButtonPressedAction: ((_ appointmentId: String) -> Void)?
    var requestAgainButtonPressedAction: (() -> Void)?
    var appointmentId: String?

    func setupCell(appointment: VFGAppointmentModelProtocol) {
        selectionStyle = .none
        appointmentId = appointment.id
        reviewButton.isHidden = appointment.hasReview ?? false
        appointmentTitleLabel.text = appointment.service?.title
        serviceIconImageView.image = VFGImage(named: appointment.service?.summaryIconImageName ?? "")

        if let store = appointment.store {
            addressView.setup(with: store)
        }

        if let date = appointment.dateTime?.date, let timeSlot = appointment.dateTime?.timeSlot.asString,
            let dateAsString = VFGBookAppointmentViewController.stringFrom(date: date) {
            appointmentDateLabel.text = "\(dateAsString) \(timeSlot)"
        }
        let reviewButtonTitle = "your_appointments_history_review_button".localized(bundle: Bundle.mva10Framework)
        reviewButton.setTitle(reviewButtonTitle, for: .normal)
        let requestBtnTitle = "your_appointments_history_request_again_button".localized(bundle: Bundle.mva10Framework)
        requestAgaiButton.setTitle(requestBtnTitle, for: .normal)
    }
    @IBAction func requestAgainButtonPressed(_ sender: Any) {
        requestAgainButtonPressedAction?()
    }

    @IBAction func reviewButtonPressed(_ sender: Any) {
        reviewButtonPressedAction?(appointmentId ?? "")
    }
}
