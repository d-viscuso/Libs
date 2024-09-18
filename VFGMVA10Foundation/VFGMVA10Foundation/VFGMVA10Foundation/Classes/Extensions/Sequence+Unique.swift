//
//  Sequence+Unique.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 5/11/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

public extension Sequence where Iterator.Element: Hashable {
    /// Returns unique version of the sequence.
    /// - Returns: A *[Element]* of unique elements.
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
