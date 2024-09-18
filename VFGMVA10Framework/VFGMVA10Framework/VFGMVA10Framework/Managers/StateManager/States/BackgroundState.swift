//
//  BackgroundState.swift
//  VFGMVA10
//
//  Created by Tomasz Czyżak on 13/06/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

/// Background state.
public class BackgroundState: CoreState {
    public override func isValidNextState(_ stateClass: AppStateDelegate.Type) -> Bool {
        return true
    }
}
