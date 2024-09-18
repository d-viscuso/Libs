//
//  AddPaymentCardCustomView.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 7/5/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

/// Add payment card custom view.
open class AddPaymentCardCustomView: UIView {
    /// Quick action payment delegate.
    weak var delegate: VFGQuickActionStateInternalProtocol?
    /// Payment value.
    public var amountValue: Double?
    /// A method to be called after adding new card.
    /// - Parameters:
    ///    - withGift: Determine whether payment has gift or not.
    ///    - completion: A closure to perform actions after adding new card.
    public func addNewCardFinished(withGift: Bool, completion: (() -> Void)?) {
        delegate?.addNewCardDidFinish(withGift: withGift, completion: completion)
    }
}
