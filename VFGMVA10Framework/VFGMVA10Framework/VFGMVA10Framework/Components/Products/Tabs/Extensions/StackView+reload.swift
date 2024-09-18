//
//  StackView+reload.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 4/27/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

/// this extension to extend stackview to work like any collection with reloading
/// all needed just pass the stack item view type and model of make your view of type `StackItemViewProtocol`

public protocol StackItemViewProtocol {
    associatedtype ModelType
    func setupView(with itemVM: ModelType)
}

open class StackItemView<T>: UIView, StackItemViewProtocol {
    public typealias ModelType = T
    open func setupView(with itemVM: T) {}
}

extension StackItemViewProtocol {
    /// Represents a default nib name. It is the class name as string.
    static public var nibName: String {
        return String(describing: self)
    }
}

extension UIStackView {
    // Represents stack like collection so it needs vm and the inner view of type StackItemView.
    @discardableResult
    public func reload<U, T: StackItemView<U>>(
        _ viewModels: [U],
        using view: T.Type
    ) -> CGFloat {
        self.removeSubviews()
        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0

        for item in viewModels {
            guard let view = loadViewFromNib(nibName: view.nibName, in: Bundle.mva10Framework) as? T else {
                continue
            }

            view.setupView(with: item)
            if axis == .vertical {
                totalHeight += view.frame.height + self.spacing
            } else {
                totalWidth += view.frame.width + self.spacing
            }
            self.addArrangedSubview(view)
            view.setNeedsLayout()
        }
        return totalHeight - self.spacing
    }
}
