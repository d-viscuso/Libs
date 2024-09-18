//
//  MultiTabsCollecionViewCell.swift
//  VFGMVA10Foundation
//
//  Created by Moataz Akram on 12/4/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

protocol MultiTabsCollectionCellDelegate: AnyObject {
    func multiTabScrollViewDidScroll(offset: (old: CGPoint, new: CGPoint))
}

class MultiTabsCollecionViewCell: UICollectionViewCell {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var virtualHeight: NSLayoutConstraint!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    public weak var contentController: BaseMultiTabsViewController? {
        didSet {
            self.displayContentView()
        }
    }

    public weak var delegate: MultiTabsCollectionCellDelegate?
    private var scrollObserver: NSKeyValueObservation?
    var headerHeight: CGFloat = 176
    let tapHeight: CGFloat = 50
    var headerMaxOffset: CGFloat = 126
    var closingWithGap = true
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    func setupViews() {
        scrollObserver = scrollView?.observe(
            \.contentOffset,
            options: [.old, .new]) { [weak self] _, change in
                guard let self = self,
                    let old = change.oldValue,
                    let new = change.newValue else {
                        return
                }
                self.adjustVirtualViewHeight(new: new, old: old)
        }
    }

    private func adjustVirtualViewHeight(new: CGPoint, old: CGPoint) {
        guard new.y >= 0 else {
            virtualHeight.constant = headerHeight
            self.delegate?.multiTabScrollViewDidScroll(offset: (old: old, new: new))
            return
        }

        guard new.y <= headerMaxOffset else {
            if closingWithGap {
                scrollView.contentOffset.y = headerMaxOffset
                closingWithGap = false
            }
            virtualHeight.constant = headerHeight + headerMaxOffset
            return
        }
        self.delegate?.multiTabScrollViewDidScroll(offset: (old: old, new: new))
        virtualHeight.constant = headerHeight + new.y
        closingWithGap = true
    }

    private func displayContentView() {
        guard let content = contentController?.view else {
            return
        }
        refreshHeight(content.frame.height)
        contentController?.updateHeightClosure = { [weak self] height in
            self?.refreshHeight(height)
        }
        contentController?.setHeightClosure = { [weak self] height in
            self?.setHeight(height)
        }
        containerView?.embed(view: content)
    }

    private func refreshHeight(_ newHeight: CGFloat) {
        var extraHeightToScroll: CGFloat = 0
        if newHeight <= scrollView.frame.height - headerHeight {
            extraHeightToScroll = scrollView.frame.height - newHeight - headerHeight - tapHeight
        }
        containerViewHeight?.constant = newHeight + extraHeightToScroll
        containerView?.layoutIfNeeded()
    }

    private func setHeight(_ height: CGFloat) {
        containerViewHeight?.constant = height
        containerView?.layoutIfNeeded()
    }
}
