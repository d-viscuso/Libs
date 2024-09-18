//
//  DeviceViewController.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 4/9/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//
import VFGMVA10Foundation
/// Device view controller.
public class DeviceViewController: UIViewController, BaseTabsViewController {
    @IBOutlet var shimmerViews: [VFGShimmerView]!
    @IBOutlet weak var shimmerContainerView: UIView!
    @IBOutlet weak var currentDeviceTitleLabel: VFGLabel!
    @IBOutlet weak var deviceDetailsTitleLabel: VFGLabel!
    @IBOutlet weak var deviceDetailsCardView: UIView!

    @IBOutlet weak var deviceModel: VFGLabel!
    @IBOutlet weak var deviceOwnerLabel: VFGLabel!
    @IBOutlet weak var upgradeNowButton: VFGButton!
    @IBOutlet weak var devicePrice: VFGLabel!
    @IBOutlet weak var contractEndDate: VFGLabel!
    @IBOutlet weak var upgradePriceTitleLabel: VFGLabel!
    @IBOutlet weak var contractEndDateTitleLabel: VFGLabel!

    public weak var rootViewController: (UIViewController & BaseTabsViewControllerDelegate)?
    public var updateHeightClosure: ((CGFloat) -> Void)?
    public var setHeightClosure: ((CGFloat) -> Void)?
    public var deviceViewModel: DeviceViewModelProtocol?
    private let shimmerContainerTopMargin: CGFloat = 16
    /// Call upgradeButtonDidPress function from deviceViewController instance
    /// This method may be used to navigate to another view controller
    public var upgradeButtonDidPress: ((DeviceViewController) -> Void)?
    private let errorCardTopMargin: CGFloat = 56
    var errorCardView: VFGErrorView?

    public required init(
        nibName: String = String(describing: DeviceViewController.self),
        bundle: Bundle = Bundle.mva10Framework
    ) {
        super.init(nibName: nibName, bundle: bundle)
        title = "device_screen_title".localized(bundle: Bundle.mva10Framework)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        initViewModel()
        setupUI()
        setupAccessibilityLabels()
    }

    func initViewModel() {
        deviceViewModel?.updateLoadingStatus = { [weak self] in
            guard let self = self else { return }
            let contentState = self.deviceViewModel?.contentState
            switch contentState {
            case .loading:
                self.deviceDetailsCardView.isHidden = true
                self.displayShimmerView()
                self.setHeightClosure?( self.deviceDetailsCardView.bounds.height)
            case .populated:
                self.deviceDetailsCardView.isHidden = false
                self.hideShimmerView()
                self.configureDeviceDetailsCardView()
                self.updateHeightClosure?(self.view.bounds.height)
                self.rootViewController?.dataFetchingDidComplete()
            case .error:
                self.deviceDetailsTitleLabel.text = ""
                self.deviceDetailsCardView.isHidden = true
                self.hideShimmerView()
                self.setupErrorCardView()
                self.updateHeightClosure?(self.view.bounds.height)
                self.rootViewController?.dataFetchingDidComplete()
            default:
                break
            }
        }
        rootViewController?.dataFetchingWillStart()
        deviceViewModel?.fetchDeviceDetails()
    }

    public func refresh() {
        guard deviceModel != nil else {
            return
        }

        rootViewController?.dataFetchingWillStart()
        deviceViewModel?.fetchDeviceDetails()
    }

    func setupUI() {
        deviceDetailsCardView?.layer.cornerRadius = 6
        deviceDetailsCardView?.addingShadow(size: CGSize(width: 0, height: 2), radius: 8, opacity: 0.16)
        upgradeNowButton?.setTitle(
            "my_device_upgrade_button_title".localized(bundle: .mva10Framework),
            for: .normal)
        upgradePriceTitleLabel?.text = "my_device_upgrade_offer_label".localized(bundle: .mva10Framework)
        contractEndDateTitleLabel?.text = "my_device_contract_end_date_label".localized(bundle: .mva10Framework)
        currentDeviceTitleLabel?.text = "my_device_screen_title".localized(bundle: .mva10Framework)
        deviceDetailsTitleLabel?.text = "my_device_screen_subtitle".localized(bundle: .mva10Framework)
        currentDeviceTitleLabel.accessibilityIdentifier = "PSCurrentDeviceTitleLabel"
        deviceDetailsTitleLabel.accessibilityIdentifier = "PSDeviceDetailsLabel"
        deviceModel.accessibilityIdentifier = "PSDeviceModelLabel"
        upgradePriceTitleLabel.accessibilityIdentifier = "PSUpgradePriceTitleLabel"
        devicePrice.accessibilityIdentifier = "PSDevicePriceLabel"
        upgradeNowButton.accessibilityIdentifier = "PSUpgradeNowButton"
    }

    @IBAction func upgradeButtonDidPress(_ sender: VFGButton) {
        upgradeButtonAction()
    }
    @objc func upgradeButtonAction() {
        upgradeButtonDidPress?(self)
    }

    func configureDeviceDetailsCardView() {
        guard let model = deviceViewModel?.deviceDetails else { return }
        deviceModel?.text = model.deviceName
        devicePrice?.text = model.upgradePrice
        contractEndDate?.text = model.contractEndDate
        deviceOwnerLabel?.text = model.deviceOwnerDetails
    }

    func displayShimmerView() {
        setupShimmerContainerView()
        startShimmerViewsAnimation()
        showShimmerView()
        setupAccessibilityIdentifiers()
    }

    private func setupShimmerContainerView() {
        view.addSubview(shimmerContainerView)
        shimmerContainerView.translatesAutoresizingMaskIntoConstraints = false
        shimmerContainerView.topAnchor
            .constraint(equalTo: deviceDetailsTitleLabel.bottomAnchor, constant: shimmerContainerTopMargin)
            .isActive = true
        shimmerContainerView.leadingAnchor.constraint(equalTo: deviceDetailsCardView.leadingAnchor).isActive = true
        shimmerContainerView.trailingAnchor.constraint(equalTo: deviceDetailsCardView.trailingAnchor).isActive = true

        shimmerContainerView.layer.cornerRadius = 6
        shimmerContainerView.addingShadow(size: CGSize(width: 0, height: 2), radius: 8, opacity: 0.16)
    }

    private func startShimmerViewsAnimation() {
        shimmerViews.forEach { shimmeredView in
            shimmeredView.startAnimation()
        }
    }

    func showShimmerView() {
        shimmerContainerView.isHidden = false
    }

    func hideShimmerView() {
        shimmerContainerView.isHidden = true
    }

    func setupAccessibilityIdentifiers() {
        view.accessibilityIdentifier = "PSDcontainerView"
        shimmerContainerView.accessibilityIdentifier = "PSDshimmerView"
    }

    func setupErrorCardView() {
        guard errorCardView == nil else { return }
        let errorDescription = "my_device_screen_error_message".localized(bundle: .mva10Framework)
        let tryAgainDescription = "my_device_screen_try_again".localized(bundle: .mva10Framework)
        let errorModel = VFGErrorModel(
            title: "",
            description: errorDescription,
            tryAgainText: tryAgainDescription
        )
        errorCardView = VFGErrorView(
            error: errorModel,
            accessibilityIdInitial: "PSdeviceError"
        )
        errorCardView?.tryAgainLabel.text = tryAgainDescription

        guard let errorCardView = errorCardView else { return }

        view.addSubview(errorCardView)

        errorCardView.translatesAutoresizingMaskIntoConstraints = false
        errorCardView.topAnchor
            .constraint(equalTo: currentDeviceTitleLabel.bottomAnchor, constant: errorCardTopMargin)
            .isActive = true
        errorCardView.leadingAnchor.constraint(equalTo: deviceDetailsCardView.leadingAnchor).isActive = true
        errorCardView.trailingAnchor.constraint(equalTo: deviceDetailsCardView.trailingAnchor).isActive = true

        errorCardView.refreshingClosure = { [weak self] in
            guard let self = self else { return }
            self.refresh()
        }
    }
}

extension DeviceViewController {
    func setupAccessibilityLabels() {
        currentDeviceTitleLabel.accessibilityLabel = currentDeviceTitleLabel.text ?? ""
        deviceDetailsTitleLabel.accessibilityLabel = deviceDetailsTitleLabel.text ?? ""
        deviceModel.accessibilityLabel = deviceModel.text ?? ""
        devicePrice.accessibilityLabel = devicePrice.text ?? ""
        contractEndDate.accessibilityLabel = contractEndDate.text ?? ""
        upgradePriceTitleLabel.accessibilityLabel = upgradePriceTitleLabel.text ?? ""
        contractEndDateTitleLabel.accessibilityLabel = contractEndDateTitleLabel.text ?? ""
        upgradeNowButton.accessibilityLabel = upgradeNowButton.titleLabel?.text ?? ""
        accessibilityCustomActions = [upgradeVoiceOverAction()]
    }
    /// action for product upgrade  voice over
    /// - Returns: action for product upgrade  button in voice over

    func upgradeVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "upgrade"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(upgradeButtonAction))
    }
}
