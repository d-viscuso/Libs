//
//  HighlightCardModel.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 28/08/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// HighlightCard  model

public struct HighlightCardModel {
    public var iconName: String?
    public var title: String?
    public var centerViewType: CenterView?
    public var alertStatus: AlertStatus?
    public var bottomText: String?
    public var backgroundImageName: String?
    public var backgroundImageUrl: String?
    public var fontColorType: FontColor?

    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case iconName
        case title
        case centerViewType
        case largeText
        case attributedlargeText
        case attributedSmallText
        case infoText
        case progressText
        case maxProgress
        case currentProgress
        case alertStatus
        case bottomText
        case backgroundImageName
        case fontColorType
    }

    // MARK: - init
    public init(
        iconName: String,
        title: String,
        centerViewType: CenterView,
        alertStatus: AlertStatus? = nil,
        bottomText: String,
        backgroundImageName: String? = nil,
        backgroundImageUrl: String? = nil,
        fontColorType: FontColor = .dark
    ) {
        self.iconName = iconName
        self.title = title
        self.centerViewType = centerViewType
        self.alertStatus = alertStatus
        self.bottomText = bottomText
        self.backgroundImageName = backgroundImageName
        self.backgroundImageUrl = backgroundImageUrl
        self.fontColorType = fontColorType
    }

    // MARK: - CenterViewType
    public enum CenterView: Codable {
        case largeText(text: String?)
        case attributedText(large: String?, small: String?)
        case infoText(text: String?)
        case progress(text: String?, current: Float?, max: Float?)

        var rawValue: String {
            switch self {
            case .largeText: return "largeText"
            case .attributedText: return "attributedText"
            case .infoText: return "infoText"
            case .progress: return "progress"
            }
        }
    }

    // MARK: - AlertStatus
    public enum AlertStatus: String, Codable {
        case green
        case orange
        case red
        case grey
    }

    // MARK: - FontColor
    public enum FontColor: String, Codable {
        case dark
        case light
    }
}

// MARK: - Decodable
extension HighlightCardModel: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        iconName = try? values.decode(String.self, forKey: .iconName)
        title = try? values.decode(String.self, forKey: .title)
        alertStatus = try? values.decode(AlertStatus.self, forKey: .alertStatus)
        bottomText = try values.decode(String.self, forKey: .bottomText)
        backgroundImageName = try values.decode(String.self, forKey: .backgroundImageName)
        fontColorType = try values.decode(FontColor.self, forKey: .fontColorType)
        let type = try? values.decode(String.self, forKey: .centerViewType)
        switch type {
        case CenterView.largeText(text: nil).rawValue:
            let text = try? values.decode(String.self, forKey: .largeText)
            centerViewType = .largeText(text: text)
        case CenterView.attributedText(large: nil, small: nil).rawValue:
            let largeText = try? values.decode(String.self, forKey: .attributedlargeText)
            let smallText = try? values.decode(String.self, forKey: .attributedSmallText)
            centerViewType = .attributedText(large: largeText, small: smallText)
        case CenterView.infoText(text: nil).rawValue:
            let text = try? values.decode(String.self, forKey: .infoText)
            centerViewType = .infoText(text: text)
        case CenterView.progress(text: nil, current: nil, max: nil).rawValue:
            let text = try? values.decode(String.self, forKey: .progressText)
            let current = try? values.decode(Float.self, forKey: .currentProgress)
            let max = try? values.decode(Float.self, forKey: .maxProgress)
            centerViewType = .progress(text: text, current: current, max: max)
        default:
            centerViewType = nil
        }
    }
}

// MARK: - Encodable
extension HighlightCardModel: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(iconName, forKey: .iconName)
        try? container.encode(title, forKey: .title)
        try? container.encode(centerViewType, forKey: .centerViewType)
        try? container.encode(alertStatus, forKey: .alertStatus)
        try? container.encode(bottomText, forKey: .bottomText)
        try? container.encode(backgroundImageName, forKey: .backgroundImageName)
        try? container.encode(fontColorType, forKey: .fontColorType)

        switch centerViewType {
        case let .largeText(text):
            try? container.encode(text, forKey: .largeText)
        case let .attributedText(large, small):
            try? container.encode(large, forKey: .attributedlargeText)
            try container.encode(small, forKey: .attributedSmallText)
        case let .infoText(text):
            try? container.encode(text, forKey: .infoText)
        case let .progress(text, current, max):
            try? container.encode(text, forKey: .progressText)
            try? container.encode(current, forKey: .currentProgress)
            try? container.encode(max, forKey: .maxProgress)
        case .none:
            break
        }
    }
}
