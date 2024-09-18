//
//  Extenstions.swift
//  VFGTOBI
//
//  Created by Hussein Kishk on 10/23/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

public extension UIView {
    var globalFrame: CGRect? {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }
}
extension UIViewController {
    public static let classInit: Void = {
        guard let originalPresent = class_getInstanceMethod(UIViewController.self, #selector(present)) else { return }
        guard let swizzledPresent = class_getInstanceMethod(UIViewController.self, #selector(swizzled_present))
            else {
                return
        }
        method_exchangeImplementations(originalPresent, swizzledPresent)
        guard let originalDismiss = class_getInstanceMethod(UIViewController.self, #selector(dismiss)) else { return }
        guard let swizzledDismiss = class_getInstanceMethod(UIViewController.self, #selector(swizzled_dismiss))
            else {
                return
        }
        method_exchangeImplementations(originalDismiss, swizzledDismiss)
    }()

    @objc func swizzled_present(secondViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        swizzled_present(secondViewController: secondViewController, animated: animated, completion: completion)
        let navigationTobi = ((secondViewController as? UINavigationController)?
            .viewControllers[0] as? TOBIFloatingViewDelegate)?.showTOBI ?? false
        let secondVCTobi = (secondViewController as? TOBIFloatingViewDelegate)?.showTOBI ?? false
        if navigationTobi || secondVCTobi {
            VFGTOBIView.shared.showTOBI()
        }
    }

    @objc func swizzled_dismiss(animated: Bool, completion: (() -> Void)?) {
        if !((presentingViewController as? TOBIFloatingViewDelegate)?.showTOBI ?? false) {
            VFGTOBIView.shared.hideTOBI()
        }
        swizzled_dismiss(animated: true, completion: completion)
    }
}

extension UINavigationController {
    public static let navigationControllerInit: Void = {
        guard let originalPush = class_getInstanceMethod(UINavigationController.self, #selector(pushViewController))
            else {
                return
        }
        guard let swizzledPush = class_getInstanceMethod(UINavigationController.self, #selector(swizzled_push))
            else {
                return
        }
        method_exchangeImplementations(originalPush, swizzledPush)
        guard let originalPop = class_getInstanceMethod(UINavigationController.self, #selector(popViewController))
            else {
                return
        }
        guard let swizzledPop = class_getInstanceMethod(UINavigationController.self, #selector(swizzled_pop))
            else {
                return
        }
        method_exchangeImplementations(originalPop, swizzledPop)
    }()

    @objc func swizzled_push(secondViewController: UIViewController, animated: Bool) {
        swizzled_push(secondViewController: secondViewController, animated: animated)
        let navigationTobi = ((secondViewController as? UINavigationController)?
            .viewControllers[0] as? TOBIFloatingViewDelegate)?.showTOBI ?? false
        let secondVCTobi = (secondViewController as? TOBIFloatingViewDelegate)?.showTOBI ?? false
        if navigationTobi || secondVCTobi {
            VFGTOBIView.shared.showTOBI()
        }
    }

    @objc func swizzled_pop(animated: Bool) -> UIViewController? {
        let controllersCount = viewControllers.count
        if controllersCount > 1 {
            let destinationVC = viewControllers[controllersCount - 1]
            if !((destinationVC as? TOBIFloatingViewDelegate)?.showTOBI ?? false) {
                VFGTOBIView.shared.hideTOBI()
            }
        }
        return swizzled_pop(animated: animated)
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
