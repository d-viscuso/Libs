//
//  String+Convert.swift
//  VFGMVA10Framework
//
//  Created by Ivan Sanchez on 21/3/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

extension String {
    func transformToHtml(
        fontSize: Float = 16,
        fontName: String = "Vodafone Rg",
        color: UIColor? = nil,
        paragraphSpacing: CGFloat = 0,
        alignment: NSTextAlignment = NSTextAlignment.left
    ) -> NSMutableAttributedString? {
        let styleText = "<html> <head> <style type='text/css'> " +
        "body { font: \(fontSize)px '\(fontName)'} p { line-height: 5.1 }</style></head> <body>"
        let html = styleText + self
        if let htmlData = html.data(using: String.Encoding.unicode) {
            do {
                let attributedText = try NSMutableAttributedString(
                    data: htmlData,
                    options: [
                        NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html
                    ],
                    documentAttributes: nil
                )
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.paragraphSpacing = paragraphSpacing
                paragraphStyle.alignment = alignment
                if color == nil {
                    attributedText.addAttributes(
                        [
                            NSAttributedString.Key.paragraphStyle: paragraphStyle
                        ],
                        range: NSRange(location: 0, length: attributedText.length)
                    )
                } else {
                    attributedText.addAttributes(
                        [
                            NSAttributedString.Key.paragraphStyle: paragraphStyle,
                            NSAttributedString.Key.foregroundColor: color ?? .black
                        ],
                        range: NSRange(location: 0, length: attributedText.length)
                    )
                }
                return attributedText
            } catch _ as NSError {
                print("Couldn't translate")
            }
        }
        return NSMutableAttributedString()
    }
}
