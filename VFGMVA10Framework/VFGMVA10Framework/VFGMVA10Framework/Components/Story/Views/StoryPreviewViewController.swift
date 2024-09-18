//
//  StoryPreviewViewController.swift
//  VFGStory
//
//  Created by Abdullah Soylemez on 21.01.2021.
//

import UIKit
import VFGMVA10Foundation
/// Delegation protocol for *StoryPreviewViewController* actions
protocol StoryPreviewViewControllerDelegate: AnyObject {
    /// Handle dismissing *StoryPreviewViewController*
    /// - Parameters:
    ///    - storyPreviewViewController: *StoryPreviewViewController* to be dismissed
	func storyPreviewViewControllerDidDismiss(_ storyPreviewViewController: StoryPreviewViewController)
}
/// Story preview screen view controller
public class StoryPreviewViewController: UIViewController {
	// MARK: - IBOutlet
	@IBOutlet weak var collectionView: UICollectionView!

	// MARK: - Public variables
    /// Delegation protocol for  *StoryPreviewViewModel*
	var viewModel: StoryPreviewViewModelProtocol?
    /// Delegation protocol for *StoryPreviewViewController* actions
	weak var delegate: StoryPreviewViewControllerDelegate?
    /// Delegation protocol for story analytics
    var analyticsDelegate: StoryAnalyticsProtocol?
    /// Story preview content button action
    var storyContentButtonTapped: ((Story) -> Void)?
    /// Story preview handler for setup and navigation
    var storyPreviewManager: StoryPreviewManager?
    var storiesLayout: StoriesLayout = .card

	// MARK: - Private variables
	private lazy var animatedCollectionViewLayout: AnimatedCollectionViewLayout = {
		let flowLayout = AnimatedCollectionViewLayout()
		flowLayout.scrollDirection = .horizontal
		flowLayout.animator = CubeAttributesAnimator(perspective: -1 / 100, totalAngle: .pi / 12)
		flowLayout.minimumLineSpacing = 0.0
		flowLayout.minimumInteritemSpacing = 0.0
		flowLayout.sectionInset = .zero
		return flowLayout
	}()


	// MARK: -
    public override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	// MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupPreviewManager()
		setupCollectionView()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        analyticsDelegate?.onStoryViewed(data: [:], story: storyPreviewManager?.currentStory)

        guard let index = self.viewModel?.initialStoryIndex
        else { return }
        storyPreviewManager?.scrollToIndex(index: index)
        if let story = viewModel?.stories[index], story.storyPreviewType == .single {
            viewModel?.stories[index].isViewed = true
        }
    }

	// MARK: - Private functions
    private func setupPreviewManager() {
        storyPreviewManager = StoryPreviewManager(
            viewModel: viewModel,
            collectionView: collectionView
        ) { self.dismissViewController() }
        storyPreviewManager?.analyticsDelegate = analyticsDelegate
        storyPreviewManager?.swipeDownAction = { [weak self] in
            guard let self = self else { return }
            self.analyticsDelegate?.onStoryDismissed(
                data: [:],
                story: self.storyPreviewManager?.currentStory
            )
            self.dismissViewController()
        }
        storyPreviewManager?.onStoryCompleteAction = { [weak self] in
            guard let self = self else { return }
            self.analyticsDelegate?.onStoryCompleted(
                data: [:],
                story: self.storyPreviewManager?.currentStory
            )
        }
        storyPreviewManager?.storiesLayout = storiesLayout
        storyPreviewManager?.onStoryButtonTappedAction = { [weak self] story, storyURLString in
            guard let self = self else { return }
            self.handleOpen(
                story: story,
                storyURLString: storyURLString
            )
        }
        storyPreviewManager?.onStoryGridItemTappedAction = { [weak self] story, gridItem in
            guard
                let self = self,
                let link = gridItem.link
            else { return }
            self.handleOpen(
                story: story,
                storyURLString: link
            )
        }
    }

	private func setupCollectionView() {
		collectionView.collectionViewLayout = animatedCollectionViewLayout
	}

	private func dismissViewController(completion: (() -> Void)? = nil) {
		collectionView.dataSource = nil
		collectionView.delegate = nil
		self.delegate?.storyPreviewViewControllerDidDismiss(self)
		dismiss(animated: true, completion: completion)
	}

    private func handleOpen(story: Story?, storyURLString: String) {
        if storyURLString.lowercased().starts(with: "http") {
            let viewModel = VFGWebViewModel(urlString: storyURLString)
            let webViewController = VFGWebViewController.instance(with: viewModel)
            dismissViewController { [weak self] in
                guard let strongSelf = self else { return }
                UIApplication.topViewController()?.present(webViewController, animated: true) {
                    if let story = story, let storyContentButtonTapped = strongSelf.storyContentButtonTapped {
                        strongSelf.dismiss(animated: true) {
                            storyContentButtonTapped(story)
                        }
                    }
                }
            }
        } else if let url = URL(string: storyURLString), UIApplication.shared.canOpenURL(url) {
            dismissViewController { [weak self] in
                guard let strongSelf = self else { return }
                UIApplication.shared.open(url) { _ in
                    if let story = story, let storyContentButtonTapped = strongSelf.storyContentButtonTapped {
                        strongSelf.dismiss(animated: true) {
                            storyContentButtonTapped(story)
                        }
                    }
                }
            }
        } else {
            dismissViewController { [weak self] in
                guard let strongSelf = self else { return }
                if let story = story, let storyContentButtonTapped = strongSelf.storyContentButtonTapped {
                    strongSelf.dismiss(animated: true) {
                        storyContentButtonTapped(story)
                    }
                }
            }
        }
    }
}
