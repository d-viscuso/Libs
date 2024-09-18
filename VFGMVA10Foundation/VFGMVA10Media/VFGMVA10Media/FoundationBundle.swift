//
//  FoundationBundle.swift
//  VFGMVA10Media
//
//  Created by Yahya Saddiq on 3/10/21.
//

let foundation = Bundle.allFrameworks.first {
    ($0.infoDictionary?["CFBundleExecutable"] as? String)?.contains("VFGMVA10Foundation") ?? false
}
