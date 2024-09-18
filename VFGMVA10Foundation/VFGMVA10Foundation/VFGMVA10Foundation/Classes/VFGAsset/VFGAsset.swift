//
//  VFGFoundationAsset.swift
//  VFGMVA10Foundation
//
//  Created by Adel Aref on 04/02/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import Foundation
import UIKit


/**
- VFGFoundationAsset is an enum that represent all assets in VFGFoundation.
- each asset type like Image and font and so on will added latter  as an enum inside VFGFoundationAsset
*/
public enum VFGFoundationAsset {
    public enum Image {
        public static var bannerBG: UIImage? {
            return VFGImage(named: "bannerBG")
        }

        public static var closeIcon: UIImage? {
            return VFGImage(named: "closeIcon")
        }

        public static var greyBgVideo: UIImage? {
            return VFGImage(named: "greyBgVideo")
        }

        public static var icTobby: UIImage? {
            return VFGImage(named: "ic_tobby")
        }

        public static var icAutoBill: UIImage? {
            return VFGImage(named: "icAutoBill")
        }

        public static var icChevronDown: UIImage? {
            return VFGImage(named: "icChevronDown")
        }

        public static var icInfoCircleHi: UIImage? {
            return VFGImage(named: "icInfoCircleHi")
        }

        public static var icLocateMeWhite: UIImage? {
            return VFGImage(named: "icLocateMeWhite")
        }

        public static var icPaymentRed: UIImage? {
            return VFGImage(named: "icPaymentRed")
        }

        public static var icWhiteTick: UIImage? {
            return VFGImage(named: "icWhiteTick")
        }

        public static var redPin: UIImage? {
            return VFGImage(named: "red_pin")
        }

        public static var redBG: UIImage? {
            return VFGImage(named: "redBG")
        }

        public static var greyBG: UIImage? {
            return VFGImage(named: "greyBG")
        }

        public static var star: UIImage? {
            return VFGImage(named: "star")
        }

        public static var icWarningHiLightTheme: UIImage? {
            return VFGImage(named: "icWarningHiLightTheme")
        }

        public static var icRefreshRed: UIImage? {
            return VFGImage(named: "icRefreshRed")
        }

        public static var icClose: UIImage? {
            return VFGImage(named: "icClose")
        }

        public static var icArrowLeft: UIImage? {
            return VFGImage(named: "icArrowLeft")
        }

        public static var greenCircle: UIImage? {
            return VFGImage(named: "greenCircle")
        }

        public static var redCircle: UIImage? {
            return VFGImage(named: "redCircle")
        }

        public static var toggleSmallActive: UIImage? {
            return VFGImage(named: "toggleSmallActive")
        }

        public static var toggleSmallInactive: UIImage? {
            return VFGImage(named: "toggleSmallInactive")
        }

        public static var icCloseWhite: UIImage? {
            return VFGImage(named: "icCloseWhite")
        }

        public static var icChevronLeft: UIImage? {
            return VFGImage(named: "icChevronLeft")
        }

        public static var icChevronRight: UIImage? {
            return VFGImage(named: "icChevronRight")
        }

        public static var redDot: UIImage? {
            return VFGImage(named: "red_dot")
        }

        public static var definitionRadioButtonOn: UIImage? {
            return VFGImage(named: "definition_radio_button_on")
        }

        public static var definitionRadioButtonOff: UIImage? {
            return VFGImage(named: "definition_radio_button_off")
        }

        public static var icXClose: UIImage? {
            return VFGImage(named: "ic_close")
        }

        public static var icTooltipDot: UIImage? {
            return VFGImage(named: "ic_tooltip_dot")
        }
    }
}
