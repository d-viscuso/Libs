//
//  VFGLabel.swift
//  VFGMVA10Foundation
//
//  Created by Hussien Gamal Mohammed on 7/9/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

/// Designable UILabel that allows customization of font, size and type. the default font for VFGLabel is VodafoneRegular.
@IBDesignable
public class VFGLabel: UILabel {
/* be aware that extra bold not working */
    /// 0 - lite
    /// 1 - regular
    /// 2 - bold
    /// 3 - extra Bold
    @IBInspectable var fontWeight: Int = 0 {
        willSet(newValue) {
            font = UIFont.font(of: FontType(rawValue: newValue) ?? FontType.lite, with: fontSize)
        }
    }

    @IBInspectable var shouldScaleFont: Bool = true {
        willSet(newValue) {
            font = UIFont.font(
                of: FontType(rawValue: fontWeight) ?? FontType.lite,
                with: fontSize,
                shouldScale: newValue)
        }
    }

    @IBInspectable var fontSize: CGFloat = 22 {
        willSet(newValue) {
            font = UIFont.font(of: FontType(rawValue: fontWeight) ?? FontType.lite, with: newValue)
        }
    }

    @IBInspectable var textColorName: String = "" {
        willSet(newValue) {
            textColor = UIColor(named: newValue, in: .foundation, compatibleWith: nil)
        }
    }

	@IBInspectable var isCopyable: Bool = false {
		didSet {
			if isCopyable {
				addLongPressMenuItems()
			} else {
				removeLongPressMenuItems()
			}
		}
	}

    /// 5 sizes
    /// 1- 18px
    /// 2- 20px
    /// 3- 24px
    /// 4- 28px
    /// 5- 32px
    @IBInspectable var headingStyle: Int = 1 {
        willSet(newValue) {
            fontSize = HeadingSizes(size: newValue)?.rawValue ?? HeadingSizes.sizeX2.rawValue
            font = UIFont
                .font(
                    of: FontType(rawValue: fontWeight) ?? FontType.regular,
                    with: fontSize)
        }
    }

    /// 2 sizes
    /// 1- 14px
    /// 2- 16px
    @IBInspectable var paragraphStyle: Int = 1 {
        willSet(newValue) {
            fontSize = ParagraphSizes(size: newValue)?.rawValue ?? ParagraphSizes.sizeX2.rawValue
            font = UIFont
                .font(
                    of: FontType(rawValue: fontWeight) ?? FontType.regular,
                    with: fontSize)
        }
    }
    /// Overridden to determine *UILabel* text alignment based on semantic content attribute and previous alignment
    public override var text: String? {
        didSet {
            if UIView.appearance().semanticContentAttribute == .forceRightToLeft, textAlignment != .center {
                self.textAlignment = .right
            } else if UIView.appearance().semanticContentAttribute == .forceLeftToRight, textAlignment != .center {
                textAlignment = .left
            }
        }
    }
    /// Overridden to determine *UILabel* attributed text alignment based on semantic content attribute and previous alignment
    public override var attributedText: NSAttributedString? {
        didSet {
            if UIView.appearance().semanticContentAttribute == .forceRightToLeft, textAlignment != .center {
                self.textAlignment = .right
            } else if UIView.appearance().semanticContentAttribute == .forceLeftToRight, textAlignment != .center {
                textAlignment = .left
            }
        }
    }
    /// Overridden to determine *UILabel* text font attributes
    public override func awakeFromNib() {
        super.awakeFromNib()

        // Update Xib font to reflect dynamic font sizes change
        adjustsFontForContentSizeCategory = true
        font = UIFont.font(
            of: FontType(name: font?.fontName) ?? FontType.lite,
            with: font?.pointSize ?? fontSize,
            shouldScale: shouldScaleFont)
    }
    /// Overridden to determine *UILabel* attributed text alignment based on semantic content attribute and previous alignment
    /// for the changed trait collection
    /// - Parameters:
    ///    - previousTraitCollection: Previous trait collection
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                if UIView.appearance().semanticContentAttribute == .forceRightToLeft, textAlignment != .center {
                    textAlignment = .right
                } else if UIView.appearance().semanticContentAttribute == .forceLeftToRight, textAlignment != .center {
                    textAlignment = .left
                }
            }
        }
    }
}

enum FontType: Int {
    case lite = 0
    case regular = 1
    case bold = 2
    case extraBold = 3

    init?(name: String?) {
        var rawValue = 0

        switch name {
        case UIFont.VFGFontName.regular.rawValue:
            rawValue = FontType.regular.rawValue
        case UIFont.VFGFontName.bold.rawValue:
            rawValue = FontType.bold.rawValue
        case UIFont.VFGFontName.extraBold.rawValue:
            rawValue = FontType.extraBold.rawValue
        default:
            rawValue = FontType.lite.rawValue
        }

        self.init(rawValue: rawValue)
    }
}


extension UILabel {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft, textAlignment != .center {
            self.textAlignment = .right
        } else if UIView.appearance().semanticContentAttribute == .forceLeftToRight, textAlignment != .center {
            textAlignment = .left
        }
    }
}

enum LabelStyle: Int {
    case heading = 0
    case paragraph = 1
}

enum HeadingSizes: CGFloat {
    case sizeX1 = 18
    case sizeX2 = 20
    case sizeX3 = 24
    case sizeX4 = 28
    case sizeX5 = 32

    init?(size: Int) {
        var rawValue: CGFloat = 18
        switch size {
        case 1:
            rawValue = HeadingSizes.sizeX1.rawValue
        case 2:
            rawValue = HeadingSizes.sizeX2.rawValue
        case 3:
            rawValue = HeadingSizes.sizeX3.rawValue
        case 4:
            rawValue = HeadingSizes.sizeX4.rawValue
        case 5:
            rawValue = HeadingSizes.sizeX5.rawValue
        default:
            rawValue = HeadingSizes.sizeX2.rawValue
        }

        self.init(rawValue: rawValue)
    }
}

enum ParagraphSizes: CGFloat {
    case sizeX1 = 14
    case sizeX2 = 16

    init?(size: Int) {
        var rawValue: CGFloat = 16
        switch size {
        case 1:
            rawValue = ParagraphSizes.sizeX1.rawValue
        case 2:
            rawValue = ParagraphSizes.sizeX2.rawValue
        default:
            rawValue = ParagraphSizes.sizeX2.rawValue
        }

        self.init(rawValue: rawValue)
    }
}
