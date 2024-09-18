//
//  VFGTextHelper.swift
//  VFGMVA10Foundation
//
//  Created by Hussien Gamal Mohammed on 7/9/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

/// `VFGTextHelper` is a class that wraps functionality to scure and put plceholder on the given text.
class VFGTextHelper {
    let text: String?
    let placeholderText: String?
    let isSecureTextEntry: Bool

    /// Creates new instance of VFGTextHelper by the given parameters.
    /// - Parameters:
    ///    - text: Text that would be secured or put placeholder of it.
    ///    - placeholder: Placeholder that would replace the original text.
    ///    - isSecure: Boolean value to indicate if the text would be secured or not.
    init(text: String?, placeholder: String? = "", isSecure: Bool = false) {
        self.text = text
        self.placeholderText = placeholder
        self.isSecureTextEntry = isSecure
    }

    /// Returns Character at the given index.
    /// - Parameters:
    ///    - index: Frame of the gradient view.
    /// - Returns: A *Character?* from text at the given index.
    func character(atIndex index: Int) -> Character? {
        let inputTextCount = text?.count ?? 0
        let placeholderTextLength = placeholderText?.count ?? 0
        let character: Character?
        if index < inputTextCount {
            let string = text ?? ""
            character = isSecureTextEntry ? "•" : string[string.index(string.startIndex, offsetBy: index)]
        } else if index < placeholderTextLength {
            let string = placeholderText ?? ""
            character = string[string.index(string.startIndex, offsetBy: index)]
        } else {
            character = nil
        }
        return character
    }
}
