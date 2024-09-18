//
//  VFGBaseViewController.swift
//  mva10
//
//  Created by Mohamed Matloub on 12/13/18.
//  Copyright © 2018 vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Initial view controller for any *UIViewController*
public class VFGBaseViewController: UIViewController {
    /// Delegation protocol for *UIViewController* life cycle actions
    public weak var testLifeCycleDelegate: LifeCycleTestingDelegate?
    /// *VFGBaseViewController* initializer
    /// - Parameters:
    ///    - config: Dictionary for *VFGBaseViewController* data
    public required init(config: [String: Any]?) {
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return VFGUISetup.applicationStatusBarStyle
    }

    /*
    Embedding viewController into containerView
    Params:
    - viewController   : UIViewController that will be embedded
    - containerView    : UIView that will contain the controller
    - entryController  : UIViewController to navigate to while clicking
    */
    func embed(
        viewController: UIViewController,
        in containerView: UIView,
        withEntry entry: VFGComponentEntry?
    ) {
        addChild(viewController)
        containerView.embed(view: viewController.view)
        viewController.didMove(toParent: self)
    }

    /*
    Embedding viewController into stackView
    Params:
    - viewController   : UIViewController that will be embedded
    - stackView        : UIStackView that will contain the controller
    - entryController  : UIViewController to navigate to while clicking
    */
    func embed(
        viewController: UIViewController,
        in stackView: UIStackView,
        withEntry entry: VFGComponentEntry?
    ) {
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.willMove(toParent: self)
        stackView.addArrangedSubview(viewController.view)
        viewController.view.layer.cornerRadius = 6
        addChild(viewController)
        viewController.didMove(toParent: self)
    }
}
