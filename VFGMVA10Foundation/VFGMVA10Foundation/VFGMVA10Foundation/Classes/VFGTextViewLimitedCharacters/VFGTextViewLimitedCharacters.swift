//
//  VFGTextViewLimitedCharacters.swift
//  VFGSOHOFramework
//
//  Created by Esraa Eldaltony on 13/09/2022.
//

import Foundation
import UIKit

/// A generic UIView with customizable border view, text field and top, bottom hint labels and limited number of letters.
public class VFGTextViewLimitedCharacters: UIView {
    @IBOutlet var contentView: UIView!
    /// The view at the top of textfield, it will be hidden if textfield is empty.
    @IBOutlet weak var messageHintView: UIView!
    /// The title label at the top of textfield, it will be hidden if textfield is empty.
    @IBOutlet weak var messageTitle: VFGLabel!
    /// The title label at the bottom of textfield, it shows the number of the remainimg characters user allowed to write.
    @IBOutlet weak var characterNumberLabel: VFGLabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var borderedView: UIView!

    public weak var delegate: VFGTextViewLimitedCharactersProtocol?

    var maxNumberOfCharactersAllowedToWrite: Int = 0
    var textViewPlacHolderText = ""
    var numOfCharsRemainingToWriteText = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    public func xibSetup() {
        contentView = loadViewFromNib(nibName: "VFGTextViewLimitedCharacters")
        configureView()
        xibSetup(contentView: contentView)
    }

    /// function to configure the text field
    ///  - Parameters:
    ///    - backgroundColor: Text view background color
    ///    - placeHolder: Text view placeholder
    ///    - numOfCharsRemainingText: String displayed to indecate number of remaining characters
    ///    - maxNumberOfCharactersAllowed: Max number of character allowed in text view
    public func configureView(backgroundColor: UIColor = .VFGWhiteBackground, placeHolder: String = "", numOfCharsRemainingText: String = "", maxNumberOfCharactersAllowed: Int = 120) {
        maxNumberOfCharactersAllowedToWrite = maxNumberOfCharactersAllowed
        numOfCharsRemainingToWriteText = numOfCharsRemainingText
        messageHintView.backgroundColor = backgroundColor
        messageTitle.textColor = UIColor.VFGTextViewHintColor
        messageTitle.text = placeHolder

        borderedView.roundCorners(cornerRadius: 6)
        borderedView.layer.borderWidth = 1
        borderedView.layer.borderColor = UIColor.VFGTextViewBorderInactiveColor?.cgColor

        characterNumberLabel.textColor = UIColor.VFGTextViewInfoTextColor
        characterNumberLabel.text =
        String(format: numOfCharsRemainingText, "\(self.maxNumberOfCharactersAllowedToWrite)")
        textViewPlacHolderText = placeHolder

        setuptextViewPlaceholderDefault()
    }

    func setuptextViewPlaceholderDefault() {
        textView.text = textViewPlacHolderText
        textView.textColor = .VFGTextViewPlaceHolderColor
    }

    func setupActiveState() {
        messageHintView.isHidden = false
        borderedView.layer.borderColor = UIColor.VFGTextViewBorderActiveColor?.cgColor
    }

    func setupInactiveState() {
        messageHintView.isHidden = true
        borderedView.layer.borderColor = UIColor.VFGTextViewBorderInactiveColor?.cgColor
    }
}

extension VFGTextViewLimitedCharacters: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        setupActiveState()
        if textView.text == textViewPlacHolderText {
            textView.text = ""
        }
        textView.textColor = .VFGTextViewTextColor
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        setupInactiveState()
        if textView.text?.isEmpty ?? true {
            setuptextViewPlaceholderDefault()
        }
        delegate?.getWrittenText(textView.text)
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let numOfWrittenChars = textView.text.count + (text.count - range.length)

        let numberOfRemainingChars = maxNumberOfCharactersAllowedToWrite - numOfWrittenChars
        let numberOfAllowedChars = numberOfRemainingChars > 0 ? numberOfRemainingChars : 0
        characterNumberLabel.text =
        String(format: numOfCharsRemainingToWriteText, "\(numberOfAllowedChars)")
        delegate?.getWrittenText(text)
        return numOfWrittenChars <= maxNumberOfCharactersAllowedToWrite
    }
}

public protocol VFGTextViewLimitedCharactersProtocol: AnyObject {
    func getWrittenText(_ writtenString: String?)
}
