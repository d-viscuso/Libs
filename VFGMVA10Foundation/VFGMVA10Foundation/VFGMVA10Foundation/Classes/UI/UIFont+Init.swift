//
//  UIFont+Vodafone.swift
//  VFGMVA10Foundation
//
//  Created by Tomasz Czyżak on 16/05/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

/// A `UIFont` extension which allows automation of the process to select custom font files
extension UIFont {
    enum VFGFontName: String {
        case regular = "VodafoneRg-Regular"
        case lite = "VodafoneLt-Regular"
        case bold = "VodafoneRg-Bold"
        case extraBold = "VodafoneExB-Regular"

        var fileName: String {
            switch self {
            case .regular:
                return VFGFontFileName.regular.rawValue
            case .lite:
                return VFGFontFileName.lite.rawValue
            case .bold:
                return VFGFontFileName.bold.rawValue
            case .extraBold:
                return VFGFontFileName.extraBold.rawValue
            }
        }
    }

    private enum VFGFontFileName: String {
        case regular = "vodafone-regular"
        case lite = "vodafone-lite"
        case bold = "vodafone-bold"
        case extraBold = "VodafoneExB"
    }
    /// Apply **vodafone-regular** custom font
    /// - Parameter size: Font size in float
    public class func vodafoneRegular(_ size: CGFloat, shouldScale: Bool = true) -> UIFont {
        return vodafoneFont(size: size, type: .regular, shouldScale: shouldScale)
    }

    /// Apply **vodafone-lite** custom font
    /// - Parameter size: Font size in float
    public class func vodafoneLite(_ size: CGFloat, shouldScale: Bool = true) -> UIFont {
        return vodafoneFont(size: size, type: .lite, shouldScale: shouldScale)
    }

    /// Apply **vodafone-bold** custom font
    /// - Parameter size: Font size in float
    public class func vodafoneBold(_ size: CGFloat, shouldScale: Bool = true) -> UIFont {
        return vodafoneFont(size: size, type: .bold, shouldScale: shouldScale)
    }

    /// Apply **vodafone-extraBold** custom font
    /// - Parameter size: Font size in float
    public class func vodafoneExtraBold(_ size: CGFloat, shouldScale: Bool = true) -> UIFont {
        return vodafoneFont(size: size, type: .extraBold, shouldScale: shouldScale)
    }

    class func vodafoneFont(size: CGFloat, type: VFGFontName, shouldScale: Bool) -> UIFont {
        guard let font = UIFont(name: type.rawValue, size: size) else {
            registerFont(name: type.fileName)
            if shouldScale {
                return UIFont(name: type.rawValue, size: size)?.scaledFont(for: size, isBold: type == .bold) ??
                UIFont.systemFont(ofSize: size)
            } else {
                return UIFont(name: type.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
            }
        }
        if shouldScale {
            return font.scaledFont(for: size, isBold: type == .bold)
        } else {
            return font
        }
    }

    class func font(of type: FontType, with size: CGFloat, shouldScale: Bool = true) -> UIFont {
        switch type {
        case .regular:
            return vodafoneRegular(size, shouldScale: shouldScale)
        case .lite:
            return vodafoneLite(size, shouldScale: shouldScale)
        case .bold:
            return vodafoneBold(size, shouldScale: shouldScale)
        case .extraBold:
            return vodafoneExtraBold(size, shouldScale: shouldScale)
        }
    }

    private static func registerFont(name: String) {
        guard let pathForResourceString = Bundle.foundation.path(forResource: name, ofType: "ttf"),
            let fontData = NSData(contentsOfFile: pathForResourceString),
            let dataProvider = CGDataProvider(data: fontData),
            let fontRef = CGFont(dataProvider) else {
                return
        }
        var error: UnsafeMutablePointer<Unmanaged<CFError>?>?
        if CTFontManagerRegisterGraphicsFont(fontRef, error) == false {
            return
        }
        error = nil
    }

    func scaledFont(for size: CGFloat, isBold: Bool) -> UIFont {
        UIFontMetrics(forTextStyle: style(for: size, isBold: isBold)).scaledFont(for: self)
    }

    /*
    Numbers applied based on Apple's Human Interface Guidelines.
    https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/#dynamic-type-sizes
    */

    func style(for size: CGFloat, isBold: Bool) -> UIFont.TextStyle {
        switch size {
        case ...11: return .caption2
        case ...12: return .caption1
        case ...13: return .footnote
        case ...15: return .subheadline
        case ...16: return .callout
        case ...17: return isBold ? .headline : .body
        case ...20: return .title3
        case ...22, ...28:
            return complementaryStyle(for: size)
        case ...34: return .largeTitle
        default: return .body
        }
    }

    func complementaryStyle(for size: CGFloat) -> UIFont.TextStyle {
        if size == 22 {
            return .title2
        } else {
            return .title1
        }
    }
}
