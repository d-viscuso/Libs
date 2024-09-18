//
//  VFGBaseSubtrayView.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 12/21/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Sub tray base view
public class VFGBaseSubtrayView: UIView, VFGSubtrayViewProtocol, VFGSubtrayViewAnimatable {
    // MARK: - VFGSubtrayViewProtocol variables
    @IBOutlet public weak var collectionView: UICollectionView?
    public weak var delegate: VFGSubtrayViewDelegate?
    public weak var dataSource: VFGSubtrayViewDataSource?
    public var error: Error? {
        didSet {
            guard let error = error,
                let onRefresh = onRefresh else {
                    return
            }

            showError(error, onRefresh: onRefresh)
        }
    }

    public var informationText: String? {
        didSet {
            guard let informationText = informationText else {
                informationView?.removeFromSuperview()
                return
            }
            showInformationView(title: informationText)
        }
    }
    /// Determine if sub tray can be customized or not
    var isSubTrayCustomizable: Bool {
        let metaData = dataModel?.metaData
        return metaData?["isSubTrayItemCustomizable"] as? Bool ?? false
    }
    /// Sub tray information view
    lazy var informationView: VFGInformationView? = VFGInformationView.loadXib(bundle: .mva10Framework)
    public var dataModel: VFGSubTrayModel?
    public var sheetViewBottomConstraintTrayContent: CGFloat = 0
    public var height: CGFloat = 0
    public var title: String?
    public var enableAutoSwitchToVerticalSubTray: Bool?
    private let extraTopSpaceForErrorView: CGFloat = 30

    // MARK: - VFGBaseSubtrayView variables
    @IBOutlet public weak var subtitleLabel: VFGLabel?
    let shimmerCellId = "VFGSubTrayShimmerCell"
    /// Sub tray view refresh handler
    public var onRefresh: (() -> Void)?
    /// Sub tray view subtitle
    public var subtitle: String?
    /// Sub tray view type
    var type: String?
    /// Sub tray view data list
    public lazy var categories: [String] = {
        guard let dataSource = dataModel else {
            return []
        }

        var categories: [String] = ["sub_tray_all_category".localized(bundle: .mva10Framework)]

        dataSource.items?.forEach { item in
            if let category = item.category?.localized(),
                !categories.contains(category) {
                    categories.append(item.category?.localized() ?? "")
            }
        }

        return categories
    }()
    /// Sub tray view badge delegate
    var badgeDelegates: [Int: VFGSubtrayBadgesProtocol?] = [:]

    // MARK: - VFGSubtrayViewProtocol init + methods
    /// *VFGBaseSubtrayView* initializer
    /// - Parameters:
    ///    - title: Sub tray view title
    ///    - subtitle: Sub tray view subtitle
    ///    - onRefresh: Sub tray view refresh handler
    ///    - height: Sub tray view height
    ///    - sheetViewBottomConstraintTrayContent: Bottom contraint constant for sheet view
    init(
        _ title: String,
        _ subtitle: String,
        _ onRefresh: @escaping () -> Void,
        _ height: CGFloat,
        _ sheetViewBottomConstraintTrayContent: CGFloat = 0
    ) {
        self.title = title
        self.subtitle = subtitle
        self.onRefresh = onRefresh
        self.height = height
        self.sheetViewBottomConstraintTrayContent = sheetViewBottomConstraintTrayContent
        dataSource = VFGManagerFramework.trayDelegate?.subtrayDataSource

        super.init(frame: CGRect.zero)
        addBadgesObserver()
    }

    required public init(_ title: String, _ subtitle: String, _ onRefresh: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.onRefresh = onRefresh

        super.init(frame: CGRect.zero)
        addBadgesObserver()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addBadgesObserver()
    }

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: .VFGBadgesTrackerID,
            object: nil
        )
    }

    private func addBadgesObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateBadges(notification:)),
            name: .VFGBadgesTrackerID,
            object: nil
        )
    }

    @objc private func updateBadges(notification: Notification) {
        badgeDelegates.forEach {
            $0.value?.badgeDidUpdate(newBadges: notification.userInfo as? [String: BadgeModel])
        }
    }
    /// *VFGBaseSubtrayView* collection view data reload
    public func reloadViews() {
        collectionView?.reloadData()
        collectionView?.setContentOffset(.zero, animated: false)
    }

    // MARK: - VFGBaseSubtrayView methods
    /// *VFGBaseSubtrayView* error message display
    /// - Parameters:
    ///    - error: *VFGBaseSubtrayView* error type
    ///    - onRefresh: Sub tray view refresh handler
    func showError(_ error: Error, onRefresh: @escaping () -> Void) {
        guard let errorView: ErrorCard = UIView.loadXib(bundle: .foundation) else {
            return
        }

        errorView.configure(
            errorMessage: error.localizedDescription,
            tryAgainMessage: "sub_tray_error_try_again_button".localized(bundle: .mva10Framework),
            accessibilityIdInitial: "STerror"
        )

        errorView.frame = CGRect(
            origin: .zero,
            size: CGSize(width: bounds.width, height: 200))
        let errorViewTopMargin = (subtitleLabel?.frame.height ?? 0) + extraTopSpaceForErrorView
        errorView.center = CGPoint(
            x: frame.size.width / 2,
            y: (frame.size.height / 2) + errorViewTopMargin)
        collectionView?.isHidden = true

        errorView.onTryAgain = { [weak self] in
            guard let self = self,
                let collectionView = self.collectionView else {
                return
            }

            errorView.removeFromSuperview()
            collectionView.isHidden = false
            self.subtitleLabel?.isHidden = false
            self.collectionView?.reloadData()

            onRefresh()
        }

        addSubview(errorView)
    }
    /// Display sub tray information view
    /// - Parameters:
    ///    - title: Sub tray information view title
    public func showInformationView(title: String) {
        guard let informationView = informationView else {
            return
        }

        informationView.configure(title: title)
        informationView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 200)
        subtitleLabel?.isHidden = true
        collectionView?.isHidden = true

        if !informationView.isDescendant(of: self) {
            embed(view: informationView)
        }
    }
    /// Sub tray view type extraction
    func extractType() {
        guard let title = dataModel?.title?.localized(bundle: .mva10Framework) else {
            return
        }

        subtitleLabel?.accessibilityIdentifier = "ST\(title)SubTitle"
        let typeNameArray = title.split(separator: " ")
        if typeNameArray.count == 2 {
            self.type = String(typeNameArray[1]).lowercased()
        } else {
            self.type = String(typeNameArray.first ?? "").lowercased()
        }
        self.title = title
    }
}
