//
//  VFGDependencyInjection.swift
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

public protocol VFGDependencyInjectionRegistering {
	static func registerAllServices()
}

/// The VFGDependencyInjecting protocol is used to make the VFGDependencyInjection registries available to a given class.
public protocol VFGDependencyInjecting {
	var resolver: VFGDependencyInjection { get }
}

extension VFGDependencyInjecting {
	public var resolver: VFGDependencyInjection {
		return VFGDependencyInjection.root
	}
}

/// VFGDependencyInjection is a Dependency Injection registry that registers Services for later resolution and
/// injection into newly constructed instances.
public final class VFGDependencyInjection {
	// MARK: - Defaults

	/// Default registry used by the static Registration functions.
	public static var main = VFGDependencyInjection()
	/// Default registry used by the static Resolution functions and by the VFGDependencyInjecting protocol.
	public static var root: VFGDependencyInjection = main
	/// Default scope applied when registering new objects.
	public static var defaultScope: VFGDependencyInjectionScope = .graph

	// MARK: - Lifecycle

	public init(parent: VFGDependencyInjection? = nil) {
		self.parent = parent
	}
	/// Call function to force one-time initialization of the VFGDependencyInjection registries. Usually not needed as functionality
	/// occurs automatically the first time a resolution function is called.
	public final func registerServices() {
		lock.lock()
		defer { lock.unlock() }
		registrationCheck()
	}

	/// Call function to force one-time initialization of the VFGDependencyInjection registries. Usually not needed as functionality
	/// occurs automatically the first time a resolution function is called.
	public static var registerServices: (() -> Void)? = {
		lock.lock()
		defer { lock.unlock() }
		registrationCheck()
	}

	/// Called to effectively reset VFGDependencyInjection to its initial state, including recalling registerAllServices if it was provided. This will
	/// also reset the three known caches: application, cached, shared.
	public static func reset() {
		lock.lock()
		defer { lock.unlock() }
		main = VFGDependencyInjection()
		root = main
		VFGDependencyInjectionScope.application.reset()
		VFGDependencyInjectionScope.cached.reset()
		VFGDependencyInjectionScope.shared.reset()
		registrationNeeded = true
	}

	// MARK: - Service Registration

	/// Static shortcut function used to register a specifc Service type and its instantiating factory method.
	///
	/// - parameter type: Type of Service being registered. Optional, may be inferred by factory result type.
	/// - parameter name: Named variant of Service being registered.
	/// - parameter factory: Closure that constructs and returns instances of the Service.
	///
	/// - returns: VFGDependencyInjectionOptions instance that allows further customization of registered Service.
	///
	@discardableResult
	public static func register<Service>(
		_ type: Service.Type = Service.self,
		name: VFGDependencyInjection.Name? = nil,
		factory: @escaping VFGDependencyInjectionFactory<Service>
	) -> VFGDependencyInjectionOptions<Service> {
		return main.register(type, name: name, factory: factory)
	}

	/// Static shortcut function used to register a specifc Service type and its instantiating factory method.
	///
	/// - parameter type: Type of Service being registered. Optional, may be inferred by factory result type.
	/// - parameter name: Named variant of Service being registered.
	/// - parameter factory: Closure that constructs and returns instances of the Service.
	///
	/// - returns: VFGDependencyInjectionOptions instance that allows further customization of registered Service.
	///
	@discardableResult
	public static func register<Service>(
		_ type: Service.Type = Service.self,
		name: VFGDependencyInjection.Name? = nil,
		factory: @escaping VFGDependencyInjectionFactoryResolver<Service>
	) -> VFGDependencyInjectionOptions<Service> {
		return main.register(type, name: name, factory: factory)
	}

	/// Static shortcut function used to register a specifc Service type and its instantiating factory method with multiple argument support.
	///
	/// - parameter type: Type of Service being registered. Optional, may be inferred by factory result type.
	/// - parameter name: Named variant of Service being registered.
	/// - parameter factory: Closure that accepts arguments and constructs and returns instances of the Service.
	///
	/// - returns: VFGDependencyInjectionOptions instance that allows further customization of registered Service.
	///
	@discardableResult
	public static func register<Service>(
		_ type: Service.Type = Service.self,
		name: VFGDependencyInjection.Name? = nil,
		factory: @escaping VFGDependencyInjectionFactoryArgumentsN<Service>
	) -> VFGDependencyInjectionOptions<Service> {
		return main.register(type, name: name, factory: factory)
	}

	/// Registers a specifc Service type and its instantiating factory method.
	///
	/// - parameter type: Type of Service being registered. Optional, may be inferred by factory result type.
	/// - parameter name: Named variant of Service being registered.
	/// - parameter factory: Closure that constructs and returns instances of the Service.
	///
	/// - returns: VFGDependencyInjectionOptions instance that allows further customization of registered Service.
	///
	@discardableResult
	public final func register<Service>(
		_ type: Service.Type = Service.self,
		name: VFGDependencyInjection.Name? = nil,
		factory: @escaping VFGDependencyInjectionFactory<Service>
	) -> VFGDependencyInjectionOptions<Service> {
		lock.lock()
		defer { lock.unlock() }
		let key = ObjectIdentifier(Service.self).hashValue
		let registration = VFGDependencyInjectionRegistrationOnly(resolver: self, key: key, name: name, factory: factory)
		add(registration: registration, with: key, name: name)
		return registration
	}

	/// Registers a specifc Service type and its instantiating factory method.
	///
	/// - parameter type: Type of Service being registered. Optional, may be inferred by factory result type.
	/// - parameter name: Named variant of Service being registered.
	/// - parameter factory: Closure that constructs and returns instances of the Service.
	///
	/// - returns: VFGDependencyInjectionOptions instance that allows further customization of registered Service.
	///
	@discardableResult
	public final func register<Service>(
		_ type: Service.Type = Service.self,
		name: VFGDependencyInjection.Name? = nil,
		factory: @escaping VFGDependencyInjectionFactoryResolver<Service>
	) -> VFGDependencyInjectionOptions<Service> {
		lock.lock()
		defer { lock.unlock() }
		let key = ObjectIdentifier(Service.self).hashValue
		let registration = VFGDIRegistrationResolver(resolver: self, key: key, name: name, factory: factory)
		add(registration: registration, with: key, name: name)
		return registration
	}

	/// Registers a specifc Service type and its instantiating factory method with multiple argument support.
	///
	/// - parameter type: Type of Service being registered. Optional, may be inferred by factory result type.
	/// - parameter name: Named variant of Service being registered.
	/// - parameter factory: Closure that accepts arguments and constructs and returns instances of the Service.
	///
	/// - returns: VFGDependencyInjectionOptions instance that allows further customization of registered Service.
	///
	@discardableResult
	public final func register<Service>(
		_ type: Service.Type = Service.self,
		name: VFGDependencyInjection.Name? = nil,
		factory: @escaping VFGDependencyInjectionFactoryArgumentsN<Service>
	) -> VFGDependencyInjectionOptions<Service> {
		lock.lock()
		defer { lock.unlock() }
		let key = ObjectIdentifier(Service.self).hashValue
		let registration = VFGDependencyInjectionArgumentsN(resolver: self, key: key, name: name, factory: factory)
		add(registration: registration, with: key, name: name)
		return registration
	}

	// MARK: - Service Resolution

	/// Static function calls the root registry to resolve a given Service type.
	///
	/// - parameter type: Type of Service being resolved. Optional, may be inferred by assignment result type.
	/// - parameter name: Named variant of Service being resolved.
	/// - parameter args: Optional arguments that may be passed to registration factory.
	///
	/// - returns: Instance of specified Service.
	public static func resolve<Service>(_ type: Service.Type = Service.self, name: VFGDependencyInjection.Name? = nil, args: Any? = nil) -> Service {
		lock.lock()
		defer { lock.unlock() }
		registrationCheck()
		if let registration = root.lookup(type, name: name),
			let service = registration.scope.resolve(resolver: root, registration: registration, args: args) {
			return service
		}
		let resolverName = "\(Service.self):\(name?.rawValue ?? "NONAME")"
		fatalError("RESOLVER: '\(resolverName)' not resolved. To disambiguate optionals use resolver.optional().")
	}

	/// Resolves and returns an instance of the given Service type from the current registry or from its
	/// parent registries.
	///
	/// - parameter type: Type of Service being resolved. Optional, may be inferred by assignment result type.
	/// - parameter name: Named variant of Service being resolved.
	/// - parameter args: Optional arguments that may be passed to registration factory.
	///
	/// - returns: Instance of specified Service.
	///
	public final func resolve<Service>(_ type: Service.Type = Service.self, name: VFGDependencyInjection.Name? = nil, args: Any? = nil) -> Service {
		lock.lock()
		defer { lock.unlock() }
		registrationCheck()
		if let registration = lookup(type, name: name),
			let service = registration.scope.resolve(resolver: self, registration: registration, args: args) {
			return service
		}
		let resolverName = "\(Service.self):\(name?.rawValue ?? "NONAME")"
		fatalError("RESOLVER: '\(resolverName)' not resolved. To disambiguate optionals use resolver.optional().")
	}

	/// Static function calls the root registry to resolve an optional Service type.
	///
	/// - parameter type: Type of Service being resolved. Optional, may be inferred by assignment result type.
	/// - parameter name: Named variant of Service being resolved.
	/// - parameter args: Optional arguments that may be passed to registration factory.
	///
	/// - returns: Instance of specified Service.
	///
	public static func optional<Service>(_ type: Service.Type = Service.self, name: VFGDependencyInjection.Name? = nil, args: Any? = nil) -> Service? {
		lock.lock()
		defer { lock.unlock() }
		registrationCheck()
		if let registration = root.lookup(type, name: name),
			let service = registration.scope.resolve(resolver: root, registration: registration, args: args) {
			return service
		}
		return nil
	}

	/// Resolves and returns an optional instance of the given Service type from the current registry or
	/// from its parent registries.
	///
	/// - parameter type: Type of Service being resolved. Optional, may be inferred by assignment result type.
	/// - parameter name: Named variant of Service being resolved.
	/// - parameter args: Optional arguments that may be passed to registration factory.
	///
	/// - returns: Instance of specified Service.
	///
	public final func optional<Service>(_ type: Service.Type = Service.self, name: VFGDependencyInjection.Name? = nil, args: Any? = nil) -> Service? {
		lock.lock()
		defer { lock.unlock() }
		registrationCheck()
		if let registration = lookup(type, name: name),
			let service = registration.scope.resolve(resolver: self, registration: registration, args: args) {
			return service
		}
		return nil
	}

	// MARK: - Internal

	/// Internal function searches the current and parent registries for a VFGDependencyInjectionRegistration<Service> that matches
	/// the supplied type and name.
	private final func lookup<Service>(_ type: Service.Type, name: VFGDependencyInjection.Name?) -> VFGDependencyInjectionRegistration<Service>? {
		let key = ObjectIdentifier(Service.self).hashValue
		let containerName = name?.rawValue ?? NONAME
		if let container = registrations[key], let registration = container[containerName] {
			return registration as? VFGDependencyInjectionRegistration<Service>
		}
		if let parent = parent, let registration = parent.lookup(type, name: name) {
			return registration
		}
		return nil
	}

	/// Internal function adds a new registration to the proper container.
	private final func add<Service>(registration: VFGDependencyInjectionRegistration<Service>, with key: Int, name: VFGDependencyInjection.Name?) {
		if var container = registrations[key] {
			container[name?.rawValue ?? NONAME] = registration
			registrations[key] = container
		} else {
			registrations[key] = [name?.rawValue ?? NONAME: registration]
		}
	}

	private let NONAME = "*"
	private let parent: VFGDependencyInjection?
	private let lock = VFGDependencyInjection.lock
	private var registrations: [Int: [String: Any]] = [:]
}

/// VFGDependencyInjecting an instance of a service is a recursive process (service A needs a B which needs a C).
private class VFGDependencyInjectionRecursiveLock {
	init() {
		pthread_mutexattr_init(&recursiveMutexAttr)
		pthread_mutexattr_settype(&recursiveMutexAttr, PTHREAD_MUTEX_RECURSIVE)
		pthread_mutex_init(&recursiveMutex, &recursiveMutexAttr)
	}
	@inline(__always)
	func lock() {
		pthread_mutex_lock(&recursiveMutex)
	}
	@inline(__always)
	func unlock() {
		pthread_mutex_unlock(&recursiveMutex)
	}
	private var recursiveMutex = pthread_mutex_t()
	private var recursiveMutexAttr = pthread_mutexattr_t()
}

extension VFGDependencyInjection {
	private static let lock = VFGDependencyInjectionRecursiveLock()
}

/// VFGDependencyInjection Service Name Space Support
extension VFGDependencyInjection {
	/// Internal class used by VFGDependencyInjection for typed name space support.
	public struct Name: ExpressibleByStringLiteral {
		let rawValue: String
		public init(_ rawValue: String) {
			self.rawValue = rawValue
		}
		public init(stringLiteral: String) {
			self.rawValue = stringLiteral
		}
		public static func name(fromString string: String?) -> Name? {
			if let string = string { return Name(string) }
			return nil
		}
	}
}

// Registration Internals
private var registrationNeeded = true

@inline(__always)
private func registrationCheck() {
	guard registrationNeeded else {
		return
	}
	if let registering = (VFGDependencyInjection.root as Any) as? VFGDependencyInjectionRegistering {
		type(of: registering).registerAllServices()
	}
	registrationNeeded = false
}

public typealias VFGDependencyInjectionFactory<Service> = () -> Service?
public typealias VFGDependencyInjectionFactoryResolver<Service> = (_ resolver: VFGDependencyInjection) -> Service?
public typealias VFGDependencyInjectionFactoryArgumentsN<Service> = (
	_ resolver: VFGDependencyInjection,
	_ args: VFGDependencyInjection.Args
) -> Service?
public typealias VFGDependencyInjectionFactoryMutator<Service> = (
	_ resolver: VFGDependencyInjection,
	_ service: Service
) -> Void
public typealias VFGDIFactoryMutatorArgumentsN<Service> = (
	_ resolver: VFGDependencyInjection,
	_ service: Service,
	_ args: VFGDependencyInjection.Args
) -> Void
