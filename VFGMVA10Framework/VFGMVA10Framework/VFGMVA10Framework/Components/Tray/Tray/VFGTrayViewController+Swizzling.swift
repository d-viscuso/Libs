//
//  VFGTrayViewController+Swizzling.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 1/21/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

extension UIViewController {
    public static let classInitializer: Void = {
        guard let originalPresent = class_getInstanceMethod(UIViewController.self, #selector(present)) else { return }
        guard let swizzledPresenting = class_getInstanceMethod(UIViewController.self, #selector(swizzled_presenting))
            else {
                return
        }
        method_exchangeImplementations(originalPresent, swizzledPresenting)

        guard let originalDismiss = class_getInstanceMethod(UIViewController.self, #selector(dismiss)) else { return }
        guard let swizzledDismissing = class_getInstanceMethod(UIViewController.self, #selector(swizzled_dismissing))
            else {
                return
        }
        method_exchangeImplementations(originalDismiss, swizzledDismissing)
    }()

    @objc func swizzled_presenting(secondViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        swizzled_presenting(secondViewController: secondViewController, animated: animated, completion: completion)
        if let topVC = UIApplication.topViewController() as? VFGTrayViewController {
            if let root = topVC.rootViewController, let rootVC = UIApplication.topViewController(base: root) {
                if let rootVC = rootVC as? VFGTrayContainerProtocol {
                    topVC.handleTray(style: rootVC.trayStyle)
                    let key = rootVC.tobiKey
                    if topVC.tobiMessagesModel[key] != nil, rootVC.tobiMessageEnabled {
                        topVC.setupTOBIMessage(key: key)
                        topVC.tobiMessageTimer = topVC.tobiMessagesModel[key]?.tobiMessageTimer ??
                            Constants.TobiMessages.tobiMessageTimer
                    } else {
                        topVC.titleLabel?.text = nil
                        topVC.restoreTOBIBadge(for: key)
                        topVC.tobiMessageTimer = Constants.TobiMessages.welcomeMessageTimer
                    }
                } else {
                    topVC.handleTray(style: .none)
                }
            }
        }
    }

    @objc func swizzled_dismissing(animated: Bool, completion: (() -> Void)?) {
        defer {
            swizzled_dismissing(animated: true, completion: completion)
        }
        guard let presenting = presentingViewController,
            let trayVC = presenting.trayViewController() else {
            return
        }
        if let topPresentingNavigationVC = presenting as? UINavigationController,
            let lastVC = topPresentingNavigationVC.viewControllers.last as? VFGTrayContainerProtocol {
            trayVC.handleTray(style: lastVC.trayStyle)
            if !lastVC.tobiMessageEnabled {
                let key = lastVC.tobiKey
                trayVC.restoreTOBIBadge(for: key)
            }
        } else if let topPresentingVC = presentingViewController as? VFGTrayContainerProtocol {
            trayVC.handleTray(style: topPresentingVC.trayStyle)
            if !topPresentingVC.tobiMessageEnabled {
                let key = topPresentingVC.tobiKey
                trayVC.restoreTOBIBadge(for: key)
            }
        }
        trayVC.notifyTrayState(.collapsed)
    }
}

public extension UIViewController {
    func trayViewController() -> VFGTrayViewController? {
        var viewControllerToCheck = self
        if viewControllerToCheck is VFGTrayViewController {
            return viewControllerToCheck as? VFGTrayViewController
        }
        if viewControllerToCheck.parent != nil {
            if viewControllerToCheck.parent is VFGTrayViewController {
                return viewControllerToCheck.parent as? VFGTrayViewController
            } else {
                viewControllerToCheck =
                    viewControllerToCheck.parent?.trayViewController() ?? UIViewController()
            }
        } else if viewControllerToCheck.presentingViewController != nil {
            if viewControllerToCheck.presentingViewController is VFGTrayViewController {
                return viewControllerToCheck.presentingViewController as? VFGTrayViewController
            } else {
                viewControllerToCheck =
                    viewControllerToCheck.presentingViewController?.trayViewController() ?? UIViewController()
            }
        }
        return viewControllerToCheck as? VFGTrayViewController
    }
}
