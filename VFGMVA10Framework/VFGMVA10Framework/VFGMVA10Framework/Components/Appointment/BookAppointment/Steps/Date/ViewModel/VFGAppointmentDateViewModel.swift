//
//  VFGAppointmentDateViewModel.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/9/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGAppointmentDateViewModel {
    let dataProvider: VFGAppointmentDateDataProviderProtocol
    private var availableSlots: [VFGAppointmentDateModel.AvailableSlot] = []
    private let networkClient = VFGNetworkClient(baseURL: "")
    var contentState: VFGContentState = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var updateLoadingStatus: (() -> Void)?

    init(dataProvider: VFGAppointmentDateDataProviderProtocol = VFGAppointmentDateDataProvider(baseURL: "")) {
        self.dataProvider = dataProvider
    }

    func fetchAvailableAppointments() {
        contentState = .loading
        dataProvider.fetchAvailableTimeSlots { [weak self] availableSlots, _ in
            guard
                let self = self,
                let availableSlots = availableSlots else {
                return
            }

            self.availableSlots = availableSlots
            self.contentState = .populated
        }
    }

    func numberOfTimeSlots(on day: Int = 0) -> Int {
        availableSlots[day].timeSlots.count
    }

    func timeSlotAsString(on day: Int = 0, at index: Int) -> String {
        return "\(availableSlots[day].timeSlots[index].time.from) - \(availableSlots[day].timeSlots[index].time.to)"
    }

    func timeSlot(on day: Int = 0, at index: Int) -> VFGAppointmentDateModel.TimeSlot {
        return availableSlots[day].timeSlots[index]
    }

    private func getPath(fileName: String, bundle: Bundle) -> String {
        return bundle.url(
            forResource: fileName,
            withExtension: "json")?.absoluteString ?? ""
    }
}
