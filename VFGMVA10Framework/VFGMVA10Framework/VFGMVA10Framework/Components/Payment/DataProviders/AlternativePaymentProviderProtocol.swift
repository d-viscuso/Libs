//
//  AlternativePaymentProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Zaki on 25/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Alternative payment data provider protocol.
public protocol AlternativePaymentProviderProtocol {
    /// First section title.
    var firstSectionTitle: String { get }
    /// Fetch alternative payment methods.
    /// - Parameters:
    ///    - completion: *(([AlternativePaymentMethod]?) -> Void)*.
    func paymentsMethods(completion: (([AlternativePaymentMethod]?) -> Void))
    /// Action when selecting different payment method.
    /// - Parameters:
    ///    - id: Payment card Id.
    ///    - amount: Payment amount.
    ///    - paymentIdentifier: Payment indentifier.
    ///    - completion: *(Error?) -> Void*.
    func didSelectSection(for id: String?, with amount: Double, paymentIdentifier: String?, completion: @escaping (Error?) -> Void)
}

/// Alternative payment method.
public struct AlternativePaymentMethod {
    /// Id.
    var id: String?
    /// Title.
    var title: String?
    /// View.
    var view: UIView?

    public init(id: String, title: String, view: UIView) {
        self.id = id
        self.title = title
        self.view = view
    }
}
