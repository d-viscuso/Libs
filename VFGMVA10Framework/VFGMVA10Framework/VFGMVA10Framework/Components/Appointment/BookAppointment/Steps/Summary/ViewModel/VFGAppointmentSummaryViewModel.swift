//
//  VFGAppointmentSummaryViewModel.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 23/02/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

class VFGAppointmentSummaryViewModel {
    private let dataProvider: VFGAppointmentSummaryDataProviderProtocol
    var contentState: VFGContentState = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var updateLoadingStatus: (() -> Void)?

    init(dataProvider: VFGAppointmentSummaryDataProviderProtocol = VFGAppointmentSummaryDataProvider()) {
        self.dataProvider = dataProvider
    }

    func saveAppointment(with appointment: VFGAppointmentModelProtocol, onSuccess: @escaping () -> Void) {
        contentState = .loading
        let onFail = {
            self.contentState = .error
        }
        dataProvider.saveAppointment(with: appointment, onSuccess: onSuccess, onFail: onFail)
    }
}
