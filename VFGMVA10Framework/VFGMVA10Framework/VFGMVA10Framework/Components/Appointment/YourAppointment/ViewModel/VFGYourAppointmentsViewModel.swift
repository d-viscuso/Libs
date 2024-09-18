//
//  VFGYourAppointmentsViewModel.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 02/02/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public class VFGYourAppointmentsViewModel: VFGYourAppointmentsViewModelProtocol {
    private var appointments: [VFGAppointmentModelProtocol] = []
    public var historyAppointments: [VFGAppointmentModelProtocol] = []
    public var dataProvider: VFGYourAppointmentsDataProviderProtocol?
    public var contentState: VFGContentState = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    public var errorModel: VFGYourAppointmentsErrorModel?

    public var updateLoadingStatus: (() -> Void)?

    public init(dataProvider: VFGYourAppointmentsDataProviderProtocol? = nil) {
        self.dataProvider = dataProvider ?? VFGYourAppointmentsManager.shared.dataProvider
    }

    public func fetchAppointments() {
        contentState = .loading

        dataProvider?.fetchAppointments { [weak self] appointments, _ in
            guard let self = self else { return }
            guard let appointments = appointments else {
                self.contentState = .error
                return
            }

            self.historyAppointments = self.getHistoryAppointments(appointments: appointments)
            self.appointments = self.checkUpcomingAppointemnts(appointments: appointments)
            // Demo: This is for demo purposes
            self.addDemoAppointmentIfAvailable()
            if self.appointments.isEmpty {
                self.contentState = .empty
                return
            }
            self.contentState = .populated
        }
    }

    public func numberOfUpcomingAppointments() -> Int {
        appointments.count
    }
    public func numberOfHistoryAppointments() -> Int {
        historyAppointments.count
    }

    public func appointment(at index: Int) -> VFGAppointmentModelProtocol {
        appointments[safe: index] ?? VFGAppointmentModel()
    }
    public func historyAppointment(at index: Int) -> VFGAppointmentModelProtocol {
        historyAppointments[safe: index] ?? VFGAppointmentModel()
    }
    // Demo: This function is for demo purposes
    func addDemoAppointmentIfAvailable() {
        if !VFGYourAppointmentsManager.shared.demoAppointments.isEmpty {
            appointments = VFGYourAppointmentsManager.shared.demoAppointments
            historyAppointments = VFGYourAppointmentsManager.shared.demoAppointments
        }
    }
    public var customView: UIView? {
        dataProvider?.customView
    }
    func checkUpcomingAppointemnts(appointments: [VFGAppointmentModelProtocol]) -> [VFGAppointmentModelProtocol] {
        var upcomingAppointments: [VFGAppointmentModelProtocol] = []
        let currentDate = Double(getCurrentTime(date: Date()))
        for appointment in appointments {
            if let filterationDate = appointment.appointmentFilterationDate,
                filterationDate >= currentDate {
                upcomingAppointments.append(appointment)
            }
        }
        return upcomingAppointments
    }
    func getHistoryAppointments(appointments: [VFGAppointmentModelProtocol]) -> [VFGAppointmentModelProtocol] {
        historyAppointments.removeAll()
        for appointment in appointments {
            guard let filterationDate = appointment.appointmentFilterationDate,
                filterationDate < Double(getCurrentTime(date: Date())) else { continue }
            historyAppointments.append(appointment)
        }
        return historyAppointments
    }
    func getCurrentTime(date: Date? = nil) -> Int64 {
        guard let currentDate = date else { return 0 }
        return toMilliSecond(date: currentDate)
    }
    func toMilliSecond(date: Date) -> Int64 {
        return Int64((date.timeIntervalSince1970 * 1000).rounded())
    }
}
