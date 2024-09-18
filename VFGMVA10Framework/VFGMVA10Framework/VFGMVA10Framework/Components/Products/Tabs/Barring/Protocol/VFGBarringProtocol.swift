//
//  VFGBarringProtocol.swift
//  VFGMVA10Framework
//
//  Created by Trachani, Vasiliki, Vodafone on 17/5/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
/// Barring protocol.
public protocol VFGBarringProtocol: AnyObject {
    /// Determines whether permissions title should be hidden or not
    var isBarringTitleHidden: Bool? { get }

    /// Action that occures when you press on confirm button in ask changes permission screen.
    /// - Parameters:
    ///     - id: Current barring ID.
    ///     - completion: Completion of a boolean that it's true if the change succeeded and false if it didn't.
    func confirmButtonAction(
        id: String?,
        completion: @escaping (Bool?) -> Void
    )

    /// Action that occures when you finish the change permission journey
    /// - Parameters:
    ///     - isDismissed: Boolean to dermine if it should dismiss the screen or not.
    func didFinish(isDismissed: Bool)

    /// Determines whether permissions list should be refreshed or not
    var isBarringListRefreshing: Bool? { get }
}

extension VFGBarringProtocol {
    public var isBarringTitleHidden: Bool? { false }
    public var permissionsDetailsTitle: String? { "" }
    public var isBarringListRefreshing: Bool? { true }
}
