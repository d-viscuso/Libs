//
//  CustomizableTertiaryTileBottom.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 06/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// A class that is used to customize bottom tertiary tiles in dashboard
/// by providing a component entry of your choice that conform to *VFGComponentEntry*
public class CustomizableTertiaryTileBottom: CustomizableTertiaryTileProtocol {
    var componentEntry: VFGComponentEntry?
    /// A closure used to get current component entry type to initialize it later once the *CustomizableTertiaryTileBottom* get initialized.
    /// You should use this closure to provide a component entry that would appear as bottom tertiary tiles in dashboard.
    public static var getCurrentComponentEntry: (() -> VFGComponentEntry.Type)?

    /// *CustomizableTertiaryTileBottom* initializer.
    /// - Parameters:
    ///   - config: A dictionary that holds any additional metadata that you might use to configure your entry component.
    ///   - error: A dictionary that holds error message if it exists.
    required public init(config: [String: Any]?, error: [String: Any]?) {
        let componentEntryType = CustomizableTertiaryTileBottom.getCurrentComponentEntry?()
        if let componentEntryType = componentEntryType {
            componentEntry = componentEntryType.init(config: config, error: error)
        }
    }
}
