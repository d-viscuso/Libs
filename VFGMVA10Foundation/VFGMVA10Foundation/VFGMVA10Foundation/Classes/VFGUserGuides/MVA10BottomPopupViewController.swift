//
//  MVA10BottomPopupViewController.swift
//  MyVodafone
//
//  Created by Ramy Nasser on 6/18/19.
//  Copyright © 2019 TSSE. All rights reserved.
//

import UIKit

open class MVA10BottomPopupViewController: UIViewController, MVA10BottomPopupAttributesProtocol {
    private var transitionHandler: MVA10BottomPopupTransitionHandler?
    open weak var popupDelegate: MVA10BottomPopupDelegate?

    // MARK: Initializations
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }


    open override func viewDidLoad() {
        super.viewDidLoad()
        transitionHandler?.viewLoaded(withPopupDelegate: popupDelegate)
        popupDelegate?.bottomPopupViewLoaded()
    }

    open override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        popupDelegate?.bottomPopupWillAppear()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        popupDelegate?.bottomPopupDidAppear()
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        popupDelegate?.bottomPopupWillDismiss()
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        popupDelegate?.bottomPopupDidDismiss()
    }

    private func initialize() {
        transitionHandler = MVA10BottomPopupTransitionHandler(popupViewController: self)
        transitioningDelegate = transitionHandler
        modalPresentationStyle = .custom
    }

    open func shouldPopupDismissInteractivelty() -> Bool {
        BottomPopupViewConstants.kPopupDismissInteractively
    }

    open func getPopupHeight() -> CGFloat {
        BottomPopupViewConstants.kPopupHeight
    }

    open func getPopupWidth() -> CGFloat {
        BottomPopupViewConstants.kPopupWidth
    }

    open func getPopupPresentDuration() -> Double {
        BottomPopupViewConstants.kPopupPresentDuration
    }
    open func getPopupDismissDuration() -> Double {
        return BottomPopupViewConstants.kPopupDismissDuration
    }
    open func getDimmingViewAlpha() -> CGFloat {
        BottomPopupViewConstants.kPopupDefaultAlphaValue
    }
    open func getDimmingViewBackgroundColor() -> UIColor {
        BottomPopupViewConstants.kPopupDefaultBackgroundColorValue
    }
    open func shouldPopupViewDismissInteractivelty() -> Bool {
        BottomPopupViewConstants.kPopupShouldPopupViewDismiss
    }
}
