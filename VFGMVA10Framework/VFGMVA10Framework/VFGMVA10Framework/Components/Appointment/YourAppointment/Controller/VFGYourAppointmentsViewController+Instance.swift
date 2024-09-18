//
//  VFGYourAppointmentsViewController+Instance.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 10/02/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGYourAppointmentsViewController {
    public class func instance(
        delegate: VFGYourAppointmentsDelegate?,
        dataProvider: VFGYourAppointmentsDataProviderProtocol?
    ) -> VFGYourAppointmentsViewController? {
        let viewController = VFGYourAppointmentsViewController.instance(
            from: "VFGYourAppointments",
            with: "VFGYourAppointmentsViewController",
            bundle: .mva10Framework) as? VFGYourAppointmentsViewController
        viewController?.configure(delegate: delegate, dataProvider: dataProvider)
        return viewController
    }
}
