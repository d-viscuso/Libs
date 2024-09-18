//
//  StepsCollectionCell.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/7/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public class StepsCollectionCell: UICollectionViewCell {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var heightDifferenceToContentView: NSLayoutConstraint?

    public weak var hostedController: VFGBaseStepsViewControllerProtocol? {
        didSet {
            if let oldValue = oldValue {
                if oldValue.view.isDescendant(of: self) {
                    oldValue.view.removeFromSuperview()
                }
            }

            if let hostedView = hostedController?.view {
                hostedController?.onContentHeightChange = { [weak self] contentHeight in
                    guard let self = self else { return }

                    if self.frame.height >= contentHeight {
                        self.heightDifferenceToContentView?.constant = 0
                    } else {
                        self.heightDifferenceToContentView?.constant = (contentHeight - self.frame.height)
                    }

                    self.containerView?.layoutIfNeeded()
                }

                hostedView.frame = containerView.bounds
                containerView.addSubview(hostedView)
            }
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        hostedController = nil
        heightDifferenceToContentView?.constant = 0
    }
}
