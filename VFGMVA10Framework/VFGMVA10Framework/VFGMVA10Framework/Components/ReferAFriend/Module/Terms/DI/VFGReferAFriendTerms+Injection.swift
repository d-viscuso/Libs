//
//  VFGReferAFriendTerms+Injection.swift
//  VFGReferAFriend
//
//  Created by Mustafa Güneş on 27.01.2021.
//

import VFGMVA10Foundation

extension VFGDependencyInjection {
    class public func registerReferAFriendTerms() {
        register { VFGReferAFriendTermsViewModel() as VFGReferAFriendTermsViewModelProtocol }
    }
}
