//
//  BaseViewControllerExtension.swift
//  VFGMVA10Group
//
//  Created by Ahmed Sultan on 10/13/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//
extension VFGBaseViewController {
    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        testLifeCycleDelegate?.isViewWillAppearCalled = true
    }
    /// Notifies the view controller that its view was added to a view hierarchy.
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        testLifeCycleDelegate?.isViewDidAppearCalled = true
    }
    /// Notifies the view controller that its view was removed from a view hierarchy.
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        testLifeCycleDelegate?.isViewDidDisAppearCalled = true
    }
    /// Notifies the view controller that its view is about to be removed from a view hierarchy.
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        testLifeCycleDelegate?.isViewWillDisAppearCalled = true
    }
    /// Called to notify the view controller that its view has just laid out its subviews.
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        testLifeCycleDelegate?.isViewDidLayoutSubviewsCalled = true
    }
}

/// Life cycle testing delegate.
public protocol LifeCycleTestingDelegate: AnyObject {
    /// Boolean determines whether *viewWillAppear* was called or not.
    var isViewWillAppearCalled: Bool? { get set }
    /// Boolean determines whether *viewDidAppear* was called or not.
    var isViewDidAppearCalled: Bool? { get set }
    /// Boolean determines whether *viewDidDisappear* was called or not.
    var isViewDidDisAppearCalled: Bool? { get set }
    /// Boolean determines whether *viewDidLayoutSubviews* was called or not.
    var isViewDidLayoutSubviewsCalled: Bool? { get set }
    /// Boolean determines whether *viewWillDisappear* was called or not.
    var isViewWillDisAppearCalled: Bool? { get set }
}
