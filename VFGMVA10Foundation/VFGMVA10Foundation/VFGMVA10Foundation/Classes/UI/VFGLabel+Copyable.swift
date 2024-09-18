//
//  VFGLabel+Copyable.swift
//  VFGMVA10Foundation
//
//  Created by Abdullah Soylemez on 24.03.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

public extension VFGLabel {
	// MARK: - Edit Menu
	override var canBecomeFirstResponder: Bool {
		return isCopyable
	}

	override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if isCopyable {
            return [#selector(copy(_:))].contains(action)
        }
        guard let menuItems = UIMenuController.shared.menuItems else { return false }
        let actions: [Selector] = menuItems.map { $0.action }
        return actions.contains(action)
	}

	// MARK: - UIResponderStandardEditActions
	override func copy(_ sender: Any?) {
		copyText()
	}

	func copyText() {
		UIPasteboard.general.string = text
	}

	// MARK: - Public functions
	func addLongPressMenuItems() {
		guard isCopyable else {
			return
		}

		isUserInteractionEnabled = true

		let recognizer = UILongPressGestureRecognizer(
			target: self,
			action: #selector(handleMenuItems(_:))
		)
		addGestureRecognizer(recognizer)
	}

	func removeLongPressMenuItems() {
		isUserInteractionEnabled = false
		removeGestures()
	}

	// MARK: - Private functions
	@objc private func handleMenuItems(_ recognizer: UIGestureRecognizer) {
		guard
			let recognizerView = recognizer.view,
			let recognizerSuperView = recognizerView.superview
		else {
			return
		}

		if #available(iOS 13.0, *) {
			UIMenuController.shared.showMenu(from: recognizerSuperView, rect: recognizerView.frame)
		} else {
			UIMenuController.shared.setTargetRect(recognizerView.frame, in: recognizerSuperView)
			UIMenuController.shared.setMenuVisible(true, animated: true)
		}
		recognizerView.becomeFirstResponder()
	}
}
