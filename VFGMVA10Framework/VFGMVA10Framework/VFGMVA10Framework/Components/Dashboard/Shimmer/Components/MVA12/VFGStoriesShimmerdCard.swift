//
//  StoriesShimmerdCard.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 01/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Dashboard fourth card shimmer entry
public class VFGStoriesShimmerdCard: NSObject, VFGComponentEntry {
    public required init(config: [String: Any]?, error: [String: Any]?) {}

    public lazy var cardView: UIView? = {
        let view = VFGStoryContainerCard()
        view.storiesLayout = .circle
        view.state = .loading
        return view
    }()

    public var cardEntryViewController: UIViewController? {
        return nil
    }
}
