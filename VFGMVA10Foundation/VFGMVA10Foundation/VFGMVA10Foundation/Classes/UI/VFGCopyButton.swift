//
//  VFGCopyButton.swift
//  VFGMVA10Foundation
//
//  Created by Amr Koritem on 07/04/2022.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
/// Basically a *UIButton* that copies a certain string and changes its ui to show the copy state.
/// default setup:
/// 1- if the info is copied, its background is gray, its border is white, and its content is an image.
/// 2- if not, its background is white, its border is gray, is and its content is an empty text
public class VFGCopyButton: VFGButton {
    /// pasteboardString is set to the value of UIPasteboard.general.string when the button is tapped
    /// It's mainly used for unit testing to avoid UIPasteboard simulator related issues
    internal var pasteboardString: String?

    private var copyCompletion: (() -> Void)?
    private var stringToBeCopied: String?
    private var isCopied: Bool? {
        didSet {
            isSelected = isCopied.valueOrDefault
            setBorderStyle(isSelected)
        }
    }
    private let copyIcon = UIImage(named: "icWhiteTick", in: .foundation)

    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultSetup()
    }

    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultSetup()
    }
    /// *VFGCopyButton* default configuration
    public func defaultSetup() {
        layer.borderColor = UIColor.VFGSecondaryButtonActiveOutline.cgColor
        titleLabel?.font = .vodafoneBold(16)
        titleLabel?.tintColor = .VFGPrimaryText
        layer.masksToBounds = true
        setImage(copyIcon, for: .selected)
        [UIControl.State.selected, UIControl.State.normal].forEach { state in
            setTitle("", for: state)
            setBackgroundImage(
                UIImage(color: state == .selected ? .VFGDisabledButton : .VFGWhiteBackground),
                for: state)
        }
    }

    public func copyAction() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        pasteboardString = stringToBeCopied
        UIPasteboard.general.string = pasteboardString
        isCopied = pasteboardString == stringToBeCopied
        copyCompletion?()
    }

    public func configure(
        forString stringToBeCopied: String?,
        isCopied: Bool? = nil,
        _ copyCompletion: (() -> Void)? = nil
    ) {
        self.copyCompletion = copyCompletion
        self.stringToBeCopied = stringToBeCopied
        if #available(iOS 16, *) {
            self.isCopied = isCopied
        } else {
            self.isCopied = isCopied ?? (UIPasteboard.general.string == stringToBeCopied)
        }
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        copyAction()
    }

    /// override touchesEnded to prevent it from calling super.touchesEnded
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}

    /// override this method to change how the border color is set when the button is selected/deselected
    /// - Parameters:
    ///    - isSelected: wether you want the selected border style or the deselected border style
    /// - Returns: *CGColor?* the borderColor of the border style chosen
    @discardableResult
    open func setBorderStyle(_ isSelected: Bool = true) -> CGColor? {
        layer.borderColor = isSelected ?
            UIColor.VFGWhiteBackground.cgColor :
            UIColor.VFGSecondaryButtonActiveOutline.cgColor
        return layer.borderColor
    }
}
