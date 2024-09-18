//
//  VFGDependencyInjection+MultipleArgument.swift
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

/// VFGDependencyInjection Multiple Argument Support
extension VFGDependencyInjection {
	/// Internal class used by VFGDependencyInjection for multiple argument support.
	public struct Args {
		private var args: [String: Any?]

		public init(_ args: Any?) {
			if let args = args as? Args {
				self.args = args.args
			} else if let args = args as? [String: Any?] {
				self.args = args
			} else {
				self.args = ["": args]
			}
		}

		#if swift(>=5.2)
		public func callAsFunction<T>() -> T? {
			assert(args.count == 1, "argument order indeterminate, use keyed arguments")
			return args.first?.value as? T
		}

		public func callAsFunction<T>(_ key: String) -> T? {
			return args[key] as? T
		}
		#endif

		public func optional<T>() -> T? {
			return args.first?.value as? T
		}

		public func optional<T>(_ key: String) -> T? {
			return args[key] as? T
		}

		public func get<T>() -> T? {
			assert(args.count == 1, "argument order indeterminate, use keyed arguments")
			return args.first?.value as? T
		}

		public func get<T>(_ key: String) -> T? {
			return args[key] as? T
		}
	}
}
