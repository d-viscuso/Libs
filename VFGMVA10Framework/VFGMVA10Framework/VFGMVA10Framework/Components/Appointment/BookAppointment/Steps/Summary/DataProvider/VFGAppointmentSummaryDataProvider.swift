//
//  VFGAppointmentSummaryDataProvider.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 23/02/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public class VFGAppointmentSummaryDataProvider: VFGAppointmentSummaryDataProviderProtocol {
    public init() {}

    public func saveAppointment(
        with appointment: VFGAppointmentModelProtocol?,
        onSuccess: @escaping OnSaveSuccess,
        onFail: @escaping OnSaveFailed
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            onSuccess()
        }
    }
}
