//
//  String+Extensions.swift
//  VFGMVA10Foundation
//
//  Created by Erdem ILDIZ on 26.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

public extension String {
    /// Boolean value to determine if the String object is blank or not.
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Calculates and returns the size of the provided font.
    /// - Parameters:
    ///    - font: Font that it's size would be returned
    /// - Returns: A *CGSize* of the provided font.
    func size(with font: UIFont) -> CGSize {
        var titleRect: CGRect?
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        titleRect = self.boundingRect(
            with: CGSize(width: Int.max, height: Int.max),
            options: .usesLineFragmentOrigin,
            attributes: [
                NSAttributedString.Key.font: font
            ],
            context: nil)
        if let titleRectWidth = titleRect?.size.width,
        let titleRectHeight = titleRect?.size.height {
            width = titleRectWidth
            height = titleRectHeight
        }
        return CGSize(width: width, height: height)
    }

    /// Replaces the given key (String) with empty string.
    /// - Parameters:
    ///    - key: The string that would be replaced.
    /// - Returns: A *String* does not contain the given key.
    func replaceWithBlank(find key: String) -> String {
        return replacingOccurrences(of: key, with: "")
    }

    /// Converts the String object to object of type *NSAttributedString?* wrapping HTML text.
    var toHTML: NSAttributedString? {
        guard
            let data = self.data(using: .unicode),
            let attrStr = try? NSAttributedString(
                data: data,
                options: [
                    NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html
                ],
                documentAttributes: nil)
        else { return nil }

        if #available(iOS 11.0, *) {
            let newFont = UIFont.vodafoneRegular(17)
            let mattrStr = NSMutableAttributedString(attributedString: attrStr)
            mattrStr.beginEditing()
            mattrStr.enumerateAttribute(
                .font,
                in: NSRange(location: 0, length: mattrStr.length),
                options: .longestEffectiveRangeNotRequired) { value, range, _ in
                if
                    let oFont = value as? UIFont,
                    let newFontDescriptor = oFont
                        .fontDescriptor.withFamily(newFont.familyName)
                        .withSymbolicTraits(oFont.fontDescriptor.symbolicTraits)
                {
                    let nFont = UIFont(descriptor: newFontDescriptor, size: newFont.pointSize)
                    mattrStr.removeAttribute(.font, range: range)
                    mattrStr.addAttribute(.font, value: nFont, range: range)
                }
                mattrStr.endEditing()
            }
            return mattrStr
        } else {
            return self.htmlToAttributedString
        }
    }

    /// Converts the HTML text of type String to object  of type *NSAttributedString?* wrapping same text.
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            return NSAttributedString()
        }
    }

    /// Converts HTML text to String literal.
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

    /// Removes new lines from String object.
    var removeNewLines: String {
        return replacingOccurrences(of: "\\n", with: "")
    }

    /// Adds under line to the String object and returns a new NSAttributedString object wrapping the under-lined text.
    var underLined: NSAttributedString {
        NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }

    /// Creates new NSMutableAttributedString wrapping the HTML text and the given attributes.
    /// - Parameters:
    ///    - htmlText: The text that attributes will be added to it.
    ///    - fontSize: Font size of the wanted attributed string.
    ///    - color: Color of the wanted attributed string.
    /// - Returns: A *NSMutableAttributedString?* wrapping the HTML text and the given attributes applied to it.
    func attributedTextFrom(htmlText: String, fontSize: CGFloat, color: UIColor) -> NSMutableAttributedString? {
        let baseFont = UIFont.vodafoneRegular(fontSize)
        guard
            let fontName = baseFont.fontName as NSString?
        else {
            return nil
        }
        let modifiedFont = String(
            format: "<span style=\"font-family: '\(fontName)'; font-size: \(baseFont.pointSize)\">%@</span>", htmlText)

        do {
            guard let data = modifiedFont.data(using: .unicode, allowLossyConversion: true) else {
                return nil
            }
            let attributedText = try NSMutableAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            attributedText.addAttribute(textColor: color)
            return attributedText
        } catch {
            VFGDebugLog("Error getting attributed text from html: \(error)")
            return nil
        }
    }

    /// Bold the given text in the whole String object and returns new NSAttributedString wrapping the whole string with bold parts.
    /// - Parameters:
    ///    - boldPartOfString: Text that will be bold.
    ///    - baseFont: Regular text font.
    ///    - baseColor: Regular text color.
    ///    - boldFont: Bold text font.
    ///    - boldColor: Bold text color.
    /// - Returns: A *NSAttributedString* wrapping the whole text with bold parts.
    func addBoldText(boldPartOfString: String?, baseFont: UIFont, baseColor: UIColor, boldFont: UIFont, boldColor: UIColor) -> NSAttributedString {
        let baseAttributes = [
            NSAttributedString.Key.font: baseFont,
            NSAttributedString.Key.foregroundColor: baseColor
        ]
        let boldAttributes = [
            NSAttributedString.Key.font: boldFont,
            NSAttributedString.Key.foregroundColor: boldColor
        ]
        let attributedString = NSMutableAttributedString(string: self, attributes: baseAttributes)
        if let boldPartOfString = boldPartOfString {
            attributedString.addAttributes(
                boldAttributes,
                range: NSRange(
                    self.range(of: boldPartOfString) ?? self.startIndex..<self.endIndex,
                    in: self
                )
            )
        }
        return attributedString
    }
}

/// `FontSizeType` is an enum to simplifies using **point** or **pixel** in font size types.
///
/// Font size come in points or pixels where: 1 pixel (px) is usually assumed to be 1/96th of an inch.
///
/// 1 point (pt) is assumed to be 1/72nd of an inch.
/// - Cases:
///    - point: In typography, the point is the smallest unit of measure. It is used for measuring font size, the size of a point has been between 0.18 and 0.4 millimeters.
///    - pixel: In typography, the pixel is commonly used where as 16px = 12pt.
public enum FontSizeType: String {
    case point
    case pixel
}

extension String {
    /// Converts String object to HTML text.
    /// - Parameters:
    ///    - fontSize: Font size of the wanted HTLM text.
    ///    - fontSizeType: Type of the font size, it is 'pixel' by default.
    ///    - fontName: Name of the wanted font, it is **Vodafone Rg** by default.
    ///    - color: Color of the wanted HTML text.
    /// - Returns: A *NSMutableAttributedString?* wrapping the HTML text and the given attributes applied to it.
    public func convertToHtml(fontSize: Float = 16, fontSizeType: FontSizeType = .pixel, fontName: String = "Vodafone Rg", color: UIColor? = nil, paragraphSpacing: CGFloat = 0, alignment: NSTextAlignment = NSTextAlignment.left ) -> NSMutableAttributedString? {
        let siz = fontSize
        let raw = fontSizeType.rawValue
        let styleText = """
            <html> <head> <style type='text/css'> body { \
        font: \(siz)\(raw) '\(fontName)'} p { line-height: 5.1 }</style></head> <body>
        """
        let html = styleText + self
        if let htmlData = html.data(using: String.Encoding.unicode) {
            do {
                let documentType = NSAttributedString.DocumentType.html
                let options = [NSAttributedString.DocumentReadingOptionKey.documentType: documentType]
                let attText = try NSMutableAttributedString(data: htmlData, options: options, documentAttributes: nil)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.paragraphSpacing = paragraphSpacing
                paragraphStyle.alignment = alignment
                if color == nil {
                    let range = NSRange(location: 0, length: attText.length)
                    attText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: range)
                } else {
                    let style = NSAttributedString.Key.paragraphStyle
                    let attributes = [style: paragraphStyle, NSAttributedString.Key.foregroundColor: color]
                    let range = NSRange(location: 0, length: attText.length)
                    attText.addAttributes(attributes as [NSAttributedString.Key: Any], range: range)
                }
                return attText
            } catch _ as NSError {
                VFGErrorLog("Couldn't translate")
            }
        }
        return NSMutableAttributedString()
    }
}
