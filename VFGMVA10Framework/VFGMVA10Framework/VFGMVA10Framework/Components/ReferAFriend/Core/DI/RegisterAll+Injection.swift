//
//  RegisterAll+Injection.swift
//  VFGReferAFriend
//
//  Created by Mustafa Güneş on 13.01.2021.
//

import VFGMVA10Foundation

extension VFGDependencyInjection: VFGDependencyInjectionRegistering {
    public static func registerAllServices() {
        registerReferAFriend()
        registerReferAFriendTerms()
        registerReferAFriendSuccess()
    }
}
