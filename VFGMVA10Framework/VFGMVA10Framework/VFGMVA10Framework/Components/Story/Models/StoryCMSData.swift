//
//  StoryCMSData.swift
//  VFGMVA10Framework
//
//  Created by Abdullah Soylemez on 12.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Story CMS data model
public struct StoryCMSData: Codable {
    /// Story CMS id
    let id: String?
    /// Story CMS button title
    let btnTitle: String?
    /// Story CMS text color name
    let textColor: String?
    /// Story CMS button color name
    let btnColor: String?
    /// Story CMS button title color name
    let btnTextColor: String?
    /// Story CMS button title
    let secondBtnTitle: String?
    /// Story CMS button color name
    let secondBtnColor: String?
    /// Story CMS button title color name
    let secondBtnTextColor: String?
}
