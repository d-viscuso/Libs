//
//  VFGYourAppointmentsManager.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 02/02/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

/// Your appointments manager.
public class VFGYourAppointmentsManager {
    /// Shared is a singleton object from *VFGYourAppointmentsManager* that holds booking appointment initialization method.
    public static let shared = VFGYourAppointmentsManager()
    /// dataProvider is the *VFGYourAppointmentsDataProviderProtocol* object that refers to appointments data API call.
    public weak var dataProvider: VFGYourAppointmentsDataProviderProtocol?
    /// serviceProvider is the *VFGAppointmentServiceDataProviderProtocol* object that refers to provided services data API call.
    public weak var serviceProvider: VFGAppointmentServiceDataProviderProtocol?
    /// storeProvider is the *VFGAppointmentStoreDataProviderProtocol* object that refers to available stores data API call.
    public weak var storeProvider: VFGAppointmentStoreDataProviderProtocol?
    /// dateTimeProvider is the *VFGAppointmentDateDataProviderProtocol* object that refers to available time slots data API call.
    public weak var dateTimeProvider: VFGAppointmentDateDataProviderProtocol?
    /// summaryProvider is the *VFGAppointmentSummaryDataProviderProtocol* object that refers to submit appointment data API call.
    public weak var summaryProvider: VFGAppointmentSummaryDataProviderProtocol?
    /// appointmentsViewModel is the object that is used to initialize the appointment model.
    public weak var appointmentsViewModel: VFGYourAppointmentsViewModel?

    // Demo: This an appointment for demo purposes
    var demoAppointments: [VFGAppointmentModelProtocol] = []

    private init() {}

    /// method that provides the navigation controller for the booking appointments module, which you should present in your app.
    public func navigationController() -> UINavigationController {
        guard let yourAppointmentVC = VFGYourAppointmentsViewController.instance(
            delegate: nil,
            dataProvider: VFGYourAppointmentsManager.shared.dataProvider) else {
            return UINavigationController()
        }
        return MVA10NavigationController(rootViewController: yourAppointmentVC)
    }
}
