//
//  VFGYourAppointmentsViewModelProtocol.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 02/02/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Your appointments error model.
public typealias VFGYourAppointmentsErrorModel = (
    title: String,
    description: String,
    tryAgainLabel: String,
    tryAgainHandler: () -> Void
)
/// Your appointments view model protocol.
public protocol VFGYourAppointmentsViewModelProtocol: AnyObject {
    /// Responsible for fetching available appointments.
    func fetchAppointments()
    /// Returns number of upcoming appointments.
    func numberOfUpcomingAppointments() -> Int
    /// Get the number of history appointments.
    /// - Returns: *Int* with the number of history appointments.
    func numberOfHistoryAppointments() -> Int
    /// Returns appointment model at a specified index.
    /// - Parameters:
    ///    - index: Index of the required appointment.
    func appointment(at index: Int) -> VFGAppointmentModelProtocol
    /// Get History Appointment
    /// - Parameter index: Index of the required history appointment.
    /// - Returns: *VFGAppointmentModelProtocol* model of history appointment
    func historyAppointment(at index: Int) -> VFGAppointmentModelProtocol
    /// Completion that will be called when the view starts loading.
    var updateLoadingStatus: (() -> Void)? { get set }
    /// View's content state if loading, empty, etc.
    var contentState: VFGContentState { get }
    /// Custom view.
    var customView: UIView? { get }
    /// Data provider.
    var dataProvider: VFGYourAppointmentsDataProviderProtocol? { get set }
    /// Error ui data model
    var errorModel: VFGYourAppointmentsErrorModel? { get }
}
