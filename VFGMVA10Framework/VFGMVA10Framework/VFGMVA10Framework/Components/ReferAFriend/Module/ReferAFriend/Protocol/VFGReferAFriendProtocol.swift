//
//  VFGReferAFriendProtocol.swift
//  VFGReferAFriend
//
//  Created by Mustafa Güneş on 13.01.2021.
//

import Foundation

/// Refer a friend data provider protocol.
public protocol VFGReferAFriendDataProviderProtocol: AnyObject {
    /// Method to fetch refer a friend data.
    /// - Parameters:
    ///     - completion: Completion of *VFGReferAFriendResponse* in case of success fetching and *Error* in case of failure to fetch the data.
    func fetchReferAFriendData(completion: @escaping (VFGReferAFriendResponse?, Error?) -> Void)
}

/// Refer a friend view model protocol.
public protocol VFGReferAFriendViewModelProtocol: AnyObject {
    /// Referrals model.
    var referralsModel: VFGReferAFriendResponse? { get set }
    /// Invitation type if *referAFriend or shareMyApp*.
    var inviteType: VFGReferAFriendInviteType { get set }

    func create(with model: VFGReferAFriendResponse?, inviteType: VFGReferAFriendInviteType)
}
