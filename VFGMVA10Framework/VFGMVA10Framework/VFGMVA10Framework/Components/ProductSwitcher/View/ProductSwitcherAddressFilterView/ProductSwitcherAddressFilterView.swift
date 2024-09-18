//
//  ProductSwitcherAddressFilterView.swift
//  VFGMVA10Framework
//
//  Created by Loodos on 10/4/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// Call back delegate for filtering product switcher addresses
protocol ProductSwitcherAddressFilterViewDelegate: AnyObject {
    func addressFilterDidSelect(address: String)
}

class ProductSwitcherAddressFilterView: UIView {
    @IBOutlet weak var filterCollectionView: UICollectionView!
    /// Selected address
    var selectedAddress: String = ""
    /// Call back delegate for filtering
    private var delegate: ProductSwitcherAddressFilterViewDelegate?
    /// Address list for filtering
    private var addressList: [String] = []
    /// default card margin constant
    private let cardMargin: CGFloat = 16
    /// Card margin from right side for dislaying the third card's view's start on the right side of the screen
    private let cardRightMarginForThirdCard: CGFloat = 18
    /// default card width constant
    private var cardWidth: CGFloat {
        let width = UIScreen.main.bounds.width - (cardMargin * 2) - cardRightMarginForThirdCard
        return width / 2
    }
    /// default card height constant
    private let cardHeight: CGFloat = 60

    override func awakeFromNib() {
        super.awakeFromNib()
        setupFilterCollectionView()
    }

    private func setupFilterCollectionView() {
        filterCollectionView.contentInset = UIEdgeInsets(top: 0, left: cardMargin, bottom: 0, right: 0)
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self

        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        filterCollectionView.collectionViewLayout = collectionLayout
        filterCollectionView.decelerationRate = .fast
        filterCollectionView.backgroundColor = .clear

        filterCollectionView.register(
            UINib(
                nibName: ProductSwitcherAddressFilterCollectionViewCell.reuseId,
                bundle: Bundle.mva10Framework),
            forCellWithReuseIdentifier: ProductSwitcherAddressFilterCollectionViewCell.reuseId)
    }

    // MARK: - Configure
    func configure(addressList: [String], delegate: ProductSwitcherAddressFilterViewDelegate? = nil) {
        self.delegate = delegate
        self.addressList = addressList
        // By default the first address will be selected
        if let address = addressList.first {
            selectedAddress = address
        }
        filterCollectionView.reloadData()
    }

    func selectAddress(address: String) {
        selectedAddress = address
        filterCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProductSwitcherAddressFilterView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addressList.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductSwitcherAddressFilterCollectionViewCell.reuseId,
            for: indexPath) as? ProductSwitcherAddressFilterCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        let address = addressList[indexPath.row]
        let isSelected = (address == selectedAddress)
        cell.configure(with: address, isSelected: isSelected)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectAddress(address: addressList[indexPath.row])
        delegate?.addressFilterDidSelect(address: addressList[indexPath.row])
    }
}

extension ProductSwitcherAddressFilterView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: cardWidth, height: cardHeight)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        cardMargin / 2
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = 2 * cardMargin
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: inset)
    }
}
