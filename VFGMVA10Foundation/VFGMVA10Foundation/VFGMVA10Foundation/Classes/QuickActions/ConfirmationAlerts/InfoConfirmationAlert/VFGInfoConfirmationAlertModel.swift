//
//  VFGInfoConfirmationAlertModel.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 6/4/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

public struct VFGInfoConfirmationAlertModel {
    public let infoIcon: UIImage?
    public let infoIconDescription: String?
    public let infoIconSize: CGSize
    public let infoQuestion: String
    public let infoAnswer: String?
    public let confirmButtonTitle: String

    public init(
        infoIcon: UIImage? = nil,
        infoIconDescription: String? = nil,
        infoIconSize: CGSize = .zero,
        infoQuestion: String,
        infoAnswer: String? = nil,
        confirmButtonTitle: String
    ) {
        self.infoIcon = infoIcon
        self.infoIconDescription = infoIconDescription
        self.infoIconSize = infoIconSize
        self.infoQuestion = infoQuestion
        self.infoAnswer = infoAnswer
        self.confirmButtonTitle = confirmButtonTitle
    }
}
