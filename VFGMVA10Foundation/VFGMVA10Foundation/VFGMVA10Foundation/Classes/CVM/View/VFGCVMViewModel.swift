//
//  VFGCVMViewModel.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed AbdElnabi on 30/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// A model that can be injected to VFGCVM to setup it's views.
public struct VFGCVMViewModel {
    var title: String
    var description: String
    var buttonTitle: String
    var titleWhenDisabled: String

    weak var delegate: VFGCVMProtocol?

    /// - Parameters:
    ///   - title: The title that appears on the top of CVM when it's status is active.
    ///   - titleWhenDisabled: The title that appears on the top of CVM when it's status is disable.
    ///   - description: the description for CVM.
    ///   - buttonTitle: The text for the button.
    ///   - delegate: The delegate for CVM actions

    public init(
        title: String,
        titleWhenDisabled: String = "",
        description: String,
        buttonTitle: String,
        delegate: VFGCVMProtocol? = nil
    ) {
        self.title = title
        self.titleWhenDisabled = titleWhenDisabled
        self.description = description
        self.buttonTitle = buttonTitle
        self.delegate = delegate
    }
}
