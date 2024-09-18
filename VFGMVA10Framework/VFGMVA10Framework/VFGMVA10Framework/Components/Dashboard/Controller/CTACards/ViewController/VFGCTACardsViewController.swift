//
//  VFGCTACardsViewController.swift
//  VFGMVA10Framework
//
//  Created by İhsan Kahramanoğlu on 1/16/23.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// A class which represents the second level screen with all cards which might be large or small CTA cards vertically aligned so the user scrolls down the content to view all the offers
public class VFGCTACardsViewController: UIViewController {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var cardsCollectionView: UICollectionView!

    public var viewModel: VFGCTACardsViewModel?
    var cardHeight: CGFloat {
        guard let layoutType = viewModel?.getLayoutType()
        else { return BannerCTACardCollectionViewCell.largeCardCellHeight }

        switch layoutType {
        case .small:
            return BannerCTACardCollectionViewCell.smallCardCellHeight
        case .large:
            return BannerCTACardCollectionViewCell.largeCardCellHeight
        }
    }
    private let lineSpacing: CGFloat = 16
    private let cardMargin: CGFloat = 24
    private let margin: CGFloat = 16
    private var titleName: String?

    public convenience init(viewModel: VFGCTACardsViewModel, titleName: String? = nil) {
        self.init(nibName: "VFGCTACardsViewController", bundle: .mva10Framework)
        self.viewModel = viewModel
        self.viewModel?.refreshDelegate = self
        self.titleName = titleName
        modalPresentationStyle = .fullScreen
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setupTitleName()
    }
    private func setupTitleName() {
        self.titleLabel.text = titleName
    }

    private func setUpCollectionView() {
        cardsCollectionView.register(
            UINib(
                nibName: CTACardsDescriptionCollectionViewCell.reuseIdentifier,
                bundle: Bundle.mva10Framework),
            forCellWithReuseIdentifier: CTACardsDescriptionCollectionViewCell.reuseIdentifier
        )
        cardsCollectionView.register(
            UINib(
                nibName: BannerCTACardCollectionViewCell.reuseIdentifier,
                bundle: Bundle.mva10Framework),
            forCellWithReuseIdentifier: BannerCTACardCollectionViewCell.reuseIdentifier
        )
        cardsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cardsCollectionView.dataSource = self
        cardsCollectionView.delegate = self

        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        cardsCollectionView.collectionViewLayout = collectionLayout
        cardsCollectionView.decelerationRate = .fast
        cardsCollectionView.backgroundColor = .VFGLightGreyBackground
    }

    @IBAction func closeButtonClicked(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: UICollectionViewDelegate
extension VFGCTACardsViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 1,
            let card = viewModel?.getCardItem(for: indexPath),
            let delegate = viewModel?.getBannerCTACardDelegate()
        else { return }
        delegate.bannerCTACardViewDidPress(card)
    }
}

// MARK: UICollectionViewDelegate
extension VFGCTACardsViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CTACardsDescriptionCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? CTACardsDescriptionCollectionViewCell
            else { return UICollectionViewCell() }
            cell.config(description: viewModel?.descriptionText)
            return cell
        }
        guard let card = viewModel?.getCardItem(for: indexPath),
            let cardType = viewModel?.getLayoutType(),
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BannerCTACardCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? BannerCTACardCollectionViewCell
        else { return UICollectionViewCell() }
        cell.configure(
            model: card,
            type: cardType,
            delegate: viewModel?.getBannerCTACardDelegate()
        )
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return viewModel?.getNumberOfCards() ?? 0
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension VFGCTACardsViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if indexPath.section == 0 {
            return CTACardsDescriptionCollectionViewCell.getCellSize(for: viewModel?.descriptionText, spacing: margin)
        }

        let totalMargin = margin * 2
        let width: CGFloat = UIScreen.main.bounds.width - totalMargin
        return CGSize(width: width, height: cardHeight)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return lineSpacing
    }
}


// MARK: VFGCTACardsViewRefreshProtocol
extension VFGCTACardsViewController: VFGCTACardsViewRefreshProtocol {
    func refreshCards() {
        cardsCollectionView.reloadData()
    }
}
