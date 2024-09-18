//
//  Array+VFGComponentEntries.swift
//  VFGMVA10Group
//
//  Created by Tomasz Czyżak on 09/07/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

extension Dictionary where Key == String {
    func component(with componentId: String, metaData: [String: Any]?, error: [String: Any]?) -> VFGComponentEntry? {
        guard let componentEntry = self[componentId] as? VFGComponentEntry.Type else {
            VFGErrorLog("Not found componentId:\(String(describing: componentId))")
            return nil
        }
        return componentEntry.init(config: metaData, error: error)
    }

    /// Method used to initialized tray items *VFGTrayItemProtocol*.
    /// - Parameters:
    ///    - trayItemId: Tray item Id that we want to initialize.
    ///    - trayItemModel: Model of the tray item we want to initialize.
    /// - Returns: A Fully initialized *VFGTrayItemProtocol* if the *trayItemId* was found in *Dictionary* and *nil* if *trayItemId* wasn't found.
    public func trayItem(with trayItemId: String, trayItemModel: VFGTrayItemModel) -> VFGTrayItemProtocol? {
        guard let trayItem = self[trayItemId] as? VFGTrayItemProtocol.Type else {
            VFGErrorLog("Not found trayItemId:\(String(describing: trayItemId))")
            return nil
        }
        return trayItem.init(trayItemModel)
    }
}

extension Array {
    func vfgcForEachEnumerated(_ body: @escaping (_ offset: Int, _ element: Element) -> Void) {
        enumerated().forEach(body)
    }
    func vfgcToDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key: Element] {
        var dict: [Key: Element] = [:]
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}
