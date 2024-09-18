//
//  FreshLayout.swift
//  ewdewfd
//
//  Created by Claudio Cavalli on 18/05/22.
//

import Foundation
import UIKit

// MARK: - FreshLayout.
@propertyWrapper
public struct FreshLayout<T: UIView> {
    // left FreshConstraint.
    public var left: FreshConstraint { layoutItem(wrappedValue, .left) }
    // right FreshConstraint.
    public var right: FreshConstraint { layoutItem(wrappedValue, .right) }
    // top FreshConstraint.
    public var top: FreshConstraint { layoutItem(wrappedValue, .top) }
    // bottom FreshConstraint.
    public var bottom: FreshConstraint { layoutItem(wrappedValue, .bottom) }
    // leading FreshConstraint.
    public var leading: FreshConstraint { layoutItem(wrappedValue, .leading) }
    // trailing FreshConstraint.
    public var trailing: FreshConstraint { layoutItem(wrappedValue, .trailing) }
    // width FreshConstraint.
    public var width: FreshConstraint { layoutItem(wrappedValue, .width) }
    // height FreshConstraint.
    public var height: FreshConstraint { layoutItem(wrappedValue, .height) }
    // centerX FreshConstraint.
    public var centerX: FreshConstraint { layoutItem(wrappedValue, .centerX) }
    // centerY FreshConstraint.
    public var centerY: FreshConstraint { layoutItem(wrappedValue, .centerY) }
    // firstBaseline FreshConstraint.
    public var firstBaseline: FreshConstraint { layoutItem(wrappedValue, .firstBaseline) }
    // lastBaseline FreshConstraint.
    public var lastBaseline: FreshConstraint { layoutItem(wrappedValue, .lastBaseline) }
    // leftMargin FreshConstraint.
    public var leftMargin: FreshConstraint { layoutItem(wrappedValue, .leftMargin) }
    // rightMargin FreshConstraint.
    public var rightMargin: FreshConstraint { layoutItem(wrappedValue, .rightMargin) }
    // topMargin FreshConstraint.
    public var topMargin: FreshConstraint { layoutItem(wrappedValue, .topMargin) }
    // bottomMargin FreshConstraint.
    public var bottomMargin: FreshConstraint { layoutItem(wrappedValue, .bottomMargin) }
    // leadingMargin FreshConstraint.
    public var leadingMargin: FreshConstraint { layoutItem(wrappedValue, .leadingMargin) }
    // trailingMargin FreshConstraint.
    public var trailingMargin: FreshConstraint { layoutItem(wrappedValue, .trailingMargin) }
    // centerXWithinMargins FreshConstraint.
    public var centerXWithinMargins: FreshConstraint { layoutItem(wrappedValue, .centerXWithinMargins) }
    // centerYWithinMargins FreshConstraint.
    public var centerYWithinMargins: FreshConstraint { layoutItem(wrappedValue, .centerYWithinMargins) }
    // wrappedValue T.
    public var wrappedValue: T
    
    // init FreshLayout.
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
    
    // make NSLayoutConstraint with FreshLayoutBuilder.
    public func makeConstraints(@FreshLayoutBuilder make: (Self) -> [NSLayoutConstraint]) {
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(make(self))
    }
    
    // remakeConstraints NSLayoutConstraint with FreshLayoutBuilder.
    public func remakeConstraints(@FreshLayoutBuilder make: (Self) -> [NSLayoutConstraint]) {
        deactivateConstraints(constraints: wrappedValue.getAllConstraints())
        makeConstraints(make: make)
    }
    
    // updateConstraints NSLayoutConstraint with FreshLayoutBuilder.
    public func updateConstraints(@FreshLayoutBuilder make: (Self) -> [NSLayoutConstraint]) {
        let updateConstraint = wrappedValue.getAllConstraints().filter { item in
            (make(self).first(where: { $0.firstAttribute == item.firstAttribute }) != nil) ? true:false
        }
        
        deactivateConstraints(constraints: updateConstraint)
        makeConstraints(make: make)
    }
    
    // removeAllConstraints NSLayoutConstraint with deactivate.
    public func removeAllConstraints() {
        NSLayoutConstraint.deactivate(wrappedValue.getAllConstraints())
    }
    
    // deactivateConstraints NSLayoutConstraint with deactivate.
    public func deactivateConstraints(constraints: [NSLayoutConstraint]) {
        NSLayoutConstraint.deactivate(constraints)
    }
    
    // anchorTo create NSLayoutConstraint for cover a second view.
    public func anchorTo(boundsOf view: UIView, margin: CGFloat = 0.0) -> [NSLayoutConstraint] {
        [
            top.constrain(view.fresh.top.constant(margin), relation: .equal),
            leading.constrain(view.fresh.leading.constant(margin), relation: .equal),
            view.fresh.bottom.constrain(bottom.constant(margin), relation: .equal),
            view.fresh.trailing.constrain(trailing.constant(margin), relation: .equal)
        ]
    }
    
    // centerTo create NSLayoutConstraint for center a second view.
    public func centerTo(boundsOf view: UIView) -> [NSLayoutConstraint] {
        [
            centerX.constrain(view.fresh.centerX, relation: .equal),
            centerY.constrain(view.fresh.centerY, relation: .equal)
        ]
    }
    
    // layoutItem create NSLayoutConstraint for center a second view.
    private func layoutItem(_ item: UIView, _ attribute: NSLayoutConstraint.Attribute) -> FreshConstraint {
        FreshConstraint(item: item, attribute: attribute, multiplier: 1.0, constant: 0.0)
    }
}
