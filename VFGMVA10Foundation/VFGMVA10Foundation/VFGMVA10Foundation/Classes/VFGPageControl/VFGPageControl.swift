//
//  VFGPageControl.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 3/29/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

/// Page control is a UI component that displays an instagram style dot indicator pagination
public class VFGPageControl: UIView {
    public var isDotsEqualSize = false {
        didSet {
            spacing = 10
        }
    }
    /// if enabled the selected page have the biggest size then the first left and right pages have equal smaller size then the second left and right pages have equal smaller size and so on.
    public var isSymmetricStyle = false
    /// number of pages (default is 0)
    public var numberOfPages: Int = 0 {
        didSet {
            guard numberOfPages != oldValue else { return }
            numberOfPages = max(0, numberOfPages)
            invalidateIntrinsicContentSize()
            dotViews = (0..<numberOfPages).map { _ in VFGCircularView(
                frame: CGRect(
                    origin: .zero,
                    size: CGSize(side: dotSize)
                )
                )
            }
            accessibilityLabel = "Page control dots with \(numberOfPages) pages"
            accessibilityHint = "Current page number is \(currentPage + 1)"
        }
    }
    /// current page (default is 0)
    public var currentPage: Int = 0 {
        didSet {
            guard currentPage != oldValue else { return }
            currentPage = max(0, min(numberOfPages, currentPage))
            updateColors()
            updatePositions()
            if (0..<centerDots).contains(currentPage - pageOffset) {
                centerOffset = currentPage - pageOffset
            } else {
                pageOffset = currentPage - centerOffset
            }
            accessibilityHint = "Current page number is \(currentPage + 1)"
        }
    }
    /// max number of dots has be odd number (default is 7)
    public var maxDots = 7 {
        didSet {
            guard !isDotsEqualSize else { return }
            maxDots = max(3, maxDots)
            if maxDots % 2 == 0 {
                maxDots += 1
                VFGErrorLog("maxPages has to be an odd number")
            }
            invalidateIntrinsicContentSize()
            updatePositions()
        }
    }
    /// center dots has be odd number (default is 3)
    public var centerDots = 3 {
        didSet {
            guard !isDotsEqualSize else { return }
            centerDots = max(1, centerDots)
            if centerDots % 2 == 0 {
                centerDots += 1
                VFGErrorLog("centerDots has to be an odd number")
            }
            updatePositions()
        }
    }

    /// the color of dots
    public var dotColor = UIColor.VFGPageControlTint {
        didSet {
            updateColors()
        }
    }

    /// the color of the selected dot
    public var selectedColor = UIColor.VFGPageControlCurrentPage {
        didSet {
            updateColors()
        }
    }

    /// the size of the dot (default is 12)
    public var dotSize: CGFloat = 12 {
        didSet {
            dotSize = max(1, dotSize)
            dotViews.forEach { $0.frame = CGRect(origin: .zero, size: CGSize(side: dotSize)) }
            updatePositions()
        }
    }

    /// the spacing between dots (default is 4)
    public var spacing: CGFloat = 4 {
        didSet {
            guard !isDotsEqualSize else { return }
            spacing = max(1, spacing)
            updatePositions()
        }
    }

    private var centerOffset = 0
    private var pageOffset = 0 {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                UIView.animate(withDuration: 0.1, animations: self.updatePositions)
            }
        }
    }

    private var dotViews: [UIView] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            dotViews.forEach(addSubview)
            updateColors()
            updatePositions()
        }
    }

    init() {
        super.init(frame: .zero)
        isOpaque = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
    }

    private var lastSize = CGSize.zero
    override public func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.size != lastSize else { return }
        lastSize = bounds.size
        updatePositions()
    }

    private func updateColors() {
        dotViews.enumerated().forEach { page, dot in
            dot.backgroundColor = page == currentPage ? selectedColor : dotColor
        }
    }

    private func updatePositions() {
        guard !isDotsEqualSize else {
            updateDefaultPositions()
            return
        }
        let sidePages = (maxDots - centerDots) / 2
        let horizontalOffset = CGFloat(-pageOffset + sidePages) * (dotSize + spacing) +
            (bounds.width - intrinsicContentSize.width) / 2
        let centerPage = centerDots / 2 + pageOffset
        dotViews.enumerated().forEach { page, dot in
            let center = CGPoint(
                x: horizontalOffset + bounds.minX + dotSize / 2 + (dotSize + spacing) * CGFloat(page),
                y: bounds.midY)
            let scale: CGFloat = {
                var value = 3
                if isSymmetricStyle {
                    let distance = abs(page - currentPage)
                    value = distance
                } else {
                    let distance = abs(page - centerPage)
                    if distance > (maxDots / 2) { return 0 }
                    value = distance - centerDots / 2
                }
                return [1, 0.70, 0.44, 0.33][clamp(value: value, min: 0, max: 3)]
            }()
            dot.center = center
            dot.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }

    private func updateDefaultPositions() {
        let horizontalOffset = (bounds.width - intrinsicContentSize.width) / 2
        dotViews.enumerated().forEach { page, dot in
            let center = CGPoint(
                x: horizontalOffset + bounds.minX + dotSize / 2 + (dotSize + spacing) * CGFloat(page),
                y: bounds.midY)
            dot.center = center
        }
    }

    /// the whole size of the content
    override public var intrinsicContentSize: CGSize {
        let pages = min(maxDots, self.numberOfPages)
        let width = CGFloat(pages) * dotSize + CGFloat(pages - 1) * spacing
        let height = dotSize
        return CGSize(width: width, height: height)
    }
}
