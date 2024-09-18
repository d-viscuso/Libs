//
//  VFGEIOManager.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 4/1/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// EIO Creation Manager
open class VFGEIOManager {
    /// EIO Static object
    public static var shared = VFGEIOManager()

    /// Dashboard View Controller
    var dashboardVC: UIViewController
    /// Collection View Object
    var collectionView: UICollectionView
    /// Background View Object
    var backgroundView: UIView?
    /// EIO Model Protocol
    var eioModel: VFGEIOModelProtocol?

    /// Dashboard Section Header
    var dashboardHeader: VFSectionHeader? {
        return collectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: 0)) as? VFSectionHeader
    }
    var isScrolling = false
    var transitionAnimationInteractor = VFGTransitionInteractor()
    var everythingOkVC: VFEverythingIsOKChecksViewController?
    var headerCustomViewController: UIViewController? {
        didSet {
            headerCustomViewController?.view.translatesAutoresizingMaskIntoConstraints = false
            headerCustomViewController?.view.layoutIfNeeded()
            dashboardHeader?.setupCustomView(
                with: headerCustomViewController,
                height: customViewControllerHeight
            )
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    var customViewControllerHeight: CGFloat {
        return headerCustomViewController?.view.frame.height ?? 0
    }

    // MARK: Private Variables
    private var scrollObserver: NSKeyValueObservation?
    private let headerXib = UINib(nibName: "VFSectionHeader", bundle: Bundle.mva10Framework)
    private var dashboardIsAutoTrayAnimationEnabled = true

    /// EIO Manager initializer
    /// - Parameters:
    ///    - dashboardVC: Dashboard View Controller
    ///    - collectionView: Dashboard Collection View Object
    ///    - backgroundView: Custom Background View
    ///    - eioModel: EIO Model Protocol Object
    public init(
        dashboardVC: UIViewController,
        collectionView: UICollectionView,
        backgroundView: UIView,
        eioModel: VFGEIOModelProtocol?
    ) {
        self.dashboardVC = dashboardVC
        self.collectionView = collectionView
        self.backgroundView = backgroundView
        self.eioModel = eioModel
        if let dashboardVC = dashboardVC as? VFDashboardViewController {
            headerCustomViewController = dashboardVC.headerCustomViewController
        }

        collectionView.register(
            headerXib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Constants.Dashboard.Identifier.header)
        scrollObserver = collectionView.observe(
            \.contentOffset,
            options: .new) { [weak self] _, contentOffset in
            if let self = self,
                let newY = contentOffset.newValue?.y {
                self.updateScroll(offsetY: newY)
            }
        }
    }

    init() {
        dashboardVC = UIViewController()
        collectionView = UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: UICollectionViewLayout())
        backgroundView = nil
        eioModel = nil
    }

    // MARK: Private Methods
    private func updateScroll(offsetY: CGFloat) {
        if eioModel?.pullToShowEIO ?? true {
            applyPullAnimation(offsetY: offsetY)
        }

        if collectionView.contentOffset.y < VFGUISetup.dashboardMainHeaderHeight {
            let margin: CGFloat = UIScreen.screenHasNotch ? 44 : 0
            let offset = offsetY + margin
            dashboardHeader?.parallexAnimation(offset: offset)
        } else {
            dashboardHeader?.parallexAnimation(offset: 0)
        }
    }

    private func applyPullAnimation(offsetY: CGFloat) {
        if transitionAnimationInteractor.hasStarted {
            let verticalMovement = -(offsetY)
            let verticalMovementPercent = verticalMovement / dashboardVC.view.bounds.height
            if isScrolling {
                let totalHeights = VFGUISetup.dashboardMainHeaderHeight + VFGUISetup.statusBarHeight
                transitionAnimationInteractor.shouldFinish = verticalMovement > (totalHeights / 2)
            }
            transitionAnimationInteractor.update(verticalMovementPercent)
            dashboardVC.trayViewController()?.updateAnimation(percentComplete: verticalMovementPercent)
        }
        if offsetY >= -VFGUISetup.statusBarHeight {
            transitionAnimationInteractor.cancelTransition()
        } else {
            if isScrolling {
                transitionAnimationInteractor.startTransition {
                    presentEIO(completion: nil)
                    dashboardVC.trayViewController()?.startAnimation(showTray: false)
                }
            }
        }
    }

    // MARK: Internal Methods
    func presentEIO(animated: Bool = true, completion: (() -> Void)?) {
        if !(eioModel?.isEIOEnabled ?? true) {
            completion?()
            return
        }
        if everythingOkVC == nil {
            everythingOkVC = VFEverythingIsOKChecksViewController
                .instantiate(fromAppStoryboard: .everythingIsOK)
            if let updateDashboardDelegateVC = dashboardVC as? UpdateDashboardSectionHeightDelegate {
                everythingOkVC?.delegate = updateDashboardDelegateVC
            }
        }
        everythingOkVC?.eioModel = eioModel
        everythingOkVC?.myProductsImage =
            (dashboardVC as? VFDashboardViewController)?.dashboardCardsModel?
            .myProductsModel?.image
        guard let eiokController = everythingOkVC else { return }
        eiokController.modalPresentationStyle = .currentContext
        eiokController.transitionInteractor = eioModel?.pullToShowEIO ?? true ? transitionAnimationInteractor : nil
        if let transitioningDelegateVC = dashboardVC as? UIViewControllerTransitioningDelegate {
            eiokController.transitioningDelegate = transitioningDelegateVC
        }
        eiokController.openFailedSectionsWithDelay = !(eioModel?.pullToShowEIO ?? true)
        eiokController.isAutoTrayAnimationEnabled = false
        dashboardIsAutoTrayAnimationEnabled = false
        dashboardVC.present(eiokController, animated: animated) {
            completion?()
            eiokController.isAutoTrayAnimationEnabled = true
        }
    }

    // MARK: Market Integration Methods
    /// Dashboard Appeared Delegate Method
    public func dashboardDidAppear() {
        dashboardIsAutoTrayAnimationEnabled = true
    }
    /// Dashboard begin to appear Method
    public func dashboardWillAppear() {
        dashboardHeader?.drawChecksIcons()
    }
    /// Scroll View Will start scrolling
    public func scrollViewWillBeginDragging() {
        isScrolling = true
    }
    /// Scroll View Scrolling ended
    public func scrollViewDidEndDragging(willDecelerate decelerate: Bool) {
        if !decelerate {
            if eioModel?.pullToShowEIO ?? true {
                dashboardVC.trayViewController()?
                    .finishAnimation(shouldFinish: transitionAnimationInteractor.shouldFinish)
            }
        }
        guard let eioEnabled = eioModel?.pullToShowEIO,
            eioEnabled else {
                return
        }
        isScrolling = false
        if transitionAnimationInteractor.shouldFinish {
            transitionAnimationInteractor.finishTransition()
            dashboardVC.trayViewController()?.finishAnimation(shouldFinish: true)
        }
    }
    /// Scroll View Scrolling will stop
    public func scrollViewDidEndDecelerating() {
        if !transitionAnimationInteractor.shouldFinish, eioModel?.pullToShowEIO ?? true {
            transitionAnimationInteractor.cancelTransition()
            dashboardVC.trayViewController()?.finishAnimation(shouldFinish: false)
        }
    }
    /// EIO Status Update
    public func updateEIOStatus(newStatus: EIOStatus, oldStatus: EIOStatus?) {
        everythingOkVC?.statusUpdated()
        if let header = dashboardHeader {
            header.updateEIOKStatus(oldStatus: oldStatus)
        }
    }
    /// Navigating to EIO from Dashboard using Transition
    public func animatedTransitioning(isPresenting: Bool) -> UIViewControllerAnimatedTransitioning? {
        eioModel?.pullToShowEIO ?? true ?
            VFGDashboardToEIOKAnimation(
                isPresenting: isPresenting,
                duration: Constants.dashboardTransitionDuration) : nil
    }
    /// Transition Animation Interactor
    public func interactionController() -> UIViewControllerInteractiveTransitioning? {
        (eioModel?.pullToShowEIO ?? true &&
            transitionAnimationInteractor.hasStarted) ? transitionAnimationInteractor : nil
    }

    // MARK: Market Helper Methods
    /// Dashboard tray animation status
    public func dashboardIsAutoTrayAnimation() -> Bool {
        dashboardIsAutoTrayAnimationEnabled
    }
    /// Dashboard logo hide method
    public func hideLogo() {
        if let header = dashboardHeader {
            header.logoImageView.isHidden = false
        }
    }
    /// Dashboard Header Configuration
    /// - Parameters:
    ///    - indexPath: Holds the index for the header
    ///    - oldStatus: The EIO initial status
    ///    - isFromSplash: Holds the Navigation from splash status 
    public func dashboardHeader(
        indexPath: IndexPath = IndexPath(row: 0, section: 0),
        oldStatus: EIOStatus?,
        isFromSplash: Bool
    ) -> UICollectionReusableView {
        let headerView = collectionView
            .dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: Constants.Dashboard.Identifier.header,
                for: indexPath)
        guard let sectionHeader = headerView as? VFSectionHeader else {
            return headerView
        }
        if let updateDashboardDelegateVC = dashboardVC as? UpdateDashboardSectionHeightDelegate {
            sectionHeader.delegate = updateDashboardDelegateVC
        }
        sectionHeader.eioModel = eioModel
        sectionHeader.logoImageView.isHidden = isFromSplash
        sectionHeader.myProductsModel = (dashboardVC as? VFDashboardViewController)?.dashboardCardsModel?
            .myProductsModel
        sectionHeader.tapAction = { [weak self] completion in
            guard let self = self else { return }
            UIView.animate(
                withDuration: 0.05) {
                self.collectionView.contentOffset.y = -VFGUISetup.statusBarHeight
                self.presentEIO(completion: completion)
            }
            self.dashboardVC.trayViewController()?.autoAnimation(showTray: false)
        }
        sectionHeader.updateEIOKStatus(oldStatus: oldStatus)
        sectionHeader.setupCustomView(
            with: headerCustomViewController,
            height: customViewControllerHeight
        )
        return sectionHeader
    }
}
