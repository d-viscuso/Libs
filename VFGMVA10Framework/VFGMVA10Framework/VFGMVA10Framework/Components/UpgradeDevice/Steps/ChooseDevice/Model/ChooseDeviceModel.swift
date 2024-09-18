//
//  ChooseDeviceModel.swift
//  VFGMVA10Framework
//
//  Created by Moamen Abd Elgawad on 18/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

public struct ChooseDeviceModel: Codable {
    var devices: [Device]?

    public init() {}

    public struct Device: Codable {
        var id, brand, title: String?
        var imageUrl: String?
        var price: Price?
        var color: Color?
        var capacity: Capacity?
        var specifications: Specifications?
        var isRecommended: Bool?

        struct Price: Codable {
            var upfrontPrice, recurringPrice, totalPrice: Int?
            var recurrencePeriod: String?
            var contractPeriod: Int?
            var currency: String?
        }

        struct Color: Codable {
            var color: UIColor?
            var colorName: String?
            var colorHex: String?

            enum CodingKeys: String, CodingKey {
                case colorHex
                case colorName
            }

            public init(
                color: UIColor? = nil,
                colorName: String? = nil,
                colorHex: String? = nil
            ) {
                self.color = color
                self.colorName = colorName
                self.colorHex = colorHex
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                do {
                    color = UIColor(hexString: try container.decode(String.self, forKey: .colorHex))
                    colorName = try container.decode(String.self, forKey: .colorName)
                    colorHex = try container.decode(String.self, forKey: .colorHex)
                } catch {
                }
            }

            public func encode(to encoder: Encoder) throws {}
        }

        struct Capacity: Codable {
            var size: Int?
            var sizeUnit: String?
        }

        public struct Specifications: Codable {
            var quickSpecs: [QuickSpec]?
            var boxDetails: [String]?
            var fullSpecs: [FullSpec]?

            struct QuickSpec: Codable {
                var title, subtitle, details: String?
            }

            public struct FullSpec: Codable {
                var title: String?
                var items: [String]?
            }
        }
    }
}

extension ChooseDeviceModel.Device: Equatable {
    public static func == (lhs: ChooseDeviceModel.Device, rhs: ChooseDeviceModel.Device) -> Bool {
        return lhs.id == rhs.id &&
            lhs.brand == rhs.brand &&
            lhs.title == rhs.title &&
            lhs.imageUrl == rhs.imageUrl &&
            lhs.isRecommended == rhs.isRecommended &&
            lhs.color == rhs.color &&
            lhs.capacity == rhs.capacity
    }
}

extension ChooseDeviceModel.Device.Color: Equatable, Hashable { }

extension ChooseDeviceModel.Device.Capacity: Equatable, Hashable { }

// For sorting by lowest capacity
extension ChooseDeviceModel.Device.Capacity: Comparable {
    static func < (lhs: ChooseDeviceModel.Device.Capacity, rhs: ChooseDeviceModel.Device.Capacity) -> Bool {
        return lhs.size ?? 0 < rhs.size ?? 0
    }
}
