//
//  UIView+ID.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 24/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

extension UIView {
    var id: String? {
        get {
            return self.accessibilityIdentifier
        }
        set {
            self.accessibilityIdentifier = newValue
        }
    }

    func view(withId id: String) -> UIView? {
        if self.id == id {
            return self
        }
        for view in self.subviews {
            if let view = view.view(withId: id) {
                return view
            }
        }
        return nil
    }
}
