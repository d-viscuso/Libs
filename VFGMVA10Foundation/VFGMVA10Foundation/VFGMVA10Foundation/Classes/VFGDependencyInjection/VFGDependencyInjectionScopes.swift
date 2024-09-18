//
//  VFGDependencyInjectionScopes.swift
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

/// VFGDependencyInjection scopes exist to control when resolution occurs and how resolved instances are cached. (If at all.)
public protocol VFGDependencyInjectionScopeType: AnyObject {
	func resolve<Service>(resolver: VFGDependencyInjection, registration: VFGDependencyInjectionRegistration<Service>, args: Any?) -> Service?
}

public class VFGDependencyInjectionScope: VFGDependencyInjectionScopeType {
	// Moved definitions to VFGDependencyInjectionScope to allow for dot notation access

	/// All application scoped services exist for lifetime of the app. (e.g Singletons)
	public static let application = VFGDependencyInjectionScopeCache()
	/// Cached services exist for lifetime of the app or until their cache is reset.
	public static let cached = VFGDependencyInjectionScopeCache()
	/// Graph services are initialized once and only once during a given resolution cycle. This is the default scope.
	public static let graph = VFGDependencyInjectionScopeGraph()
	/// Shared services persist while strong references to them exist. They're then deallocated until the next resolve.
	public static let shared = VFGDependencyInjectionScopeShare()
	/// Unique services are created and initialized each and every time they're resolved.
	public static let unique = VFGDependencyInjectionScopeUnique()

	// abstract base for class never called
	public func resolve<Service>(resolver: VFGDependencyInjection, registration: VFGDependencyInjectionRegistration<Service>, args: Any?) -> Service? {
		fatalError("abstract")
	}
}

extension VFGDependencyInjection {
	// VFGDependencyInjection scope definitions maintained for compatibility with previous usage.
	@available(swift, deprecated: 4.1, message: "Please use .application to access scope.")
	public static let application = VFGDependencyInjectionScope.application
	@available(swift, deprecated: 4.1, message: "Please use .cached to access scope.")
	public static let cached = VFGDependencyInjectionScope.cached
	@available(swift, deprecated: 4.1, message: "Please use .graph to access scope.")
	public static let graph = VFGDependencyInjectionScope.graph
	@available(swift, deprecated: 4.1, message: "Please use .shared to access scope.")
	public static let shared = VFGDependencyInjectionScope.shared
	@available(swift, deprecated: 4.1, message: "Please use .unique to access scope.")
	public static let unique = VFGDependencyInjectionScope.unique
}

/// Cached services exist for lifetime of the app or until their cache is reset.
public class VFGDependencyInjectionScopeCache: VFGDependencyInjectionScope {
	public override init() {}

	public final override func resolve<Service>(resolver: VFGDependencyInjection, registration: VFGDependencyInjectionRegistration<Service>, args: Any?) -> Service? {
		if let service = cachedServices[registration.cacheKey] as? Service {
			return service
		}
		let service = registration.resolve(resolver: resolver, args: args)
		if let service = service {
			cachedServices[registration.cacheKey] = service
		}
		return service
	}

	public final func reset() {
		cachedServices.removeAll()
	}

	fileprivate var cachedServices = [String: Any](minimumCapacity: 32)
}

/// Graph services are initialized once and only once during a given resolution cycle. This is the default scope.
public final class VFGDependencyInjectionScopeGraph: VFGDependencyInjectionScope {
	public override init() {}

	public final override func resolve<Service>(resolver: VFGDependencyInjection, registration: VFGDependencyInjectionRegistration<Service>, args: Any?) -> Service? {
		if let service = graph[registration.cacheKey] as? Service {
			return service
		}
		resolutionDepth += 1
		let service = registration.resolve(resolver: resolver, args: args)
		resolutionDepth -= 1
		if resolutionDepth == 0 {
			graph.removeAll()
		} else if let service = service, type(of: service as Any) is AnyClass {
			graph[registration.cacheKey] = service
		}
		return service
	}

	private var graph = [String: Any?](minimumCapacity: 32)
	private var resolutionDepth: Int = 0
}

/// Shared services persist while strong references to them exist. They're then deallocated until the next resolve.
public final class VFGDependencyInjectionScopeShare: VFGDependencyInjectionScope {
	public override init() {}

	public final override func resolve<Service>(resolver: VFGDependencyInjection, registration: VFGDependencyInjectionRegistration<Service>, args: Any?) -> Service? {
		if let service = cachedServices[registration.cacheKey]?.service as? Service {
			return service
		}
		let service = registration.resolve(resolver: resolver, args: args)
		if let service = service, type(of: service as Any) is AnyClass {
			cachedServices[registration.cacheKey] = BoxWeak(service: service as AnyObject)
		}
		return service
	}

	public final func reset() {
		cachedServices.removeAll()
	}

	private struct BoxWeak {
		weak var service: AnyObject?
	}

	private var cachedServices = [String: BoxWeak](minimumCapacity: 32)
}

/// Unique services are created and initialized each and every time they're resolved.
public final class VFGDependencyInjectionScopeUnique: VFGDependencyInjectionScope {
	public override init() {}
	public final override func resolve<Service>(resolver: VFGDependencyInjection, registration: VFGDependencyInjectionRegistration<Service>, args: Any?) -> Service? {
		return registration.resolve(resolver: resolver, args: args)
	}
}
