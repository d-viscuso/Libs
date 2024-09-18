//
//  UITabBarController+VFGTrayModelProtocol.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 2/18/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

extension UITabBarController: VFGTrayContainerProtocol {
    public var tobiKey: String {
        String(describing: type(of: self))
    }

    public var trayStyle: VFGTrayStyle {
        .trayWithTOBI
    }
}

extension UITabBarController: VFGTrayModelProtocol {
    public var trayDelegate: VFGTrayManagerProtocol? {
        get {
            nil
        }
        set {
            _ = newValue
        }
    }

    public var trayItems: [VFGTrayItemProtocol] {
        var itemsArr: [VFGTrayItemProtocol] = []
        guard let viewControllers = viewControllers, !(viewControllers.isEmpty) else {
            return []
        }
        for (index, viewController) in viewControllers.enumerated() {
            var item = VFGTrayItemModel(
                title: tabBar.items?[index].title,
                iconName: nil,
                subTrayID: nil,
                trayActionKey: nil,
                badge: nil,
                imageData: tabBar.items?[index].image?.jpegData(compressionQuality: 1.0))
            item.trayAction = { [weak self] in self?.selectedIndex = index }
            let trayItem = VFGTrayItem(item)
            trayItem.screenForItem = viewController
            itemsArr.append(trayItem)
        }
        return itemsArr
    }

    public var isTobiEnabled: Bool? {
        false
    }

    public func setup() {
    }
}
