//
//  Array+VFGStory.swift
//  VFGStory
//
//  Created by Abdullah Soylemez on 22.01.2021.
//

import UIKit

extension Array {
	func sortedArrayByPosition() -> [Element] {
		return sorted { (obj1: Element, obj2: Element) -> Bool in
			guard
				let view1 = obj1 as? UIView,
				let view2 = obj2 as? UIView
			else {
				return false
			}

			let firstViewX = view1.frame.minX
			let firstViewY = view1.frame.minY
			let secondViewX = view2.frame.minX
			let secondViewY = view2.frame.minY

			if firstViewY != secondViewY {
				return firstViewY < secondViewY
			} else {
				return firstViewX < secondViewX
			}
		}
	}
}
