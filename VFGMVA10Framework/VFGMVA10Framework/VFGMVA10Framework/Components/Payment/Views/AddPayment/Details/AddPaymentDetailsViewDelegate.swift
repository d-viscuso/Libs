//
//  AddPaymentDetailsViewDelegate.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 10/6/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

protocol AddPaymentDetailsViewDelegate: NSObjectProtocol {
    func detailsDidChange()
    func cardNumberIsEmpty()
}
