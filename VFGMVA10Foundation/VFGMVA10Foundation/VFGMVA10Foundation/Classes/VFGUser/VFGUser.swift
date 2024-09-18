//
//  VFGUser.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 11/3/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

/// `VFGUserDataPersistingDelegate` is abstract protocol to save and retrieve user data.
public protocol VFGUserDataPersistingDelegate: AnyObject {
    func saveType(type: VFGUserType)
    func retrieveType() -> VFGUserType
    func saveAccounts(accounts: [VFGAccount])
    func retrieveAccounts() -> [VFGAccount]
}

/// `VFGUser` is a class to manage user's account(s).
open class VFGUser {
    /// Shared instance of the VFGUser.
    public static let shared = VFGUser()
    /// Delegate for the *VFGUserDataPersistingDelegate* protocol.
    public weak var delegate: VFGUserDataPersistingDelegate?
    ///  Enable saving the selected account
    public var isSavingSelectedAccountEnable = true
    let userLoginTypeKey = "VFGUserLoginType"
    let selectedAccountKey = "VFGUserSelectedAccount"

    private init() {}

    var tempType: VFGUserType = .payM
    /// User type of the current instance, you can get and set the value of this property.
    public var type: VFGUserType {
        get {
            delegate?.retrieveType() ?? tempType
        }
        set {
            delegate?.saveType(type: newValue)
            tempType = newValue
        }
    }

    var tempAccounts: [VFGAccount] = []
    /// List of VFGAccount retrieved from the provided delegate.
    public var accounts: [VFGAccount] {
        get {
            delegate?.retrieveAccounts() ?? tempAccounts
        }
        set {
            delegate?.saveAccounts(accounts: newValue)
            tempAccounts = newValue
        }
    }

    /// List of the related accounts of the current instance.
    public var relatedAccount: [VFGAccount] = []
    /// Type of login used for this user.
    public var loginType: String? {
        get {
            UserDefaults.standard.string(forKey: userLoginTypeKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userLoginTypeKey)
        }
    }

    /// Selects account of the provided index.
    public func selectAccount(at index: Int) {
        guard isSavingSelectedAccountEnable else { return }
        UserDefaults.standard.set(index, forKey: selectedAccountKey)
    }

    /// Returns the selected account.
    public func selectedAccount() -> VFGAccount? {
        // when *isSavingSelectedAccountEnable* is false the index with .zero is a default value to take the first item of accounts list.
        let index = isSavingSelectedAccountEnable ? UserDefaults.standard.integer(forKey: selectedAccountKey) : .zero
        guard !accounts.isEmpty,
            0..<accounts.count ~= index else { return nil }
        return accounts[index]
    }

    /// Switches to a specific account.
    /// - Parameters:
    ///   - account: The account that would be switched to.
    ///   - delay: Delays in seconds, it is 3 by default.
    ///   - completion: Get notified when switch is done.
    public func switchTo(
        account: VFGAccount,
        delay: Double = 3,
        completion: @escaping () -> Void
    ) {
        guard let index = VFGUser.shared.accounts.firstIndex(where: { $0.name == account.name }) else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else {
                completion()
                return
            }

            self.selectAccount(at: index)
            completion()
        }
    }

    /// Set this to true if you want to limit user's access.
    /// - You can set and get it's value depending on your needs.
    /// - This is false by default.
    public var isLimitedUser = false
}
