//
//  VFGAppointmentDateModel.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/9/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// Appointment date model.
public struct VFGAppointmentDateModel: Codable {
    /// List of available slots.
    public var availableSlots: [VFGAppointmentDateModel.AvailableSlot]

    public struct AvailableSlot: Codable {
        public var timeSlots: [VFGAppointmentDateModel.TimeSlot]

        public init(timeSlots: [VFGAppointmentDateModel.TimeSlot]) {
            self.timeSlots = timeSlots
        }
    }

    public struct TimeSlot: Codable {
        public typealias Time = (from: String, to: String)

        public var time: Time

        var asString: String {
            "\(time.from) - \(time.to)"
        }

        enum CodingKeys: String, CodingKey {
            case fromTime = "from"
            case toTime = "to"
        }

        public init(time: VFGAppointmentDateModel.TimeSlot.Time) {
            self.time = time
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            do {
                time = Time(
                    from: try container.decode(String.self, forKey: .fromTime),
                    to: try container.decode(String.self, forKey: .toTime)
                )
            } catch {
                time = Time(from: "0", to: "0")
            }
        }

        public func encode(to encoder: Encoder) throws {}
    }
}
