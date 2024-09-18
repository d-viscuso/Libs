//
//  VFGInitialTopUpProtocol.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 1/19/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

protocol VFGInitialTopUpProtocol: AnyObject {
    func confirmTopUp(selectedAmount: Double, paymentCard: PaymentModelProtocol?)
    func didChangedPickerValue(selectedAmount: Double, topupButton: VFGButton)
    func topupPresented()
    func tryAgain()
}
