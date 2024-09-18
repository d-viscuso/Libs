//
//  VFGMyProductsProtectionModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 18/02/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// A struct model which is used to handle the response from fetching my products protection details
public struct VFGMyProductsProtectionModel: Codable {
    public var title: String?
    public var subTitle: String?
    let cards: [Card]?

    /// A struct model that represents a card which contains a title and a group of user devices
    public struct Card: Codable {
        let id: String?
        let title: String?
        let devices: [Device]?

        /// A struct model which represents the user device 
        public struct Device: Codable {
            let id: String?
            let title: String?
            let iconKey: String?
            let isProtected: Bool?
            let actionId: String?
        }
    }
}
