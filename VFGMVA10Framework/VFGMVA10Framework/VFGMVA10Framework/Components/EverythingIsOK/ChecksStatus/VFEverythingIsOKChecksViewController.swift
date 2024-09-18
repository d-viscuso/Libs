//
//  VFEverythingIsOKChecksViewController.swift
//  VFGMVA10Group
//
//  Created by Sandra Morcos on 3/19/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// Everything Is Okay Checks View Controller
public class VFEverythingIsOKChecksViewController: VFGBaseViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    @IBOutlet weak var descriptionLabelContainer: UIView!
    @IBOutlet weak var checksTableView: UITableView!
    @IBOutlet weak var closeButton: VFGButton!
    @IBOutlet weak var logoImageView: VFGImageView!
    @IBOutlet weak var myProductsButton: VFGButton!

    let checkHeaderID = "checkHeaderCell"
    let checkFailedCellID = "checkFailedCell"
    let appManager = VFGManagerFramework.appSettingsDelegate
    let actions = VFGManagerFramework.eioDelegate?.eiokActions()
    var checks: [VFCheckItemViewModel] = []
    /// EIO Setup Model
    public var eioModel: VFGEIOModelProtocol?
    var transitionInteractor: VFGTransitionInteractor?
    var alreadyFailed = false
    var oldOverallStatus: EIOStatus?
    var shouldReloadOnAppear = true
    var openFailedSectionsWithDelay = true
    var firstEnter = true
    weak var delegate: UpdateDashboardSectionHeightDelegate?
    var isAutoTrayAnimationEnabled = true
    var myProductsImage: UIImage?
    public override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setupTableViewUI()
        setupTableViewData()
        setupVoiceOverAccessibility()
    }

    @objc func willEnterForeground() {
        checksTableView.reloadData()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        closeAllSections()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.layer.sublayers?.first?.frame = backgroundView.bounds
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let eioStatus = eioModel?.eioStatus else { return }
        // if overall status inprogress close all the sections
        if shouldReloadOnAppear {
            if eioStatus == .inProgress {
                closeAllSections()
                oldOverallStatus = eioStatus
                firstEnter = false
            } else {
                if !firstEnter {
                    openFailedSections()
                } else {
                    if openFailedSectionsWithDelay {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                            guard let self = self else { return }
                            self.firstEnter = false
                            self.openFailedSections()
                        }
                    } else {
                        firstEnter = false
                        openFailedSections()
                    }
                }
            }
            updateBackground(eioStatus)
            checks.forEach {
                $0.wasExpanded = $0.status == .failed ? true : $0.wasExpanded
            }
            oldOverallStatus = eioStatus
        }
        setupUI(shouldReloadOnAppear: shouldReloadOnAppear)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        if eioModel?.eioStatus == .success {
            return .default
        } else {
            return .lightContent
        }
    }

    func setupTableViewData() {
        guard let checkModels = eioModel?.model?.checks else { return }
        checks = checkModels.compactMap { VFCheckItemViewModel(checkModel: $0) }
    }

    func registerCells() {
        let failedXib = UINib(nibName: "VFEverythingIsOkCheckFailedCell", bundle: Bundle.mva10Framework)
        checksTableView.register(failedXib, forCellReuseIdentifier: checkFailedCellID)
        let headerXib = UINib(nibName: "VFEverythingIsOKChecksHeaderCell", bundle: Bundle.mva10Framework)
        checksTableView.register(headerXib, forHeaderFooterViewReuseIdentifier: checkHeaderID)
    }

    @IBAction func closeButtonTapped(_ sender: VFGButton) {
        closeButtonAction()
    }

    @objc func closeButtonAction() {
        delegate?.updateEIOKStatus(completion: nil)
        if let trayVC = self.trayViewController() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                trayVC.showTrayAnimation()
            }
        }
        dismiss(animated: true, completion: nil)
    }

    func headerTapped(for section: Int) {
        VFEverythingIsOkCheckFailedCell.isClicked = true
        VFEverythingIsOKChecksHeaderCell.isClicked = true
        let checkModel = checks[section]
        checkModel.wasExpanded = checkModel.willExpand
        checkModel.willExpand.toggle()
        if let headerView = self.checksTableView.headerView(forSection: section) as? VFEverythingIsOKChecksHeaderCell {
            headerView.indicatorImageView.alpha = 0
        }
        checksTableView.reloadSections([section], with: .automatic)
    }

    func updateBackground(_ eioStatus: EIOStatus) {
        let startPoint = CGPoint(x: 1.0, y: 0.0)
        backgroundView.layer.sublayers?.removeAll()
        if eioStatus == .success {
            if #available(iOS 12.0, *) {
                var gradientColor = UIColor.VFGDashBoardLightGradient
                if traitCollection.userInterfaceStyle == .dark {
                    gradientColor = UIColor.VFGDashBoardDarkGradient
                }
                backgroundView.setGradientBackgroundColor(
                    colors: gradientColor,
                    startPoint: startPoint
                )
            }
        } else {
            backgroundView.setGradientBackgroundColor(
                colors: UIColor.VFGDiscoverRedGradient,
                startPoint: startPoint
            )
        }
    }

    func openFailedSections() {
        checks.forEach {
            $0.wasExpanded = $0.status == .failed ? false : $0.willExpand
            $0.willExpand = $0.status == .failed ? true : false
        }
        reloadAllSections()
    }
}

extension VFEverythingIsOKChecksViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}

extension VFEverythingIsOKChecksViewController: VFGTrayContainerProtocol {
    /// tobi identifier key
    public var tobiKey: String {
        "VFEverythingIsOKChecksViewController"
    }

    /// tobi style 
    public var trayStyle: VFGTrayStyle {
        isAutoTrayAnimationEnabled ? .none : .noChange
    }
}

// MARK: - Update CGColors with TraitCollection
extension VFEverythingIsOKChecksViewController {
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                guard let eioStatus = eioModel?.eioStatus else { return }
                updateBackground(eioStatus)
            }
        }
    }
}
