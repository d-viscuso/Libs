//
//  Bundle+VFGStory.swift
//  VFGStory
//
//  Created by Abdullah Soylemez on 13.01.2021.
//

import Foundation

public extension Bundle {
	static var vfgStory: Bundle {
		return Bundle(for: VFGStoryContainerCard.self)
	}
}
