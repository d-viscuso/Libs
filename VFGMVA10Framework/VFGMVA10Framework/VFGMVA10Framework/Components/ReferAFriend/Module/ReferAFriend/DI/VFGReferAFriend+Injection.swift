//
//  VFGReferAFriend+Injection.swift
//  VFGReferAFriend
//
//  Created by Mustafa Güneş on 13.01.2021.
//

import VFGMVA10Foundation

extension VFGDependencyInjection {
    class public func registerReferAFriend() {
        register { VFGReferAFriendTermsViewController() }
        register { VFGReferAFriendViewModel() as VFGReferAFriendViewModelProtocol }
    }
}
