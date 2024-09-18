//
//  VFGFunFactDelegate.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 09/02/2022.
//

import Foundation
import VFGMVA10Foundation

/// A protocol that used to inject model to fun fact and also to handle action happened in fun fact
public protocol VFGFunFactDelegate: AnyObject {
    var model: VFGFunFactModel { get }
    func funFactDidFinish()
    func funFactWillStart()
    func funFactScrollingDidChange(ratio: CGFloat)
}
public extension VFGFunFactDelegate {
    func funFactDidFinish() { }
    func funFactWillStart() { }
    func funFactScrollingDidChange(ratio: CGFloat) { }
}
