//
//  VFGStepAction.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 8/26/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

@objc public enum VFGStepAction: Int {
    case complete, skip, returnToPreviousStep, start
    case link // should marked as private
}

public enum VFGPreviousStepState {
    case completed
    case skipped
}
