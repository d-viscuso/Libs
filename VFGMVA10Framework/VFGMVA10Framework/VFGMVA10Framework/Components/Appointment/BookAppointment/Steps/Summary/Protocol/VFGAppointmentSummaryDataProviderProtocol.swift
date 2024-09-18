//
//  VFGAppointmentSummaryDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 23/02/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

public typealias OnSaveSuccess = (() -> Void)
public typealias OnSaveFailed = (() -> Void)

/// Appointment summary data provider protocol.
public protocol VFGAppointmentSummaryDataProviderProtocol: AnyObject {
    /// Method to save the appointment.
    /// - Parameters:
    ///     - appointment:  Appointment model.
    ///     - onSuccess: *OnSaveSuccess* is atypealias for *(() -> Void)*
    ///     - onFail: *OnSaveFailed* is atypealias for *(() -> Void)*
    func saveAppointment(
        with appointment: VFGAppointmentModelProtocol?,
        onSuccess: @escaping  OnSaveSuccess,
        onFail: @escaping OnSaveFailed
    )
}
