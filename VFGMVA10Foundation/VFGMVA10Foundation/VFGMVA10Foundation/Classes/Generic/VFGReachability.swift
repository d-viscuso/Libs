/*
Copyright (c) 2014, Ashley Mills
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
*/

// Cocoapods ReachabilitySwift version 4.3.0 renamed to VFGReachability + some modifications

import SystemConfiguration
import Foundation

/// `ReachabilityError` is public Error interface to handle errors from **VFGReachability** class.
public enum ReachabilityError: Error {
    /// Failed to create object from Socket address.
    /// - parameter sockaddr_in: Socket address, internet style.
    case failedToCreateWithAddress(sockaddr_in)
    /// Failed to create object with the host name.
    /// - parameter String: Host name.
    case failedToCreateWithHostname(String)
    /// Unable to set a callback.
    case unableToSetCallback
    /// Unable to set a DispatchQueue.
    case unableToSetDispatchQueue
    /// Unable to get initial flag.
    case unableToGetInitialFlags
}

public extension Notification.Name {
    /// Notification name of the VFGReachability change.
    static let vfgReachabilityChanged = Notification.Name("reachabilityChanged")
}

public protocol VFGReachabilityProtocol {
    /// User current connection.
    var connection: VFGReachability.Connection { get }
}

/// `VFGReachability` is public class to handle user reachability to the internet.
public class VFGReachability {
    /// Callback that returns a VFGReachability.
    public typealias NetworkReachable = (VFGReachability) -> Void
    /// Callback that returns a VFGReachability.
    public typealias NetworkUnreachable = (VFGReachability) -> Void
    /// Public enum that wraps different connection types.
    public enum Connection: CustomStringConvertible {
        case none, wifi, cellular
        public var description: String {
            switch self {
            case .cellular: return "Cellular"
            case .wifi: return "WiFi"
            case .none: return "No Connection"
            }
        }
    }

    /// Callback that get triggered when network is reachable.
    public var whenReachable: NetworkReachable?
    /// Callback that get triggered when network is unreachable.
    public var whenUnreachable: NetworkUnreachable?

    /// Set to `false` to force Reachability.connection to .none when on cellular connection (default value `true`)
    public var allowsCellularConnection: Bool

    // The notification center on which "reachability changed" events are being posted
    public var notificationCenter = NotificationCenter.default
    private var isRunningOnDevice: Bool = {
        #if targetEnvironment(simulator)
            return false
        #else
            return true
        #endif
    }()

    private var notifierRunning = false
    private let reachabilityRef: SCNetworkReachability
    private let reachabilitySerialQueue: DispatchQueue
    private(set) var flags: SCNetworkReachabilityFlags? {
        didSet {
            guard flags != oldValue else { return }
            reachabilityChanged()
        }
    }

    /// Creates new instance depending in the given parameters.
    /// - Parameters:
    ///    - reachabilityRef: The handle to a network address or name..
    ///    - queueQoS: The quality-of-service level to associate with the queue.
    ///    - targetQueue: The target queue on which to execute blocks.
    required public init(
        reachabilityRef: SCNetworkReachability,
        queueQoS: DispatchQoS = .default,
        targetQueue: DispatchQueue? = nil
    ) {
        self.allowsCellularConnection = true
        self.reachabilityRef = reachabilityRef
        self.reachabilitySerialQueue = DispatchQueue(
            label: "uk.co.ashleymills.reachability",
            qos: queueQoS,
            target: targetQueue
        )
    }

    /// Convenience initializer that creates new instance depending in the given parameters.
    /// - Parameters:
    ///    - hostname: Name of the desired host.
    ///    - queueQoS: The quality-of-service level to associate with the queue, it is '.default' by default.
    ///    - targetQueue: The target queue on which to execute blocks.
    public convenience init?(hostname: String, queueQoS: DispatchQoS = .default, targetQueue: DispatchQueue? = nil) {
        guard let ref = SCNetworkReachabilityCreateWithName(nil, hostname) else { return nil }
        self.init(reachabilityRef: ref, queueQoS: queueQoS, targetQueue: targetQueue)
    }

    /// Convenience initializer that creates new instance depending in the given parameters.
    /// - Parameters:
    ///    - queueQoS: The quality-of-service level to associate with the queue, it is '.default' by default.
    ///    - targetQueue: The target queue on which to execute blocks.
    public convenience init?(queueQoS: DispatchQoS = .default, targetQueue: DispatchQueue? = nil) {
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)

        guard let ref = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress) else { return nil }

        self.init(reachabilityRef: ref, queueQoS: queueQoS, targetQueue: targetQueue)
    }

    deinit {
        stopNotifier()
    }
}

public extension VFGReachability {
    // MARK: - *** Notifier methods ***
    /// Starts the notifier.
    /// - Throws: A *ReachabilityError* if anything goes wrong.
    func startNotifier() throws {
        guard !notifierRunning else { return }

        let callback: SCNetworkReachabilityCallBack = { reachability, flags, info in
            guard let info = info else { return }

            let reachability = Unmanaged<VFGReachability>.fromOpaque(info).takeUnretainedValue()
            reachability.flags = flags
        }

        var context = SCNetworkReachabilityContext(
            version: 0,
            info: nil,
            retain: nil,
            release: nil,
            copyDescription: nil
        )
        context.info = UnsafeMutableRawPointer(Unmanaged<VFGReachability>.passUnretained(self).toOpaque())
        if !SCNetworkReachabilitySetCallback(reachabilityRef, callback, &context) {
            stopNotifier()
            throw ReachabilityError.unableToSetCallback
        }

        if !SCNetworkReachabilitySetDispatchQueue(reachabilityRef, reachabilitySerialQueue) {
            stopNotifier()
            throw ReachabilityError.unableToSetDispatchQueue
        }

        // Perform an initial check
        try setReachabilityFlags()

        notifierRunning = true
    }

    /// Stops the notifier.
    func stopNotifier() {
        defer { notifierRunning = false }

        SCNetworkReachabilitySetCallback(reachabilityRef, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachabilityRef, nil)
    }

    // MARK: - *** Connection test methods ***
    var description: String {
        guard let flags = flags else { return "unavailable flags" }

        let isW = isRunningOnDevice ? (flags.isOnWWANFlagSet ? "W" : "-") : "X"
        let isR = flags.isReachableFlagSet ? "R" : "-"
        let isCR = flags.isConnectionRequiredFlagSet ? "c" : "-"
        let isT = flags.isTransientConnectionFlagSet ? "t" : "-"
        let isI = flags.isInterventionRequiredFlagSet ? "i" : "-"
        let isC = flags.isConnectionOnTrafficFlagSet ? "C" : "-"
        let isD = flags.isConnectionOnDemandFlagSet ? "D" : "-"
        let isL = flags.isLocalAddressFlagSet ? "l" : "-"
        let isDF = flags.isDirectFlagSet ? "d" : "-"

        return "\(isW)\(isR) \(isCR)\(isT)\(isI)\(isC)\(isD)\(isL)\(isDF)"
    }
}

private extension VFGReachability {
    /// Sets reachability flags that indicate the reachability of a network node name or address.
    /// - Throws: A *ReachabilityError* if any thing goes wrong.
    func setReachabilityFlags() throws {
        try reachabilitySerialQueue.sync { [unowned self] in
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags) {
                self.stopNotifier()
                throw ReachabilityError.unableToGetInitialFlags
            }

            self.flags = flags
        }
    }

    /// This function should be called when reachability flags did change.
    func reachabilityChanged() {
        let block = connection != .none ? whenReachable : whenUnreachable

        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            block?(strongSelf)
            strongSelf.notificationCenter.post(name: .vfgReachabilityChanged, object: strongSelf)
        }
    }
}

extension SCNetworkReachabilityFlags {
    typealias Connection = VFGReachability.Connection

    var connection: Connection {
        guard isReachableFlagSet else { return .none }

        // If we're reachable, but not on an iOS device (i.e. simulator), we must be on WiFi
        #if targetEnvironment(simulator)
        return .wifi
        #else
        var connection = Connection.none

        if !isConnectionRequiredFlagSet {
            connection = .wifi
        }

        if isConnectionOnTrafficOrDemandFlagSet {
            if !isInterventionRequiredFlagSet {
                connection = .wifi
            }
        }

        if isOnWWANFlagSet {
            connection = .cellular
        }

        return connection
        #endif
    }

    var isOnWWANFlagSet: Bool {
        #if os(iOS)
        return contains(.isWWAN)
        #else
        return false
        #endif
    }
    var isReachableFlagSet: Bool {
        return contains(.reachable)
    }
    var isConnectionRequiredFlagSet: Bool {
        return contains(.connectionRequired)
    }
    var isInterventionRequiredFlagSet: Bool {
        return contains(.interventionRequired)
    }
    var isConnectionOnTrafficFlagSet: Bool {
        return contains(.connectionOnTraffic)
    }
    var isConnectionOnDemandFlagSet: Bool {
        return contains(.connectionOnDemand)
    }
    var isConnectionOnTrafficOrDemandFlagSet: Bool {
        return !intersection([.connectionOnTraffic, .connectionOnDemand]).isEmpty
    }
    var isTransientConnectionFlagSet: Bool {
        return contains(.transientConnection)
    }
    var isLocalAddressFlagSet: Bool {
        return contains(.isLocalAddress)
    }
    var isDirectFlagSet: Bool {
        return contains(.isDirect)
    }
    var isConnectionRequiredAndTransientFlagSet: Bool {
        return intersection([.connectionRequired, .transientConnection]) == [.connectionRequired, .transientConnection]
    }
}

extension VFGReachability: VFGReachabilityProtocol {
    public var connection: VFGReachability.Connection {
        if flags == nil {
            try? setReachabilityFlags()
        }

        switch flags?.connection {
        case .none?, nil: return .none
        case .cellular?: return allowsCellularConnection ? .cellular : .none
        case .wifi?: return .wifi
        }
    }
}
