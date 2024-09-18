//
//  VFGAppointmentsCollectionViewCell.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 14/02/2021.
//

import UIKit
import VFGMVA10Foundation

class VFGAppointmentsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var getStoreDirectionButton: VFGButton!
    @IBOutlet weak var changeBookingButton: VFGButton!
    @IBOutlet weak var serviceIconImageView: VFGImageView!
    @IBOutlet weak var appointmentTitleLabel: VFGLabel!
    @IBOutlet weak var requirementsView: AppointmentRequirementsView!
    @IBOutlet weak var addressView: VFGAddressView!
    @IBOutlet weak var appointmentDateLabel: VFGLabel!
    @IBOutlet weak var cancelButton: VFGButton!

    var storeLocationButtonPressed: (() -> Void)?
    var cancelButtonPressed: (() -> Void)?
    var changeBookButtonPressed: (() -> Void)?
    private let changeBookingButtonTitle = "your_appointments_change_booking_button".localized(bundle: .mva10Framework)
    private let directionTitle = "your_appointments_get_store_directions_button".localized(bundle: .mva10Framework)

    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
    }

    func setupCell(appointment: VFGAppointmentModelProtocol) {
        appointmentTitleLabel.text = appointment.service?.title
        serviceIconImageView.image = VFGImage(named: appointment.service?.summaryIconImageName ?? "")
        changeBookingButton.setTitle(changeBookingButtonTitle, for: .normal)
        getStoreDirectionButton.setTitle(directionTitle, for: .normal)
        if let store = appointment.store {
            addressView.setup(with: store)
        }

        if let date = appointment.dateTime?.date, let timeSlot = appointment.dateTime?.timeSlot.asString,
            let dateAsString = VFGBookAppointmentViewController.stringFrom(date: date) {
            appointmentDateLabel.text = "\(dateAsString) \(timeSlot)"
        }

        if let requirements = appointment.requirements {
            requirementsView.setup(with: requirements)
        } else {
            requirementsView.isHidden = true
        }
        cancelButton.setTitle(
            "your_appointments_cancel_booking_button".localized(bundle: .mva10Framework), for: .normal)
        addAccessibilityForVoiceOver()
        setupAccessibilityIDs()
    }

    func setupAccessibilityIDs() {
        appointmentTitleLabel.accessibilityIdentifier = "YAtitleLabel"
        getStoreDirectionButton.accessibilityIdentifier = "YAgetStoreDirectionButton"
    }

    @IBAction func storeLocationButtonPressed(_ sender: Any) {
        storeLocationButtonAction()
    }
    @objc func storeLocationButtonAction() {
        storeLocationButtonPressed?()
    }

    @IBAction func changeBookButtonPressed(_ sender: Any) {
        changeBookAction()
    }
    @objc func changeBookAction() {
        changeBookButtonPressed?()
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        cancelButtonAction()
    }

    @objc func cancelButtonAction() {
        cancelButtonPressed?()
    }
}

extension VFGAppointmentsCollectionViewCell {
    func addShadow() {
        contentView.layer.cornerRadius = 4
        contentView.addingShadow(size: CGSize(width: 0, height: 1), radius: 4, opacity: 0.16)
        contentView.layer.masksToBounds = true
    }
}
