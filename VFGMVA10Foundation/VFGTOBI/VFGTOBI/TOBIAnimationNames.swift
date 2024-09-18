//
//  TOBIAnimationNames.swift
//  TOBI
//
//  Created by Ehab Amer on 10/1/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

/**
VFGTOBIAnimationNames

There are a total number of 21 animations that TOBi can render. Use the enum VFGTOBIAnimationNames to select the desired one.
*/
public typealias VFGTOBIAnimationNames = VFGTOBIAnimation

/// There are 4 different sets of animations TOBi can use, these are (Default - Birthday - Pride - Santa).
public enum VFGTOBISet: String {
    case `default` = "TOBi_Default"
    case birthday = "TOBi_Birthday"
    case pride = "TOBi_Pride"
    case santa = "TOBi_Santa"
}

public enum VFGTOBIAnimation {
    case angry
    case bigLaugh
    case birthday
    case blush
    case grumpy
    case idle1
    case idle2
    case idle3
    case idle4
    case idle1Long
    case idle2Long
    case idle3Long
    case idle4Long
    case indifferent
    case laughSweat
    case laughTears
    case laugh
    case love
    case noShake
    case pride
    case sad
    case smirk
    case smug
    case surpriseLaugh
    case surprise
    case whisle
    case wink
    case yesNod

    var marker: (start: String, end: String) {
        switch self {
        case .angry:
            return (start: "Angry_4s_240f", end: "Angry_End")
        case .bigLaugh:
            return (start: "BigLaugh_2.5s_150f", end: "BigLaugh_End")
        case .birthday:
            return (start: "Birthday_4s_240f", end: "Birthday_End")
        case .blush:
            return (start: "Blush_4s_240f", end: "Blush_End")
        case .grumpy:
            return (start: "Grumpy_4s_240f", end: "Grumpy_End")
        case .idle1:
            return (start: "IdleShort1_2s_120f", end: "IdleShort1_End")
        case .idle2:
            return (start: "IdleShort2_2s_120f", end: "IdleShort2_End")
        case .idle3:
            return (start: "IdleShort3_2s_120f", end: "IdleShort3_End")
        case .idle4:
            return (start: "IdleShort4_2s_120f", end: "IdleShort4_End")
        case .idle1Long:
            return (start: "IdleLong1_4s_240f", end: "IdleLong1_End")
        case .idle2Long:
            return (start: "IdleLong2_4s_240f", end: "IdleLong2_End")
        case .idle3Long:
            return (start: "IdleLong3_4s_240f", end: "IdleLong3_End")
        case .idle4Long:
            return (start: "IdleLong4_4s_240f", end: "IdleLong4_End")
        case .indifferent:
            return (start: "Indifferent_4s_240f", end: "Indifferent_End")
        case .laughSweat:
            return (start: "LaughSweat_2.5_150f", end: "LaughSweat_End")
        case .laughTears:
            return (start: "LaughTears_2.5s_150f", end: "LaughTears_End")
        case .laugh:
            return (start: "Laugh_2.5s_150f", end: "Laugh_End")
        case .noShake:
            return (start: "No_2s_120f", end: "No_End")
        case .love:
            return (start: "Love_4s_240f", end: "Love_End")
        case .sad:
            return (start: "Sad_4s_240f", end: "Sad_End")
        case .smirk:
            return (start: "Smirk_4s_240f", end: "Smirk_End")
        case .smug:
            return (start: "Smug_4s_240f", end: "Smug_End")
        case .surpriseLaugh:
            return (start: "Surprise&Laugh_2.5s_150f", end: "Surprise&Laugh_End")
        case .surprise:
            return (start: "Surprise_2s_120f", end: "Surprise_End")
        case .whisle:
            return (start: "Whistle_4s_240f", end: "Whistle_End")
        case .wink:
            return (start: "Wink_2s_120f", end: "Wink_End")
        case .yesNod:
            return (start: "Yes_2s_120f", end: "Yes_End")

        case .pride:
            return (start: "Pride_4s_240f", end: "Pride_End")
        }
    }
}
