//
//  VFGReferAFriendSuccessProtocol.swift
//  VFGReferAFriend
//
//  Created by Mustafa Güneş on 29.01.2021.
//

import Foundation

/// Refer a friend success view model protocol.
public protocol VFGReferAFriendSuccessViewModelProtocol: AnyObject {
    /// The friend's name.
    var name: String? { get }
    /// Description.
    var description: String? { get }
    /// Referrals model.
    var referralsModel: VFGReferAFriendResponse? { get }
    /// Invitation type if *referAFriend or shareMyApp*.
    var inviteType: VFGReferAFriendInviteType { get }

    func create(
        with name: String?,
        description: String?,
        model: VFGReferAFriendResponse?,
        inviteType: VFGReferAFriendInviteType
    )
}
