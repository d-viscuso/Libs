//
//  VFGDependencyInjectionOptions.swift
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

/// A VFGDependencyInjectionOptions instance is returned by a registration function in order to allow additonal configuratiom. (e.g. scopes, etc.)
public class VFGDependencyInjectionOptions<Service> {
	// MARK: - Parameters

	public var scope: VFGDependencyInjectionScope

	fileprivate var mutator: VFGDependencyInjectionFactoryMutator<Service>?
	fileprivate var mutatorWithArgumentsN: VFGDIFactoryMutatorArgumentsN<Service>?
	fileprivate weak var resolver: VFGDependencyInjection?

	// MARK: - Lifecycle

	public init(resolver: VFGDependencyInjection) {
		self.resolver = resolver
		self.scope = VFGDependencyInjection.defaultScope
	}

	// MARK: - Fuctionality

	/// Indicates that the registered Service also implements a specific protocol that may be resolved on
	/// its own.
	///
	/// - parameter type: Type of protocol being registered.
	/// - parameter name: Named variant of protocol being registered.
	///
	/// - returns: VFGDependencyInjectionOptions instance that allows further customization of registered Service.
	///
	@discardableResult
	public final func implements<Protocol>(_ type: Protocol.Type, name: VFGDependencyInjection.Name? = nil) -> VFGDependencyInjectionOptions<Service> {
		resolver?.register(type.self, name: name) { resolver, _ in resolver.resolve(Service.self) as? Protocol }
		return self
	}

	/// Allows easy assignment of injected properties into resolved Service.
	///
	/// - parameter block: Resolution block.
	///
	/// - returns: VFGDependencyInjectionOptions instance that allows further customization of registered Service.
	///
	@discardableResult
	public final func resolveProperties(_ block: @escaping VFGDependencyInjectionFactoryMutator<Service>) -> VFGDependencyInjectionOptions<Service> {
		mutator = block
		return self
	}

	/// Allows easy assignment of injected properties into resolved Service.
	///
	/// - parameter block: Resolution block that also receives resolution arguments.
	///
	/// - returns: VFGDependencyInjectionOptions instance that allows further customization of registered Service.
	///
	@discardableResult
	public final func resolveProperties(_ block: @escaping VFGDIFactoryMutatorArgumentsN<Service>) -> VFGDependencyInjectionOptions<Service> {
		mutatorWithArgumentsN = block
		return self
	}

	/// Defines scope in which requested Service may be cached.
	///
	/// - parameter block: Resolution block.
	///
	/// - returns: VFGDependencyInjectionOptions instance that allows further customization of registered Service.
	///
	@discardableResult
	public final func scope(_ scope: VFGDependencyInjectionScope) -> VFGDependencyInjectionOptions<Service> {
		self.scope = scope
		return self
	}

	/// Internal function to apply mutations with and w/o arguments
	fileprivate func mutate(_ service: Service, resolver: VFGDependencyInjection, args: Any?) {
		self.mutator?(resolver, service)
		if let mutatorWithArgumentsN = mutatorWithArgumentsN {
			mutatorWithArgumentsN(resolver, service, VFGDependencyInjection.Args(args))
		}
	}
}

/// VFGDependencyInjectionRegistration base class stores the registration keys.
public class VFGDependencyInjectionRegistration<Service>: VFGDependencyInjectionOptions<Service> {
	public var key: Int
	public var cacheKey: String

	public init(resolver: VFGDependencyInjection, key: Int, name: VFGDependencyInjection.Name?) {
		self.key = key
		if let namedService = name {
			self.cacheKey = String(key) + ":" + namedService.rawValue
		} else {
			self.cacheKey = String(key)
		}
		super.init(resolver: resolver)
	}

	public func resolve(resolver: VFGDependencyInjection, args: Any?) -> Service? {
		fatalError("abstract function")
	}
}

/// VFGDependencyInjectionRegistration stores a service definition and its factory closure.
public final class VFGDependencyInjectionRegistrationOnly<Service>: VFGDependencyInjectionRegistration<Service> {
	public var factory: VFGDependencyInjectionFactory<Service>

	public init(resolver: VFGDependencyInjection, key: Int, name: VFGDependencyInjection.Name?, factory: @escaping VFGDependencyInjectionFactory<Service>) {
		self.factory = factory
		super.init(resolver: resolver, key: key, name: name)
	}

	public final override func resolve(resolver: VFGDependencyInjection, args: Any?) -> Service? {
		guard let service = factory() else {
			return nil
		}
		mutate(service, resolver: resolver, args: args)
		return service
	}
}

/// VFGDependencyInjectionRegistrationResolver stores a service definition and its factory closure.
public final class VFGDIRegistrationResolver<Service>: VFGDependencyInjectionRegistration<Service> {
	public var factory: VFGDependencyInjectionFactoryResolver<Service>

	public init(resolver: VFGDependencyInjection, key: Int, name: VFGDependencyInjection.Name?, factory: @escaping VFGDependencyInjectionFactoryResolver<Service>) {
		self.factory = factory
		super.init(resolver: resolver, key: key, name: name)
	}

	public final override func resolve(resolver: VFGDependencyInjection, args: Any?) -> Service? {
		guard let service = factory(resolver) else {
			return nil
		}
		mutate(service, resolver: resolver, args: args)
		return service
	}
}

/// VFGDependencyInjectionRegistrationArguments stores a service definition and its factory closure.
public final class VFGDependencyInjectionArgumentsN<Service>: VFGDependencyInjectionRegistration<Service> {
	public var factory: VFGDependencyInjectionFactoryArgumentsN<Service>

	public init(resolver: VFGDependencyInjection, key: Int, name: VFGDependencyInjection.Name?, factory: @escaping VFGDependencyInjectionFactoryArgumentsN<Service>) {
		self.factory = factory
		super.init(resolver: resolver, key: key, name: name)
	}

	public final override func resolve(resolver: VFGDependencyInjection, args: Any?) -> Service? {
		guard let service = factory(resolver, VFGDependencyInjection.Args(args)) else {
			return nil
		}
		mutate(service, resolver: resolver, args: args)
		return service
	}
}
