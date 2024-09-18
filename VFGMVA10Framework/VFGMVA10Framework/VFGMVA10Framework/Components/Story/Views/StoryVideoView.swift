//
//  StoryVideoView.swift
//  VFGStory
//
//  Created by Abdullah Soylemez on 29.01.2021.
//

import AVKit
import UIKit
import VFGMVA10Foundation

// MARK: - StoryVideoPlayerStatus
/// Story video player states
enum StoryVideoPlayerStatus {
	case unknown
	case playing
	case failed
	case paused
	case readyToPlay
}

// MARK: - StoryVideoViewDelegate
/// Delegation protocol for *StoryVideoView* actions
protocol StoryVideoViewDelegate: AnyObject {
	func storyVideoViewDidStartPlaying(_ storyVideoView: StoryVideoView)
	func storyVideoViewDidCompletePlay(_ storyVideoView: StoryVideoView)
	func storyVideoView(_ storyVideoView: StoryVideoView, didTrack progress: Float)
	func storyVideoView(_ storyVideoView: StoryVideoView, didFailedWith error: String, for url: URL?)
}

// MARK: - StoryVideoPlayerControls
/// *StoryVideoView* player controls
protocol StoryVideoPlayerControls: AnyObject {
    /// Play story video
    /// - Parameters:
    ///    - resource: Story video resource
	func play(with resource: String)
    /// Play story video
	func play()
    /// Pause story video
	func pause()
    /// Stop story video
	func stop()
    /// Story video status
	var playerStatus: StoryVideoPlayerStatus { get }
}

// MARK: - StoryVideoView
/// Story View with video to display
class StoryVideoView: UIView {
	// MARK: - Private variables
	private var timeObserverToken: AnyObject?
	private var playerItemStatusObserver: NSKeyValueObservation?
	private var playerTimeControlStatusObserver: NSKeyValueObservation?
	private var outputVolumeObserver: NSKeyValueObservation?
	private var playerLayer: AVPlayerLayer?
	private var playerItem: AVPlayerItem? {
		willSet {
			// Remove any previous KVO observer.
			guard let playerItemStatusObserver = playerItemStatusObserver else { return }
			playerItemStatusObserver.invalidate()
		}
		didSet {
			player?.replaceCurrentItem(with: playerItem)
			playerItemStatusObserver = playerItem?.observe(
				\AVPlayerItem.status,
				options: [.new, .initial]
			) { [weak self] item, _ in
				guard let self = self else { return }
				if item.status == .failed {
                    self.activityIndicator?.stopAnimating()
					if let item = self.player?.currentItem, let error = item.error, let url = item.asset as? AVURLAsset {
						self.playerObserverDelegate?.storyVideoView(self, didFailedWith: error.localizedDescription, for: url.url)
					} else {
						self.playerObserverDelegate?.storyVideoView(self, didFailedWith: "Unknown error", for: nil)
					}
				}
			}
		}
	}
	private var isSessionCategorySet = false

	// MARK: - Variables
    /// Story video player
	var player: AVPlayer? {
		willSet {
			// Remove any previous KVO observer.
			guard let playerTimeControlStatusObserver = playerTimeControlStatusObserver else { return }
			playerTimeControlStatusObserver.invalidate()
		}
		didSet {
			playerTimeControlStatusObserver = player?.observe(
				\AVPlayer.timeControlStatus,
				options: [.new, .initial]
			) { [weak self] player, _ in
				guard let self = self else { return }
				if player.timeControlStatus == .playing {
					// Started Playing
                    self.activityIndicator?.stopAnimating()
					self.playerObserverDelegate?.storyVideoViewDidStartPlaying(self)
				} else if player.timeControlStatus == .paused {
					// player paused
				} else {
					//
				}
			}
		}
	}
    /// The error that caused the player item to fail
	var error: Error? {
		return player?.currentItem?.error
	}
    /// A view that shows that a task is in progress
	var activityIndicator: UIActivityIndicatorView?
    /// The current player item
	var currentItem: AVPlayerItem? {
		return player?.currentItem
	}
    /// The current time value of the current player item
	var currentTime: Float {
		return Float(player?.currentTime().value ?? 0)
	}

	// MARK: - Public variables
    /// Delegation protocol for *StoryVideoView* actions
	public weak var playerObserverDelegate: StoryVideoViewDelegate?

	// MARK: - Lifecycle
	override func awakeFromNib() {
		super.awakeFromNib()

        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .large)
        } else {
            activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        }
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
		setupActivityIndicator()
		setupOutputVolumeObserver()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		playerLayer?.frame = bounds
	}

	deinit {
		if let existingPlayer = player, existingPlayer.observationInfo != nil {
			removeObservers()
		}
	}

	// MARK: - Public functions
    /// Start activity indicator animation
	func startAnimating() {
        activityIndicator?.isHidden = false
        activityIndicator?.startAnimating()
	}
    /// Stop activity indicator animation
	func stopAnimating() {
        activityIndicator?.stopAnimating()
	}

	// MARK: - Private functions
	private func setupActivityIndicator() {
        guard let activityIndicator = activityIndicator
            else { return }
        activityIndicator.hidesWhenStopped = true
		// backgroundColor = UIColor.rgb(from: 0xEDF0F1)
		backgroundColor = .black
		addSubview(activityIndicator)
		NSLayoutConstraint.activate([
			activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}

	private func removeObservers() {
		cleanUpPlayerPeriodicTimeObserver()
		cleanUpOutputVolumeObserver()
	}

	private func cleanUpPlayerPeriodicTimeObserver() {
		if let timeObserverToken = timeObserverToken {
			player?.removeTimeObserver(timeObserverToken)
			self.timeObserverToken = nil
		}
	}

	private func setupPlayerPeriodicTimeObserver() {
		// Only add the time observer if one hasn't been created yet.
		guard timeObserverToken == nil else { return }

		// Use a weak self variable to avoid a retain cycle in the block.
		timeObserverToken =
			player?.addPeriodicTimeObserver(
				forInterval: CMTimeMake(value: 1, timescale: 100),
				queue: DispatchQueue.main
			) { [weak self] time in
				guard let self = self else { return }
				let timeString = String(format: "%02.2f", CMTimeGetSeconds(time))
				if let currentItem = self.player?.currentItem {
					let totalTimeString = String(format: "%02.2f", CMTimeGetSeconds(currentItem.asset.duration))
					if timeString == totalTimeString {
						self.playerObserverDelegate?.storyVideoViewDidCompletePlay(self)
					}
				}
				if let time = Float(timeString) {
					self.playerObserverDelegate?.storyVideoView(self, didTrack: time)
				}
			} as AnyObject
	}

	private func setupOutputVolumeObserver() {
		let audioSession = AVAudioSession.sharedInstance()
		try? audioSession.setActive(true)
		outputVolumeObserver = audioSession.observe(\.outputVolume) { [weak self] session, _ in
			guard let self = self else { return }
			if !self.isSessionCategorySet {
				try? session.setCategory(.playback, mode: .default, options: [])
				self.isSessionCategorySet = true
			}
		}
	}

	private func cleanUpOutputVolumeObserver() {
		outputVolumeObserver?.invalidate()
		outputVolumeObserver = nil
	}
}

// MARK: - StoryVideoPlayerControls
extension StoryVideoView: StoryVideoPlayerControls {
	func play(with resource: String) {
		guard let url = URL(string: resource) else {
			VFGErrorLog("Unable to form URL from resource")
			return
		}
		if let existingPlayer = player {
			DispatchQueue.main.async { [weak self] in
				guard let strongSelf = self else { return }
				strongSelf.player = existingPlayer
			}
		} else {
			let asset = AVAsset(url: url)
			playerItem = AVPlayerItem(asset: asset)
			player = AVPlayer(playerItem: playerItem)
			playerLayer = AVPlayerLayer(player: player)
			setupPlayerPeriodicTimeObserver()
			if let pLayer = playerLayer {
				pLayer.videoGravity = .resizeAspect
				pLayer.frame = bounds
				layer.addSublayer(pLayer)
			}
		}
		startAnimating()
		player?.play()
	}

	func play() {
		// We have used this for long press gesture
		if let existingPlayer = player {
			existingPlayer.play()
		}
	}

	func pause() {
		if let existingPlayer = player {
			existingPlayer.pause()
		}
	}

	func stop() {
		if let existingPlayer = player {
			DispatchQueue.main.async { [weak self] in
				guard let strongSelf = self else { return }
				existingPlayer.pause()

				// Remove observer if observer presents before setting player to nil
				if existingPlayer.observationInfo != nil {
					strongSelf.removeObservers()
				}
				strongSelf.playerItem = nil
				strongSelf.player = nil
				strongSelf.playerLayer?.removeFromSuperlayer()
			}
			// player got deallocated
		} else {
			// player was already deallocated
		}
	}

	var playerStatus: StoryVideoPlayerStatus {
		if let player = player {
			switch player.status {
			case .unknown: return .unknown
			case .readyToPlay: return .readyToPlay
			case .failed: return .failed
			@unknown default:
				return .unknown
			}
		}
		return .unknown
	}
}
