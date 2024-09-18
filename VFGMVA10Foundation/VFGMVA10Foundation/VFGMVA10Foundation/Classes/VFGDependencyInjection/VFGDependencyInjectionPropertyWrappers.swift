//
//  VFGDependencyInjectionPropertyWrappers.swift
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

#if swift(>=5.1)
/// Immediate injection property wrapper.
///
/// Wrapped dependent service is resolved immediately using VFGDependencyInjection.root upon struct initialization.
///
@propertyWrapper
public struct Injected<Service> {
	private var service: Service
	public init() {
		self.service = VFGDependencyInjection.resolve(Service.self)
	}
	public init(name: VFGDependencyInjection.Name? = nil, container: VFGDependencyInjection? = nil) {
		self.service = container?.resolve(
			Service.self,
			name: name
		) ?? VFGDependencyInjection.resolve(Service.self, name: name)
	}
	public var wrappedValue: Service {
		get { return service }
		mutating set { service = newValue }
	}
	public var projectedValue: Injected<Service> {
		get { return self }
		mutating set { self = newValue }
	}
}

/// OptionalInjected property wrapper.
///
/// If available, wrapped dependent service is resolved immediately using VFGDependencyInjection.root upon struct initialization.
///
@propertyWrapper
public struct OptionalInjected<Service> {
	private var service: Service?
	public init() {
		self.service = VFGDependencyInjection.optional(Service.self)
	}
	public init(name: VFGDependencyInjection.Name? = nil, container: VFGDependencyInjection? = nil) {
		self.service = container?.optional(
			Service.self,
			name: name
		) ?? VFGDependencyInjection.optional(Service.self, name: name)
	}
	public var wrappedValue: Service? {
		get { return service }
		mutating set { service = newValue }
	}
	public var projectedValue: OptionalInjected<Service> {
		get { return self }
		mutating set { self = newValue }
	}
}

/// Lazy injection property wrapper. Note that embedded container and name properties will be used if set prior to service instantiation.
///
/// Wrapped dependent service is not resolved until service is accessed.
///
@propertyWrapper
public struct LazyInjected<Service> {
	private var initialize = true
	private var service: Service?
	public var container: VFGDependencyInjection?
	public var name: VFGDependencyInjection.Name?
	public var args: Any?
	public init() {}
	public init(name: VFGDependencyInjection.Name? = nil, container: VFGDependencyInjection? = nil) {
		self.name = name
		self.container = container
	}
	public var isEmpty: Bool {
		return service == nil
	}
	public var wrappedValue: Service? {
		mutating get {
			if initialize {
				self.initialize = false
				self.service = container?.resolve(
					Service.self,
					name: name,
					args: args
				) ?? VFGDependencyInjection.resolve(Service.self, name: name, args: args)
			}
			return service
		}
		mutating set { service = newValue }
	}
	public var projectedValue: LazyInjected<Service> {
		get { return self }
		mutating set { self = newValue }
	}
	public mutating func release() {
		self.service = nil
	}
}

/// Weak lazy injection property wrapper. Note that embedded container and name properties will be used if set prior to service instantiation.
///
/// Wrapped dependent service is not resolved until service is accessed.
///
@propertyWrapper
public struct WeakLazyInjected<Service> {
	private var initialize = true
	private weak var service: AnyObject?
	public var container: VFGDependencyInjection?
	public var name: VFGDependencyInjection.Name?
	public var args: Any?
	public init() {}
	public init(name: VFGDependencyInjection.Name? = nil, container: VFGDependencyInjection? = nil) {
		self.name = name
		self.container = container
	}
	public var isEmpty: Bool {
		return service == nil
	}
	public var wrappedValue: Service? {
		mutating get {
			if initialize {
				self.initialize = false
				let service = container?.resolve(
					Service.self,
					name: name,
					args: args
				) ?? VFGDependencyInjection.resolve(Service.self, name: name, args: args)
				self.service = service as AnyObject
				return service
			}
			return service as? Service
		}
		mutating set { service = newValue as AnyObject }
	}
	public var projectedValue: WeakLazyInjected<Service> {
		get { return self }
		mutating set { self = newValue }
	}
}

#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
/// Immediate injection property wrapper for SwiftUI ObservableObjects. This wrapper is meant for use in SwiftUI Views and exposes
/// bindable objects similar to that of SwiftUI @observedObject and @environmentObject.
///
/// Dependent service must be of type ObservableObject. Updating object state will trigger view update.
///
/// Wrapped dependent service is resolved immediately using VFGDependencyInjection.root upon struct initialization.
///
@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct InjectedObject<Service>: DynamicProperty where Service: ObservableObject {
	@ObservedObject private var service: Service
	public init() {
		self.service = VFGDependencyInjection.resolve(Service.self)
	}
	public init(name: VFGDependencyInjection.Name? = nil, container: VFGDependencyInjection? = nil) {
		self.service = container?.resolve(
			Service.self,
			name: name
		) ?? VFGDependencyInjection.resolve(Service.self, name: name)
	}
	public var wrappedValue: Service {
		get { return service }
		mutating set { service = newValue }
	}
	public var projectedValue: ObservedObject<Service>.Wrapper {
		return self.$service
	}
}
#endif
#endif
