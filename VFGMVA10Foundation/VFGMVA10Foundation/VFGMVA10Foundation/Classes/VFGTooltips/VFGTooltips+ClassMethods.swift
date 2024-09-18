//
//  VFGTooltips+ClassMethods.swift
//  VFGMVA10Group
//
//  Created by Yahya Saddiq on 14/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

extension VFGTooltips {
    /**
        Presents Tooltip pointing to a particular UIBarItem instance within the specified superview

        - parameter animated:    Pass true to animate the presentation.
        - parameter item:        The UIBarButtonItem or UITabBarItem instance which the Tooltip will be pointing to.
        - parameter superview:   A view which is part of the UIBarButtonItem instances superview hierarchy. Ignore this parameter in order to display the Tooltip within the main window.
        - parameter text:        The text to be displayed.
        - parameter preferences: The preferences which will configure the Tooltip.
        - parameter delegate:    The delegate.
        */
    class func show(animated: Bool = true, forItem item: UIBarItem, withinSuperview superview: UIView? = nil, text: String, preferences: Preferences = VFGTooltips.globalPreferences, delegate: VFGTooltipsDelegate? = nil) {
        if let view = item.view {
            show(
                animated: animated,
                forView: view,
                withinSuperview: superview,
                text: text,
                preferences: preferences,
                delegate: delegate)
        }
    }

    /**
        Presents Tooltip pointing to a particular UIView instance within the specified superview

        - parameter animated:    Pass true to animate the presentation.
        - parameter view:        The UIView instance which the Tooltip will be pointing to.
        - parameter superview:   A view which is part of the UIView instances superview hierarchy. Ignore this parameter in order to display the Tooltip within the main window.
        - parameter text:        The text to be displayed.
        - parameter preferences: The preferences which will configure the Tooltip.
        - parameter delegate:    The delegate.
        */
    class func show(animated: Bool = true, forView view: UIView, withinSuperview superview: UIView? = nil, text: String, preferences: Preferences = VFGTooltips.globalPreferences, delegate: VFGTooltipsDelegate? = nil) {
        let tooltip = VFGTooltips(text: text, preferences: preferences, delegate: delegate)
        tooltip.show(animated: animated, forView: view, withinSuperview: superview)
    }

    /**
        Presents Tooltip pointing to a particular UIBarItem instance within the specified superview

        - parameter animated:    Pass true to animate the presentation.
        - parameter item:        The UIBarButtonItem or UITabBarItem instance which the Tooltip will be pointing to.
        - parameter superview:   A view which is part of the UIBarButtonItem instances superview hierarchy. Ignore this parameter in order to display the Tooltip within the main window.
        - parameter contentView: The view to be displayed.
        - parameter preferences: The preferences which will configure the Tooltip.
        - parameter delegate:    The delegate.
        */
    class func show(animated: Bool = true, forItem item: UIBarItem, withinSuperview superview: UIView? = nil, contentView: UIView, preferences: Preferences = VFGTooltips.globalPreferences, delegate: VFGTooltipsDelegate? = nil) {
        if let view = item.view {
            show(
                animated: animated,
                forView: view,
                withinSuperview: superview,
                contentView: contentView,
                preferences: preferences,
                delegate: delegate)
        }
    }

    /**
        Presents Tooltip pointing to a particular UIView instance within the specified superview

        - parameter animated:    Pass true to animate the presentation.
        - parameter view:        The UIView instance which the Tooltip will be pointing to.
        - parameter superview:   A view which is part of the UIView instances superview hierarchy. Ignore this parameter in order to display the Tooltip within the main window.
        - parameter contentView: The view to be displayed.
        - parameter preferences: The preferences which will configure the Tooltip.
        - parameter delegate:    The delegate.
        */
    class func show(animated: Bool = true, forView view: UIView, withinSuperview superview: UIView? = nil, contentView: UIView, preferences: Preferences = VFGTooltips.globalPreferences, delegate: VFGTooltipsDelegate? = nil) {
        let tooltip = VFGTooltips(contentView: contentView, preferences: preferences, delegate: delegate)
        tooltip.show(animated: animated, forView: view, withinSuperview: superview)
    }

    /**
        Presents Tooltip pointing to a particular UIView instance within the specified superview containing attributed text.
        - parameter animated:       Pass true to animate the presentation.
        - parameter view:           The UIView instance which the Tooltip will be pointing to.
        - parameter superview:      A view which is part of the UIView instances superview hierarchy. Ignore this parameter in order to display the Tooltip within the main window.
        - parameter attributedText: The attributed text to be displayed.
        - parameter preferences:    The preferences which will configure the Tooltip.
        - parameter delegate:       The delegate.
        */
    class func show(animated: Bool = true, forView view: UIView, withinSuperview superview: UIView? = nil, attributedText: NSAttributedString, preferences: Preferences = VFGTooltips.globalPreferences, delegate: VFGTooltipsDelegate? = nil) {
        let tooltip = VFGTooltips(text: attributedText, preferences: preferences, delegate: delegate)
        tooltip.show(animated: animated, forView: view, withinSuperview: superview)
    }

    // MARK: - Instance methods -

    /**
        Presents Tooltip pointing to a particular UIBarItem instance within the specified superview

        - parameter animated:  Pass true to animate the presentation.
        - parameter item:      The UIBarButtonItem or UITabBarItem instance which the Tooltip will be pointing to.
        - parameter superview: A view which is part of the UIBarButtonItem instances superview hierarchy. Ignore this parameter in order to display the Tooltip within the main window.
        */
    func show(animated: Bool = true, forItem item: UIBarItem, withinSuperView superview: UIView? = nil) {
        if let view = item.view {
            show(animated: animated, forView: view, withinSuperview: superview)
        }
    }

    /**
        Presents Tooltip pointing to a particular UIView instance within the specified superview

        - parameter animated:  Pass true to animate the presentation.
        - parameter view:      The UIView instance which the Tooltip will be pointing to.
        - parameter targetFrame:      The  frame  which the Tooltip will be pointing to.
        - parameter superview: A view which is part of the UIView instances superview hierarchy. Ignore this parameter in order to display the Tooltip within the main window.
        */
    func show(animated: Bool = true, forView view: UIView, onFrame targetFrame: CGRect? = nil, withinSuperview superview: UIView? = nil) {
        let message = "The supplied superview <\(superview ?? UIView())>" +
        "is not a direct nor an indirect superview of the supplied reference view <\(view)>." +
        "The superview passed to this method should be a direct or an indirect superview of the reference view." +
        "To display the tooltip within the main window, ignore the superview parameter."
        precondition(superview == nil || view.hasSuperview(superview ?? UIView()), message)

        let superview = superview ?? UIApplication.shared.windows[0]

        let initialTransform = preferences.animating.showInitialTransform
        let finalTransform = preferences.animating.showFinalTransform
        let initialAlpha = preferences.animating.showInitialAlpha
        let damping = preferences.animating.springDamping
        let velocity = preferences.animating.springVelocity

        presentingView = view
        presentingViewFrame = targetFrame
        arrange(withinSuperview: superview)

        transform = initialTransform
        alpha = initialAlpha

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)

        superview.addSubview(self)

        let animations: () -> Void = {
            self.transform = finalTransform
            self.alpha = 1
        }

        if animated {
            UIView.animate(
                withDuration: preferences.animating.showDuration,
                delay: 0,
                usingSpringWithDamping: damping,
                initialSpringVelocity: velocity,
                options: [.curveEaseInOut],
                animations: animations,
                completion: nil
            )
        } else {
            animations()
        }
    }

        /**
        Dismisses the Tooltip

        - parameter completion: Completion block to be executed after the Tooltip is dismissed.
        */
    func dismiss(withCompletion completion: (() -> Void)? = nil) {
        let damping = preferences.animating.springDamping
        let velocity = preferences.animating.springVelocity

        UIView.animate(
            withDuration: preferences.animating.dismissDuration,
            delay: 0,
            usingSpringWithDamping: damping,
            initialSpringVelocity: velocity,
            options: [.curveEaseInOut],
            animations: {
                self.transform = self.preferences.animating.dismissTransform
                self.alpha = self.preferences.animating.dismissFinalAlpha
            }, completion: { _ in
                completion?()
                self.delegate?.tooltipViewDidDismiss(self)
                self.removeFromSuperview()
                self.transform = CGAffineTransform.identity
            })
    }
}
