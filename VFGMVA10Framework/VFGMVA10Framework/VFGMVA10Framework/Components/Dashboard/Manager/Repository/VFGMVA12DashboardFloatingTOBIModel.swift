//
//  VFGMVA12DashboardFloatingTOBIModel.swift
//  VFGMVA10Framework
//
//  Created by Loodos on 9/28/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//
import VFGMVA10Foundation

/// MVA12 Dashboard Floating TOBI Model
public class VFGMVA12DashboardFloatingTOBIModel {
    /// Determine the TOBI set .
    public var face: VFGTOBISet?
    /// TOBI badge model.
    public var badgeModel: VFGFloatingTobiBadgeModelProtocol?
    /// TOBI message
    public var message: String?
    /// TOBI message
    public var isHidden = false
    /// TOBI view delegate
    public weak var delegate: VFGFloatingViewDelegate?
    /// remote image URL
    public var imageUrl: URL?
    /// tobi static image name
    public var imageName: String?

    public init(
        face: VFGTOBISet? = nil,
        badgeModel: VFGFloatingTobiBadgeModelProtocol? = nil,
        message: String? = nil,
        isHidden: Bool = false,
        delegate: VFGFloatingViewDelegate? = nil,
        imageUrl: URL? = nil,
        imageName: String? = nil
    ) {
        self.face = face
        self.badgeModel = badgeModel
        self.message = message
        self.isHidden = isHidden
        self.delegate = delegate
        self.imageUrl = imageUrl
        self.imageName = imageName
    }
}

public protocol VFGFloatingViewDelegate: AnyObject {
    /// TobiView did pressed.
    func tobiViewDidPressed()
}
