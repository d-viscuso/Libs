//
//  VFGWebViewModel.swift
//  VFGMVA10Foundation
//
//  Created by Burak Çokyıldırım on 1.11.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import WebKit
/// A model that used to inject configuration to the webview .

open class VFGWebViewModel {
    var urlString: String = ""
    var htmlString: String = ""
    var scriptModel: VFGWebViewScriptModel?
    var webConfiguration: WKWebViewConfiguration?
    var shouldShowHeaderView: Bool?
    var shouldHideSeparatorWhenFinishLoading = false
    var title: String?
    var customWebView: WKWebView?
    /// a boolean to show or hide refresh button, default is false
    open var refreshButtonIsHidden: Bool?
    /// a boolean to always hide backButton, default is false
    open var backButtonAlwaysHidden: Bool {
        false
    }

    /// - Parameters:
    ///   - urlString: Url that need to load it in the webview
    ///   - scriptModel: Model that injected to web view to execute some scripts
    ///   - webConfig: Configuration that injected to web view
    ///   - shouldShowHeaderView: Boolean that indicate if header view should be shown or not
    ///   - shouldHideSeparatorWhenFinishLoading: Boolean that indicates if the grey separator between the navigation bar and the webview should be hidden after loading the web page is finished.
    ///   - title: Text that represented at the top of web view
    ///   - customWebView: WebView that can be injected to the controller
    public init(
        urlString: String,
        scriptModel: VFGWebViewScriptModel? = nil,
        webConfig: WKWebViewConfiguration? = nil,
        shouldShowHeaderView: Bool = true,
        shouldHideSeparatorWhenFinishLoading: Bool = false,
        title: String? = nil,
        customWebView: WKWebView? = nil,
        refreshButtonIsHidden: Bool = false
    ) {
        self.urlString = urlString
        self.scriptModel = scriptModel
        self.webConfiguration = webConfig
        self.shouldShowHeaderView = shouldShowHeaderView
        self.shouldHideSeparatorWhenFinishLoading = shouldHideSeparatorWhenFinishLoading
        self.title = title
        self.customWebView = customWebView
        self.refreshButtonIsHidden = refreshButtonIsHidden
    }

    /// - Parameters:
    ///   - htmlString: html that need to rendered on the web view 
    ///   - scriptModel: Model that injected to web view to execute some scripts
    ///   - webConfig: Configuration that injected to web view
    ///   - shouldShowHeaderView: Boolean that indicate if header view should be shown or not
    ///   - shouldHideSeparatorWhenFinishLoading: Boolean that indicates if the grey separator between the navigation bar and the webview should be hidden after loading the web page is finished.
    ///   - title: Text that represented at the top of web view
    public init(
        htmlString: String,
        scriptModel: VFGWebViewScriptModel? = nil,
        webConfig: WKWebViewConfiguration? = nil,
        shouldShowHeaderView: Bool = true,
        shouldHideSeparatorWhenFinishLoading: Bool = true,
        title: String? = nil,
        refreshButtonIsHidden: Bool = false
    ) {
        self.htmlString = htmlString
        self.scriptModel = scriptModel
        self.webConfiguration = webConfig
        self.shouldShowHeaderView = shouldShowHeaderView
        self.shouldHideSeparatorWhenFinishLoading = shouldHideSeparatorWhenFinishLoading
        self.title = title
        self.refreshButtonIsHidden = refreshButtonIsHidden
    }
}
