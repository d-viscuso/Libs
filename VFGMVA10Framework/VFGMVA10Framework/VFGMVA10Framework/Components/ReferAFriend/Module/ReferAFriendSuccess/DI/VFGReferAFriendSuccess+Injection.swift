//
//  ReferAFriendSuccess+Injection.swift
//  VFGReferAFriend
//
//  Created by Mustafa Güneş on 29.01.2021.
//

import VFGMVA10Foundation

extension VFGDependencyInjection {
    class public func registerReferAFriendSuccess() {
        register { VFGReferAFriendViewController() }
        register { VFGReferAFriendSuccessViewController() }
        register { VFGReferAFriendSuccessViewModel() as VFGReferAFriendSuccessViewModelProtocol }
    }
}
