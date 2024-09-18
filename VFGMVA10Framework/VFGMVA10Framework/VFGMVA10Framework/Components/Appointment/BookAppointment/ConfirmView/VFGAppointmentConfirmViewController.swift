//
//  VFGAppointmentConfirmViewController.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/12/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import EventKit
import Lottie
import VFGMVA10Foundation

class VFGAppointmentConfirmViewController: UIViewController {
    @IBOutlet weak var closeButton: VFGButton!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var tickAnimationView: AnimationView!
    @IBOutlet weak var subtitleLabel: VFGLabel!
    @IBOutlet weak var addressView: VFGAddressView!
    @IBOutlet weak var dateTimeLabel: VFGLabel!
    @IBOutlet weak var calendarButton: VFGButton!
    @IBOutlet weak var yourAppointmentButton: VFGButton!

    var backDidTap: (() -> Void)?
    var closeDidTap: (() -> Void)?

    var appointment: VFGAppointmentModel?
    var subtitle: NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(
            string: "book_appointment_confirm_subtitle".localized(bundle: .mva10Framework),
            attributes: [
                .font: UIFont.vodafoneRegular(19),
                .foregroundColor: UIColor.VFGPrimaryText
            ]
        )
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .center
        attributedString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )

        return attributedString
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        addAccessibilityForVoiceOver()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tickAnimationView.play()
    }

    func configureUI() {
        titleLabel.text = "book_appointment_confirm_title".localized(bundle: .mva10Framework)
        subtitleLabel.text = "book_appointment_confirm_subtitle".localized(bundle: .mva10Framework)
        tickAnimationView.animation = Animation.tick
        setCalendarButtonTitle()
        yourAppointmentButton.setTitle(
            "book_appointment_confirm_appointment_button_title".localized( bundle: .mva10Framework),
            for: .normal
        )

        if let date = appointment?.dateTime?.date,
            let timeSlot = appointment?.dateTime?.timeSlot.asString,
            let dateAsString = VFGBookAppointmentViewController.stringFrom(date: date) {
                dateTimeLabel.text = "\(dateAsString) \(timeSlot)"
        }
        if let store = appointment?.store {
            addressView.setup(with: store)
        }
    }

    func setCalendarButtonTitle() {
        calendarButton.setTitle(
            "book_appointment_confirm_calendar_button_title".localized( bundle: .mva10Framework),
            for: .normal
        )
        calendarButton.isEnabled = true
    }

    @IBAction func yourAppointmentDidPress(_ sender: Any) {
        yourAppointmentAction()
    }

    @objc func yourAppointmentAction() {
        backDidTap?()
        dismiss(animated: false)
    }

    @IBAction func addToCalendarButtonDidPress(_ sender: Any) {
        addToCalendarAction()
    }

    @objc func addToCalendarAction() {
        authorizeCalendar { [weak self] eventStore in
            guard let eventStore = eventStore, let self = self else {
                return
            }

            if self.addAppointment(eventStore) is Bool {
                DispatchQueue.main.async { [weak self] in
                    self?.calendarButton.setTitle(
                        "book_appointment_confirm_calendar_success_title".localized( bundle: .mva10Framework),
                        for: .normal
                    )
                    self?.calendarButton.isEnabled = false
                }
            } else if let error = self.addAppointment(eventStore) as? Error {
                DispatchQueue.main.async { [weak self] in
                    self?.calendarButton.setTitle(
                        "book_appointment_confirm_calendar_failure_title".localized( bundle: .mva10Framework),
                        for: .normal
                    )
                    self?.calendarButton.isEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                        self?.setCalendarButtonTitle()
                    }
                }
                debugPrint("failed to save event with error : \(error)")
            }
        }
    }

    @IBAction func closeButtonDidPress() {
        closeAction()
    }

    @objc func closeAction() {
        closeDidTap?()
        dismiss(animated: false)
    }

    private func authorizeCalendar(completion: @escaping (_ eventStore: EKEventStore?) -> Void) {
        let eventStore = EKEventStore()

        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            completion(eventStore)
        case .notDetermined:
            eventStore.requestAccess(to: .event) { (granted: Bool, _) -> Void in
                if granted {
                    completion(eventStore)
                } else {
                    completion(nil)
                }
            }
        default:
            break
        }
    }

    private func addAppointment(_ eventStore: EKEventStore) -> Any {
        let event = EKEvent(eventStore: eventStore)
        event.title = "\(appointment?.service?.title ?? "") at \(appointment?.store?.name ?? "")"
        event.location = appointment?.store?.address
        if let phoneNumber = appointment?.store?.phoneNumber, let email = appointment?.store?.email {
            event.notes = "Phone number: \(phoneNumber)\nEmail: \(email)"
        }
        event.startDate = appointment?.dateTime?.startDate
        event.endDate = appointment?.dateTime?.endDate
        event.calendar = eventStore.defaultCalendarForNewEvents

        do {
            try eventStore.save(event, span: .thisEvent)
            return true
        } catch let error as NSError {
            return error
        }
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(
                comparedTo: previousTraitCollection
            ) {
                tickAnimationView.animation = Animation.tick
                tickAnimationView.currentProgress = 1
            }
        }
    }
}
