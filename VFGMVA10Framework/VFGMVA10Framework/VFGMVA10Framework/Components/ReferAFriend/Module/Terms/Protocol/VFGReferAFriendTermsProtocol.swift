//
//  VFGReferAFriendTermsProtocol.swift
//  VFGReferAFriend
//
//  Created by Mustafa Güneş on 27.01.2021.
//

import Foundation

/// Refer a friend terms view model protocol.
public protocol VFGReferAFriendTermsViewModelProtocol: AnyObject {
    /// Terms and conditions text.
    var termsText: String? { get set }
    /// Method to set *termsText*.
    func create(with text: String?)
}
