//
//  MVA10Player.swift
//  VFGMVA10Group
//
//  Created by Sandra Morcos on 5/21/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import AVKit
/// A video Player that use embedded in  videoViewController
open class MVA10Player: AVPlayer {
    /// A Boolean that use to check if video preview is silent or not 
    public override var isMuted: Bool {
        didSet {
            let options: AVAudioSession.CategoryOptions = isMuted ? [.mixWithOthers] : []
            try? AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .moviePlayback,
                options: options)
        }
    }
}
