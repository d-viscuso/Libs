//
//  VFSectionHeader+Text.swift
//  VFGMVA10
//
//  Created by Tomasz Czyżak on 25/06/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension VFSectionHeader {
    /// Dashboard collection view section header greeting message
    var greetingMessageHeader: String {
        guard let model = eioModel?.model else { return "" }
        return "\(model.greeting ?? "") \(model.username ?? "")"
    }
    /// Dashboard collection view section header title
    var titleHeader: String {
        guard let model = eioModel?.model, let titleHeader = model.title else { return "" }
        return titleHeader
    }
    /// Dashboard collection view section header current state message
    var currentStateMessage: String? {
        guard let status = eioModel?.eioStatus, !(eioModel is VFGDisableEIO) else { return nil }
        switch status {
        case .success:
            return Constants.eiokSuccessMessage
        case .failed:
            return Constants.eiokErrorMessage
        case .inProgress:
            return Constants.eiokProgressMessage
        }
    }
}
