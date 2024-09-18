//
//  String+Attribute.swift
//  VFGMVA10Foundation
//
//  Created by Erdem ILDIZ on 26.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public extension String {
    /// Converts regular swift String into **NSMutableAttributedString**.
    func toAttributedString() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }

    /// Adds given attributes to String and return it as NSMutableAttributedString.
    /// - Parameters:
    ///    - attributes: list of attributes that would be applied to the current String.
    /// - Returns: A *NSMutableAttributedString* of the current String and provided attributes applied to it.
    func addAttributes(_ attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttributes(
            attributes,
            range: NSRange(location: 0, length: attributedString.length)
        )
        return attributedString
    }

    /// Adds given attribute to the provided string and returns a new NSMutableAttributedString of the provided string and the attribute applied to it.
    /// - Parameters:
    ///    - text: String object that the attribute will apply to.
    ///    - attributes: Name of attribute that would be applied to the provided string.
    /// - Returns: A *NSMutableAttributedString* of the provided string and the given attribute applied to it.
    func addAttribute(to text: String, name: NSAttributedString.Key, value: Any) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        guard !text.isBlank else {
            return attributedString
        }
        let range = (self as NSString).range(of: text)
        attributedString.addAttribute(name, value: value, range: range)
        return attributedString
    }

    /// Draws a strike line through current string object and return a new NSMutableAttributedString of the current string and stroke line applied to it.
    /// - Parameters:
    ///    - lineColor: Color of the strike line, it is 'VFGRedText' by default.
    ///    - textColor: Color of the text itself, it is 'VFGPrimaryText' by default.
    /// - Returns: A *NSMutableAttributedString* of the provided string and strike line applied to it.
    func strikeThrough(lineColor color: UIColor = .VFGRedText, textColor: UIColor = .VFGPrimaryText) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: attributedString.length)
        )
        attributedString.addAttribute(
            NSAttributedString.Key.strikethroughColor,
            value: color,
            range: NSRange(location: 0, length: attributedString.length)
        )
        return attributedString
    }

    /// Draws a line under current string object and return a new NSMutableAttributedString of the current string and under line applied to it.
    /// - Returns: A *NSMutableAttributedString* of the current string and under line applied to it.
    func underLine() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: attributedString.length)
        )
        return attributedString
    }

    /// Encodes emoji string to it's code.
    /// - Returns: A *String* of the code of the emoji.
    func encodeWithEmojis() -> String? {
        guard let data = self.data(using: .nonLossyASCII, allowLossyConversion: true) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// Decodes string code to it's emoji.
    /// - Returns: A *String* of the emoji of the code.
    func decodeWithEmojis() -> String? {
        guard let data = self.data(using: .utf8) else { return nil }
        return String(data: data, encoding: .nonLossyASCII) ?? self
    }
}
