//
//  VFGDashboardTrayModel.swift
//  VFGMVA10Group
//
//  Created by Sandra Morcos on 8/8/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//
import UIKit
import VFGMVA10Foundation

public class VFGDashboardTrayModel: VFGTrayModelProtocol {
    weak public var trayDelegate: VFGTrayManagerProtocol?

    public var trayItems: [VFGTrayItemProtocol] = []
    public var isTobiEnabled: Bool?
    var fileName: String?

    public init() {
        fileName = ""
    }

    public init?(fileName: String) {
        self.fileName = fileName
    }

    public func setup() {
        loadTrayStubs(filePath: fileName)
    }

    internal func loadTrayStubs(filePath: String?) {
        guard let filePath = filePath else {
            let error = URLError(.fileDoesNotExist)
            trayDelegate?.traySetupFinished(error: error)
            return
        }

        let url = URL(fileURLWithPath: filePath)
        do {
            let jsonData = try Data(contentsOf: url, options: .mappedIfSafe)
            let trayModel = try JSONDecoder().decode(VFGTrayModel.self, from: jsonData)
            loadItems(from: trayModel) { items in
                trayItems = items
                isTobiEnabled = VFGManagerFramework.tobiDelegate?.isTOBIEnabled()
                DispatchQueue.main.async {
                    self.trayDelegate?.traySetupFinished(error: nil)
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.trayDelegate?.traySetupFinished(error: error)
            }
            return
        }
    }

    public func loadItems(
        from trayModel: VFGTrayModel,
        completion: ([VFGTrayItemProtocol]) -> Void
    ) {
        var itemsArray: [VFGTrayItemProtocol] = []
        if let items = trayModel.items {
            for item in items {
                if let itemID = item.title,
                    let trayItem = VFGManagerFramework
                    .trayDelegate?
                    .trayItemsEntries()
                    .trayItem(with: itemID, trayItemModel: item) {
                    itemsArray.append(trayItem)
                } else {
                    itemsArray.append(VFGTrayItem(item))
                }
            }
        }
        completion(itemsArray)
    }
}
