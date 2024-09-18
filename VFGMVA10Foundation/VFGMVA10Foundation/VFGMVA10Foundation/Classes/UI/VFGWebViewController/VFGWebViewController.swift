//
//  VFGWebViewController.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 9/3/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import WebKit
/// A model that used to inject scripts to the webview .
public struct VFGWebViewScriptModel {
    weak var handler: WKScriptMessageHandler?
    var scriptHandlerNames: [String]

    /// - Parameters:
    ///   - handler: handler for scripting.
    ///   - scriptHandlerNames: scripts that need to be passed to webview
    public init(handler: WKScriptMessageHandler?, scriptHandlerNames: [String]) {
        self.handler = handler
        self.scriptHandlerNames = scriptHandlerNames
    }
}
/// A protocol that called when an action on the webview is invoked
public protocol VFGWebViewDelegate: AnyObject {
    /// Notify the delegate once web view is closed.
    /// - Parameters:
    ///   - viewController: Current web view controller associated with the delegate.
    func close(sender viewController: VFGWebViewController)

    /// Notify the delegate once web view is finished and loaded the url or render the html.
    /// - Parameters:
    ///   - viewController: Current web view controller associated with the delegate.
    func didFinish(sender viewController: VFGWebViewController)

    /// Notify the delegate once web view is started navigation from url to another .
    /// - Parameters:
    ///   - viewController: Current web view controller associated with the delegate.
    func didStartProvisionalNavigation(sender viewController: VFGWebViewController)

    /// Notify the delegate once web view is failed to navigate from url to another .
    /// - Parameters:
    ///   - viewController: Current web view controller associated with the delegate.
    ///   - error: Current web view controller associated with the delegate.
    func didFailProvisionalNavigation(sender viewController: VFGWebViewController, withError error: Error)

    /// Notify the delegate when the web view needs to respond to an authentication challenge .
    /// - Parameters:
    ///   - viewController: Current web view controller associated with the delegate.
    ///   - challenge: The authentication challenge.
    ///   - completionHandler: The completion handler you must invoke to respond to the challenge. The disposition argument is one of the constants of the enumerated type
    ///     NSURLSessionAuthChallengeDisposition. When disposition is NSURLSessionAuthChallengeUseCredential, the credential argument is the credential to use, or nil to indicate continuing without a credential .
    func didReceive(sender viewController: VFGWebViewController, challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)

    /// Notify the delegate when the web view Decides whether to allow or cancel a navigation after its response is known.
    /// - Parameters:
    ///   - viewController: Current web view controller associated with the delegate.
    ///   - response: Contains information about a navigation response
    ///   - handler: The decision handler to call to allow or cancel the navigation.
    ///       The argument is one of the constants of the enumerated type WKNavigationResponsePolicy.
    func decidePolicyFor(sender viewController: VFGWebViewController, response: WKNavigationResponse, handler: @escaping (WKNavigationResponsePolicy) -> Void)

    /// Notify the delegate when the web view decides whether to allow or cancel a navigation .
    /// - Parameters:
    ///   - viewController: Current web view controller associated with the delegate.
    ///   - action: Descriptive information about the action triggering the navigation request
    ///   - handler: The policy decision handler to call to allow or cancel the navigation. The arguments are one of the constants of the enumerated type WKNavigationActionPolicy,
    ///    as well as an instance of WKWebpagePreferences.
    func decidePolicyFor(sender viewController: VFGWebViewController, action: WKNavigationAction, handler: @escaping (WKNavigationActionPolicy) -> Void)
    func refreshButtonDidTap(sender viewController: VFGWebViewController)
}

// MARK: redirections default
public extension VFGWebViewDelegate {
    func didFinish(sender viewController: VFGWebViewController) {
    }

    func didStartProvisionalNavigation(sender viewController: VFGWebViewController) {
    }

    func didFailProvisionalNavigation(sender viewController: VFGWebViewController, withError error: Error) {
    }

    func didReceive(sender viewController: VFGWebViewController, challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.performDefaultHandling, nil)
    }

    func decidePolicyFor(sender viewController: VFGWebViewController, response: WKNavigationResponse, handler: @escaping (WKNavigationResponsePolicy) -> Void) {
        handler(.allow)
    }

    func decidePolicyFor(sender viewController: VFGWebViewController, action: WKNavigationAction, handler: @escaping (WKNavigationActionPolicy) -> Void) {
        handler(.allow)
    }

    func close(sender viewController: VFGWebViewController) {
        viewController.dismiss(animated: true)
    }

    func refreshButtonDidTap(sender viewController: VFGWebViewController) {
        viewController.webView.reload()
    }
}

/// A web Controller which contain web view with embedded url or html
open class VFGWebViewController: UIViewController {
    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var pageHeaderLabel: VFGLabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var leadingConstraintRefreshButton: NSLayoutConstraint!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var topBarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButton: VFGButton!
    @IBOutlet weak var refreshButton: VFGButton!
    /// An object that displays interactive web content
    public lazy var webView = WKWebView()
    /// delegate that called when an action happened in the webview
    public weak var delegate: VFGWebViewDelegate?
    /// model that injected to web view controller to configure it
    public internal(set) var viewModel: VFGWebViewModel?
    /// observation for back in nav bar
    var webViewBackListObserver: NSKeyValueObservation?
    /// observation for progress loading for the page
    private var progressObservation: NSKeyValueObservation?
    /// observation for changing title in the page
    private var titleObservation: NSKeyValueObservation?
    /// height  for top bar
    private let topViewHeight: CGFloat = 65

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        VFGWebViewManager.trackView()
        setupAccessibilityIdentifiers()
        setupVoiceOverAccessibility()
    }

    /// observe for back list in the webView
    private func observeBackSetup() {
        webViewBackListObserver = webView.observe(\.canGoBack, options: .new) { [weak self] _, _ in
            self?.backButtonSetup()
        }
    }

    /// observe for changing title in the webView
    private func observeTitleChanges() {
        if viewModel?.title != nil { return }
        titleObservation = webView.observe(\WKWebView.title, options: .new) { [weak self] webView, _ in
            if let title = webView.title {
                self?.pageHeaderLabel.text = title
                self?.pageHeaderLabel.accessibilityIdentifier = "WVpageTitle"
            }
        }
    }
    /// observe for changing progress for loading page  in the webView
    private func observeProgress() {
        progressObservation = webView.observe(\WKWebView.estimatedProgress, options: .new) { [weak self] webView, _ in
            self?.updateProgressBar(value: Float(webView.estimatedProgress))
        }
    }

    /// update progress bar visibility according to progress value
    /// - Parameters:
    ///   - value: value which represent progress of loading page
    func updateProgressBar(value: Float) {
        guard let shouldHideSeparatorWhenFinishLoading = viewModel?.shouldHideSeparatorWhenFinishLoading,
            shouldHideSeparatorWhenFinishLoading else {
                progressView.progress = value >= 1 ? 0 : value
                return
            }
        progressView.progress = value
        progressView.isHidden = value >= 1 && shouldHideSeparatorWhenFinishLoading
    }

    /// setup views and apply configuration from view model
    func setupView() {
        progressView.progress = 0
        progressView.isHidden = false
        let extraFrameSpace: CGFloat = UIScreen.screenHasNotch ? 0 : 30
        let webViewFrame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.maxY - webViewContainer.frame.minY + extraFrameSpace)

        var configuration: WKWebViewConfiguration?
        if let viewModelConfiguration = viewModel?.webConfiguration {
            configuration = viewModelConfiguration
        }

        if let scriptModel = viewModel?.scriptModel, let handler = scriptModel.handler {
            if configuration == nil {
                configuration = WKWebViewConfiguration()
            }
            for name in scriptModel.scriptHandlerNames {
                configuration?.userContentController.add(handler, name: name)
            }
        }

        if viewModel?.shouldShowHeaderView == true {
            showHeaderView()
        } else {
            hideHeaderView()
        }
        pageHeaderLabel.text = viewModel?.title

        if let customWebView = viewModel?.customWebView {
            customWebView.frame = webViewFrame
            webView = customWebView
        } else if let webViewConfiguration = configuration {
            webView = WKWebView(frame: webViewFrame, configuration: webViewConfiguration)
        } else {
            webView = WKWebView(frame: webViewFrame)
        }

        webView.navigationDelegate = self

        if let urlString = viewModel?.urlString,
            urlString.isEmpty == false {
            guard let url = URL(string: urlString) else { return }

            // If urlString is not empty, load with URL.
            webView.load(URLRequest(url: url))
        } else {
            guard let htmlString = viewModel?.htmlString,
                htmlString.isEmpty == false else { return }

            // If urlString is empty and htmlString is not empty, load with htmlString.
            webView.loadHTMLString(htmlString, baseURL: nil)
        }

        webViewContainer.addSubview(webView)

        pageHeaderLabel.font = .vodafoneRegular(19)
        pageHeaderLabel.textColor = .VFGPrimaryText

        refreshButton.isHidden = viewModel?.refreshButtonIsHidden ?? false
        backButtonSetup()
        observeProgress()
        observeTitleChanges()
        observeBackSetup()
    }
    /// setup accessibility identifiers
    func setupAccessibilityIdentifiers() {
        webView.accessibilityIdentifier = "VFGwebView"
    }

    deinit {
        titleObservation = nil
        progressObservation = nil
        webViewBackListObserver = nil
    }

    // MARK: private methods
    private func backButtonSetup() {
        let isHidden = viewModel?.backButtonAlwaysHidden ?? false || !webView.canGoBack
        let backHiddenConstant = CGFloat(16)
        let backAvailableConstant = CGFloat(54)
        backButton.isHidden = isHidden
        leadingConstraintRefreshButton.constant = isHidden ? backHiddenConstant : backAvailableConstant
        view.layoutSubviews()
    }
    /// show top bar view
    public func showHeaderView() {
        topBarView.isHidden = false
        topBarViewHeightConstraint.constant = topViewHeight
    }
    /// hide top bar view
    public func hideHeaderView() {
        topBarView.isHidden = true
        topBarViewHeightConstraint.constant = 0
    }

    public func showRefreshButton() {
        refreshButton.isHidden = false
    }

    public func hideRefreshButton() {
        refreshButton.isHidden = true
    }

    // MARK: Actions
    @IBAction func closeButton(_ sender: Any) {
        guard let delegate = delegate else {
            dismiss(animated: true)
            return
        }
        delegate.close(sender: self)
    }
    /// refresh button action
    @IBAction func refreshButton(_ sender: Any) {
        refreshButtonAction()
    }
    @objc func refreshButtonAction() {
        guard let delegate = delegate else {
            webView.reload()
            return
        }
        delegate.refreshButtonDidTap(sender: self)
    }
    /// back button action
    @IBAction func backButton(_ sender: Any) {
        webView.goBack()
    }
}

extension VFGWebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation?) {
        backButtonSetup()
        delegate?.didFinish(sender: self)
    }

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation?) {
        delegate?.didStartProvisionalNavigation(sender: self)
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation?, withError error: Error) {
        delegate?.didFailProvisionalNavigation(sender: self, withError: error)
    }

    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let delegate = delegate else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        delegate.didReceive(sender: self, challenge: challenge, completionHandler: completionHandler)
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let delegate = delegate else {
            decisionHandler(.allow)
            return
        }
        delegate.decidePolicyFor(sender: self, response: navigationResponse, handler: decisionHandler)
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let delegate = delegate else {
            decisionHandler(.allow)
            return
        }
        delegate.decidePolicyFor(sender: self, action: navigationAction, handler: decisionHandler)
    }
}

extension VFGWebViewController {
    func setupVoiceOverAccessibility() {
        pageHeaderLabel.accessibilityLabel = pageHeaderLabel.text ?? ""
        accessibilityCustomActions = [refreshButtonVoiceOverAction()]
        accessibilityCustomActions?.append(backButtonVoiceOverAction())
    }

    func refreshButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "refresh"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(refreshButtonAction))
    }

    func backButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "back action"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(closeButton(_:)))
    }
}
