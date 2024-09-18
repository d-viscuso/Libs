//
//  AddOnsCVMModel.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 8/25/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//
import Foundation

public struct AddOnsCVMModel: Codable {
    public var title: String?
    public var identifier: String?
    public var subTitle: String?
    public var imageName: String?
    public var type: String?
    public var addOnCardName: String?
    public var addOnButtonTitle: String?
    public var addOnDescription: String?
    public var addOnDetails: AddOnPlanDetails?
    public var addonType: String? {
        return type
    }

    init(
        title: String,
        subTitle: String,
        imageName: String,
        addOnCardName: String,
        addOnButtonTitle: String,
        addOnDescription: String,
        addonType: String,
        addOnDetails: AddOnPlanDetails,
        identifier: String
    ) { self.title = title
        self.subTitle = subTitle
        self.imageName = imageName
        self.addOnCardName = addOnCardName
        self.addOnButtonTitle = addOnButtonTitle
        self.addOnDescription = addOnDescription
        self.type = addonType
        self.addOnDetails = addOnDetails
        self.identifier = identifier
    }

    enum CodingKeys: String, CodingKey {
        case title = "addOnTitle"
        case subTitle = "addOnSubTitle"
        case imageName = "addOnImageName"
        case type = "addOnType"
        case addOnDetails = "addOnPlanDetails"
        case identifier = "addOnId"
        case addOnCardName = "addOnCardName"
        case addOnButtonTitle = "addOnButtonTitle"
        case addOnDescription = "addOnDescription"
    }
}

extension AddOnsCVMModel: AddOnsCVMModelProtocol {}
