//
//  ProductsCollectionCell.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 4/8/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

protocol ProductsCollectionCellDelegate: AnyObject {
    func productsTabScrollViewDidScroll(offset: (old: CGPoint, new: CGPoint))
}

class ProductsCollectionCell: UICollectionViewCell {
    @IBOutlet weak var scrollView: ProductsScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var virtualHeight: NSLayoutConstraint!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    public weak var contentController: BaseTabsViewController? {
        didSet {
            self.displayContentView()
            self.scrollView.setContentOffset(.zero, animated: false)
        }
    }

    public weak var delegate: ProductsCollectionCellDelegate?
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
            self.delegate?.productsTabScrollViewDidScroll(offset: (old: old, new: new))
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
        self.delegate?.productsTabScrollViewDidScroll(offset: (old: old, new: new))
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
