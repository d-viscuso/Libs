//
//  VFGPermissionsViewController.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/26/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Delegation for *VFGPermissionsViewController* actions
public protocol VFGSettingItemProtocol: AnyObject {
    init()
    /// Return *VFGPermissionsViewController*
    static func viewController() -> UIViewController?
}

public class VFGPermissionsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerTextView: UITextView!
    @IBOutlet weak var settingsTextView: UITextView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    /// Permissions view model
    public var viewModel: VFPermissionsViewModel?

    override public func viewDidLoad() {
        super.viewDidLoad()

        setTitle()
        initViewModel()
        configureTableStyle()
        configureFooterTextView()
        addObservers()
        view.backgroundColor = .VFGLightGreyBackground
        AppSettingsManager.trackView(
            pageName: "analytics_framework_page_name_device_permissions".localized(bundle: .mva10Framework)
        )
    }
    /// *VFGPermissionsViewController* table view configuration
    func configureTableStyle() {
        tableView.layer.cornerRadius = 6.0
        tableView.addingShadow(
            size: CGSize(
                width: 0,
                height: 2),
            radius: 8,
            opacity: 0.16)
        tableView.backgroundColor = .VFGWhiteBackground
    }
    /// Settings device permissions navigation controller title
    func setTitle() {
        if let mva10NavigationController = navigationController as? MVA10NavigationController {
            let accessibilityId = "DPmainTitle"
            mva10NavigationController.setTitle(
                title: "settings_device_permissions_title".localized(bundle: Bundle.mva10Framework),
                accessibilityID: accessibilityId,
                for: self)
            mva10NavigationController.setAccessibilityLabels(
                closeButtonLabel: "close",
                backButtonLabel: "back",
                titleAccessibilityLabel: "settings_device_permissions_title".localized(bundle: Bundle.mva10Framework)
            )
        }
    }
    /// Permissions view model initialization
    func initViewModel() {
        viewModel?.delegate = self
        viewModel?.setupPermissionCards()
    }

    /// Refetch permission when coming from background or another app
    @objc func didBecomeActive() {
        viewModel?.setupPermissionCards()
    }
    /// Footer text view setup
    func configureFooterTextView() {
        footerTextView.text = "permissions_footer_text".localized(bundle: Bundle.mva10Framework)
        footerTextView.accessibilityIdentifier = "DPfooterText"
        footerTextView.accessibilityLabel = footerTextView.text
        let originalText = "permissions_settings_hypertext".localized(bundle: Bundle.mva10Framework)
        settingsTextView.hyperLink(
            originalText: originalText,
            hyperLinks: [
                (link: originalText, target: VFGDevicePermissionTarget.openSettings.rawValue)
            ],
            linkColor: UIColor.VFGLinkDarkGreyText,
            alignment: .center,
            font: UIFont.vodafoneRegular(16.6))
        settingsTextView.accessibilityIdentifier = "DPtapSettings"
        settingsTextView.accessibilityLabel = settingsTextView.text
        settingsTextView.delegate = self
    }

    /// Create and add NSNotification observers
    func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
    }
}

extension VFGPermissionsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfEnabledPermissions() ?? 0
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PermissionsTableViewCell", for: indexPath)

        guard let permissionCardViewModel = viewModel?.getPermissionCardViewModel(at: indexPath.row),
            let permissionCardView: VFPermissionViewCard =
            VFPermissionViewCard.loadXib(bundle: Bundle.mva10Framework) else {
                return cell
        }

        permissionCardView.configureForSettings(
            with: permissionCardViewModel,
            isReadOnly: true,
            isFirstCell: indexPath.row == 0,
            accessibilityIdentifierPrefix: "DP")
        // Set delegate for hyperlink in textView
        permissionCardView.requestTextView.delegate = self

        if !cell.contentView.subviews.isEmpty {
            cell.contentView.removeSubviews()
        }

        cell.contentView.embed(view: permissionCardView)

        return cell
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = true
    }
}

// MARK: - VFGDevicePermissionsViewController (UITextView Delegate)
extension VFGPermissionsViewController: UITextViewDelegate {
    public func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange
    ) -> Bool {
        handleTextViewHyperLink(URL)
        return false
    }

    func handleTextViewHyperLink(_ link: URL) {
        switch link.absoluteString {
        case VFGDevicePermissionTarget.openSettings.rawValue:
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        case VFGDevicePermissionTarget.requestContact.rawValue:
            viewModel?.requestPermission(permissionType: .contacts) { status, _ in
                VFGDebugLog("status:\(status)")
            }
        case VFGDevicePermissionTarget.requestLocation.rawValue:
            viewModel?.requestPermission(permissionType: .locationWhileUsage) { status, _ in
                VFGDebugLog("status:\(status)")
            }
        case VFGDevicePermissionTarget.requestPushNotifications.rawValue:
            viewModel?.requestPermission(permissionType: .pushNotifications) { status, _ in
                VFGDebugLog("status:\(status)")
            }
        default:
            break
        }
    }
}

extension VFGPermissionsViewController: VFPermissionViewModelProtocol {
    func permissionCardsDidSetup() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }

            let offset = self.tableView.contentOffset
            self.tableViewHeightConstraint.constant = .greatestFiniteMagnitude
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
            // Force layout so things are updated before resetting the contentOffset.
            self.tableView.setContentOffset(offset, animated: false)
            self.tableViewHeightConstraint.constant = self.tableView.contentSize.height
        }
    }
}

extension VFGPermissionsViewController: VFGSettingItemProtocol {
    public static func viewController() -> UIViewController? {
        return VFGPermissionsViewController.instance(
            from: "VFGPermission",
            with: "VFGPermissionViewController",
            bundle: Bundle.mva10Framework)
    }
}

extension VFGPermissionsViewController: VFGTrayContainerProtocol {
    public var tobiKey: String {
        "VFGPermissionsViewController"
    }

    public var trayStyle: VFGTrayStyle {
        .TOBI
    }
    public var tobiContainerVC: UIViewController? {
        return VFGManagerFramework.tobiDelegate?.helpViewController(for:
            "\(VFGPermissionsViewController.self)")
    }
}

enum VFGDevicePermissionTarget: String {
    case openSettings = "myapp://settings"
    case requestContact = "myapp://contacts"
    case requestLocation = "myapp://location"
    case requestPushNotifications = "myapp://pushNotifications"
}
