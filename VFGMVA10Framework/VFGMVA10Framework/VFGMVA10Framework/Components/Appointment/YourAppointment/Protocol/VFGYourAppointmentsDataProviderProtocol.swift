//
//  VFGYourAppointmentsDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 02/02/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
import UIKit

/// Your appointment data provider protocol.
public protocol VFGYourAppointmentsDataProviderProtocol: AnyObject {
    /// your appointments custom view.
    var customView: UIView? { get }

    /// Method to fetch your current appointments.
    /// - Parameters:
    ///     - completion: *([VFGAppointmentDateModel.AvailableSlot]?, Error?)* completion of available time slots in each day for current week for the chosen store  in case of success & error in case of failure.
    func fetchAppointments(completion: (([VFGAppointmentModelProtocol]?, Error?) -> Void)?)
}

public extension VFGYourAppointmentsDataProviderProtocol {
    var customView: UIView? { nil }
}
