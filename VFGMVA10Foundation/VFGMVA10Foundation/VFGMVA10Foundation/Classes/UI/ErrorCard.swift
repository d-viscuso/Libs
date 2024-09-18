//
//  ErrorCard.swift
//  VFGMVA10Foundation
//
//  Created by Hussein Kishk on 3/4/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//
/// Error card view for data loading failure
public class ErrorCard: ErrorView {
    @IBOutlet var imageViewHeight: NSLayoutConstraint!
    @IBOutlet var tryAgainView: UIView!
    /// Try again button action
    public var onTryAgain: (() -> Void)?
    /// *imageViewHeight* value
    /// - Parameters:
    ///    - height: Image view constraint height constant
    public func setupImageHeight(height: CGFloat) {
        imageViewHeight.constant = height
    }
    /// Handle hiding try again button
    public func hideTryAgainView() {
        tryAgainView.isHidden = true
    }
    /// Handle showing try again button
    public func showTryAgainView() {
        tryAgainView.isHidden = false
    }

    @IBAction func tryAgain(_ sender: VFGButton) {
        onTryAgain?()
    }
}
