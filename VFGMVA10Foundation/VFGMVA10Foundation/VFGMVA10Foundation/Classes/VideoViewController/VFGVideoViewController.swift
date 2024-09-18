//
//  VFGVideoViewController.swift
//  VFGMVA10
//
//  Created by Mohamed Mahmoud Zaki on 1/17/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import AVKit

/// A video Controller that use to play  video mp4
open class VFGVideoViewController: AVPlayerViewController {
    /// AV player that use to play video
    public var avplayer: MVA10Player?
    /// Bundle that video will display from
    public var bundle: Bundle = .main
    /// Remote video url that will be played
    public var videoURLString: String?
    /// Local video url that will be played
    public var localVideoString: String? {
        didSet {
            guard let path = bundle.path(forResource: localVideoString, ofType: "mp4") else {
                VFGDebugLog("video.mp4 not found")
                return
            }
            let videoURL = URL(fileURLWithPath: path)
            avplayer = MVA10Player(url: videoURL)
            hideControls()
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        guard let videoURL = URL(string: videoURLString ?? "") else {
            return
        }
        avplayer = MVA10Player(url: videoURL)
        hideControls()
    }
    /// hide all controls for video preview 
    func hideControls() {
        avplayer?.isMuted = true
        showsPlaybackControls = false
        player = avplayer
    }
}
