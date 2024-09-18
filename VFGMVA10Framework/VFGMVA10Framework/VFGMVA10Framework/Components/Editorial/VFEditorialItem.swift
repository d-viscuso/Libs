//
//  VFEditorialItem.swift
//  VFGMVA10Framework
//
//  Created by Hamsa Hassan on 10/31/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

/// Editorial Item Meta Data Enum
enum VFEditorialItemMetaDataKeys {
    static let title = "title"
    static let description = "description"
    static let image = "image"
    static let videoURLString = "videoURLString"
}

/// Editorial Item
public class VFEditorialItem: VFGComponentEntry, VFDashboardListEntryProtocol {
    /// Editorial Required Initializer
    /// - Parameters:
    ///    - config: Editorial view configurations
    ///    - error: Editorial error
    public required init(config: [String: Any]?, error: [String: Any]?) {
    }

    internal var editorialView: VFEditorialView?
    /// Editorial View
    public lazy var cardView: UIView? = {
        guard let editorialView: VFEditorialView =
            VFEditorialView.loadXib(bundle: Bundle.mva10Framework)
        else {
            return nil
        }
        editorialView.item = item
        self.editorialView = editorialView
        return editorialView.editorialSubView
    }()

    public var cardEntryViewController: UIViewController?

    public var item: VFGDashboardItem?

    public var showMoreHeight: CGFloat?

    public var showMoreAction: ((Bool) -> Void)?

    public var hasShowMore: Bool?

    /// Continue Playing the video inside Editorial View
    public func willDisplay() {
        guard let editorialVideo = editorialView?.video else {
            return
        }
        editorialVideo.player?.play()
    }

    /// Pause the video inside Editorial View
    public func didEndDisplay() {
        guard let editorialVideo = editorialView?.video else {
            return
        }
        editorialVideo.player?.pause()
    }

    /// Item Action inside Editorial View
    public func didSelectCard() {
        guard let editorialView = editorialView else {
            return
        }
        editorialView.itemAction?()
    }
}
