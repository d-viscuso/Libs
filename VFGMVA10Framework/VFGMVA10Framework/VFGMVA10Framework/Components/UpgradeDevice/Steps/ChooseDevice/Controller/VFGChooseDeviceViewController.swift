//
//  VFGChooseDeviceViewController.swift
//  VFGMVA10Framework
//
//  Created by Moamen Abd Elgawad on 19/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//
import VFGMVA10Foundation

class VFGChooseDeviceViewController: UIViewController, VFGBaseUpgradeStepsViewControllerProtocol {
    // MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var subtitleLabel: VFGLabel!

    // MARK: Constants
    var stepTitle: String = "device_upgrade_choose_step_title".localized(bundle: .mva10Framework)
    let leftInset: CGFloat = 16.0
    let cellWidth: CGFloat = 290
    let cellHeight: CGFloat = 520
    var cellSize: CGSize = .zero
    lazy var contentHeight: CGFloat = {
        collectionView.contentSize.height + collectionView.frame.origin.y
    }()
    lazy var viewModel: ChooseDeviceViewModel = {
        ChooseDeviceViewModel(
            dataProvider: ChooseDeviceDataProvider()
        )
    }()
    var onStepComplete: ((Any) -> Void)?
    var onContentHeightChange: ((CGFloat) -> Void)?
    var onPriceChange: ((Any) -> Void)?
    var onStepStatusChange: ((VFGStepStatus) -> Void)?
    var status: VFGStepStatus = .inProgress
    static var instance: VFGBaseUpgradeStepsViewControllerProtocol {
        UIStoryboard(
            name: "VFGChooseDeviceViewController",
            bundle: .mva10Framework
        ).instantiateViewController(withIdentifier: "VFGChooseDeviceViewController")
        as? VFGChooseDeviceViewController ?? VFGChooseDeviceViewController()
    }
    let VFGChooseDeviceCollectionCellId = "VFGChooseDeviceCollectionCell"

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupCollectionView()
        initViewModel()
        setupAccessibilityLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.contentState == .populated {
            onContentHeightChange?(contentHeight)
        }
    }

    func initViewModel() {
        viewModel.updateLoadingStatus = { [weak self] in
            guard let self = self else {
                return
            }

            switch self.viewModel.contentState {
            case .loading:
                VFGDebugLog("loading")
            case .populated:
                self.collectionView.reloadData()
                self.onContentHeightChange?(self.contentHeight)
            case .empty:
                VFGDebugLog("empty")
            case .error:
                VFGDebugLog("error")
            case .filtered:
                VFGDebugLog("filter")
            }
        }

        viewModel.fetchDevices()
    }

    func configureUI() {
        subtitleLabel.text = "device_upgrade_choose_step_header".localized(bundle: .mva10Framework)
    }

    func setupCollectionView() {
        collectionView?.dataSource = self
        collectionView?.delegate = self

        registerChooseDeviceCollectionCell()

        let layout = UICollectionViewFlowLayout()

        cellSize = CGSize(width: cellWidth, height: cellHeight)
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal

        collectionView?.collectionViewLayout = layout
    }

    func registerChooseDeviceCollectionCell() {
        let addOnsCell = UINib(nibName: VFGChooseDeviceCollectionCellId, bundle: Bundle.mva10Framework)
        collectionView.register(addOnsCell, forCellWithReuseIdentifier: VFGChooseDeviceCollectionCellId)
    }
}

extension VFGChooseDeviceViewController {
    /// setup accessibility labels
    func setupAccessibilityLabel() {
        subtitleLabel.accessibilityLabel = "device_upgrade_choose_step_header".localized(bundle: .mva10Framework)
    }
}
