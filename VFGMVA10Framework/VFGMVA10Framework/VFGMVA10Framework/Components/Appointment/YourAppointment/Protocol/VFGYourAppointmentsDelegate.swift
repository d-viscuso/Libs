//
//  VFGYourAppointmentsDelegate.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 09/02/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

public typealias AppointmentStoreLocationActionHandler = () -> Void
public typealias AppointmentCancelActionHandler = () -> Void
public typealias AppointmentChangeBookActionHandler = () -> Void

/// Your appointments delegate.
public protocol VFGYourAppointmentsDelegate: AnyObject {
    /// Action to be done when store location button is pressed in appointment cell
    /// - Parameter index: Index of the required upcoming appointment.
    /// - Returns: action to be done when getStoreLocation is tapped. If the returned value is nil, the default action will take place.
    func appointmentStoreLocationActionHandler(at index: Int) -> AppointmentStoreLocationActionHandler?
    /// Action to be done when cancel button is pressed in appointment cell
    /// - Parameter index: Index of the required upcoming appointment.
    /// - Returns: action to be done when cancel is tapped. If the returned value is nil, the default action will take place.
    func appointmentCancelActionHandler(at index: Int) -> AppointmentStoreLocationActionHandler?
    /// Action to be done when change book button is pressed in appointment cell
    /// - Parameter index: Index of the required upcoming appointment.
    /// - Returns: action to be done when changeBookAction is tapped. If the returned value is nil, the default action will take place.
    func appointmentChangeBookActionHandler(at index: Int) -> AppointmentStoreLocationActionHandler?
    /// Action will be preformed when you press on book an appointment in your *VFGYourAppointmentsViewController*.
    /// In case you provided your delegate to the controller, you can start your own booking an appointment journey.
    /// If no delegate was provided by you, the default booking an appointment journey will start.
    func bookAppointmentButtonDidPress()
}

public protocol VFGYourAppointmentsHistoryDelegate: AnyObject {
    func reviewAppointmentDidPressed(appointmentId: String)
    func requestAppointmentAgainDidPressed()
}

public extension VFGYourAppointmentsDelegate {
    func appointmentStoreLocationActionHandler(at index: Int) -> AppointmentStoreLocationActionHandler? {
        nil
    }

    func appointmentCancelActionHandler(at index: Int) -> AppointmentStoreLocationActionHandler? {
        nil
    }

    func appointmentChangeBookActionHandler(at index: Int) -> AppointmentStoreLocationActionHandler? {
        nil
    }
    }
