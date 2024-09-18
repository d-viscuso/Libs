//
//  VFGFloatingTobiWelcomeMessageView.swift
//  VFGMVA10Foundation
//
//  Created by Tuncel, Pelin, Vodafone on 7/5/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

public protocol VFGFloatingTobiMessageViewDelegate: AnyObject {
    func closeAction()
}

public class VFGFloatingTobiWelcomeMessageView: UIView {
    public weak var delegate: VFGFloatingTobiMessageViewDelegate?
    @IBOutlet public weak var titleLabel: VFGLabel!
    @IBOutlet public weak var closeIconImageView: VFGImageView!

    public override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeButtonDidPress))
        closeIconImageView.addGestureRecognizer(tap)
        closeIconImageView.isUserInteractionEnabled = true
        layer.cornerRadius = 34
        hideViews()
    }

    @objc func closeButtonDidPress() {
        delegate?.closeAction()
    }

    public func hideViews() {
        closeIconImageView.isHidden = true
        titleLabel.isHidden = true
    }

    public func showViews() {
        closeIconImageView.isHidden = false
        titleLabel.isHidden = false
    }
}
