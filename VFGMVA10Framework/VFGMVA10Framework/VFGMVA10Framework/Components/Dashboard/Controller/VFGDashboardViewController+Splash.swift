//
//  VFGDashboardViewController+Splash.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 12/1/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//
import VFGMVA10Foundation

extension VFDashboardViewController: VFGMVa10SplashDelegate {
    public func splashTransitionsWillStart(duration: Double, delay: Double, completion: (() -> Void)? = nil) {
        dashboardFromSplash = true
        if !useSplashDefaultAnimation {
            collectionView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            collectionBackgroundView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            animateViews(duration: duration, delay: delay)
        }
        backgroundView.isHidden = true
    }

    public var logo: UIImage? {
        guard let status = eioModel?.eioStatus else { return UIImage.image(named: "red") }
        switch status {
        case .success:
            return UIImage.image(named: "red")
        default:
            return UIImage.VFGLogo.white
        }
    }

    public var logoFrame: CGRect {
        var top = UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.top ?? 0
        /*
        Height is zero in all iPhones without notches,
        so we add fixed value 20 which is the height of the status bar
        in all iPhones without notches
        */
        top = top == 0 ? 20 : top
        return CGRect(
            x: Constants.Dashboard.Layout.Logo.x,
            y: top + Constants.Dashboard.Layout.Logo.y,
            width: Constants.Dashboard.Layout.Logo.width,
            height: Constants.Dashboard.Layout.Logo.height)
    }

    public var useSplashDefaultAnimation: Bool {
        return false
    }

    public var nextViewControllerBGColor: UIColor? {
        return nil
    }

    public var nextViewControllerBGImage: UIImage? {
        guard let status = eioModel?.eioStatus else { return UIImage.background(with: .inProgress) }
        let image = UIImage.background(with: status)
        return image
    }

    public func splashTransitionsDidFinish() {
        if let backgroundView = backgroundView {
            backgroundView.isHidden = false
        }
        dashboardFromSplash = false
    }

    // this Overloading method is for testing purposes only
    func splashTransitionsWillStart(duration: Double, delay: Double, _ completion: (() -> Void)? = nil) {
        splashTransitionsWillStart(duration: duration, delay: delay, completion: nil)
        // this completion is for testing purposes
        guard let completion = completion else {
            return
        }
        completion()
    }
    /// Responsible for logo animation
    /// - Parameters:
    ///    - duration: Animation process time
    ///    - delay: Hold time to start animation process
    ///    - completion: Actions to be done after animation process is finished
    func animateViews(duration: Double, delay: Double, _ completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            animations: { [weak self] in
                guard let self = self else {
                    return
                }
                self.collectionView.transform = .identity
                self.collectionView.center = CGPoint(
                    x: self.collectionView.frame.midX,
                    y: self.collectionView.frame.midY)
                self.collectionBackgroundView.transform = .identity
                self.collectionBackgroundView.center = CGPoint(
                    x: self.collectionBackgroundView.frame.midX,
                    y: self.collectionBackgroundView.frame.midY)
            },
            completion: { [weak self] _ in
                guard let self = self else {
                    return
                }
                VFGEIOManager.shared.hideLogo()
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 1) {  [weak self] in
                        guard let self = self else {
                            return
                        }
                        self.backgroundView.isHidden = false
                        // this completion is for testing purposes
                        guard let completion = completion else {
                            return
                        }
                        completion()
                }
            })
    }
}
