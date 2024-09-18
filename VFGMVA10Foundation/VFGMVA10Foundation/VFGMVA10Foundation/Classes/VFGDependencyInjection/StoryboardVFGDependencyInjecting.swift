//
//  StoryboardVFGDependencyInjecting.swift
//  VFGMVA10Foundation
//
//  Created by Abdullah Soylemez on 23.03.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

#if os(iOS)
import UIKit
import SwiftUI
#elseif os(macOS) || os(tvOS) || os(watchOS)
import Foundation
import SwiftUI
#else
import Foundation
#endif

#if os(iOS)
/// Storyboard Automatic Resolution Protocol
public protocol StoryboardVFGDependencyInjecting: VFGDependencyInjecting {
	func resolveViewController()
}

/// Storyboard Automatic Resolution Trigger
public extension UIViewController {
	@objc dynamic var resolving: Bool {
		get {
			return true
		}
		set {
			_ = newValue
			if let viewController = self as? StoryboardVFGDependencyInjecting {
				viewController.resolveViewController()
			}
		}
	}
}
#endif
