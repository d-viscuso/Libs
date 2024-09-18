//
//  VFGYourAppointmentsViewController+CollectionView.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 03/02/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGYourAppointmentsViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel.contentState {
        case .loading:
            return 2
        case .populated:
            return viewModel.numberOfUpcomingAppointments()
        case .empty:
            return (viewModel.numberOfHistoryAppointments() > 0 && viewModel.customView != nil) ? 0 : 1
        case .error:
            return 1
        case .filtered:
            return 0
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.contentState {
        case .loading:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "shimmerCell",
                for: indexPath)
            guard let cellItem = cell as? VFGYourAppointmentsShimmerViewCell else {
                return cell
            }
            cellItem.startShimmer()
            return cellItem
        case .populated:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "appointmentCell",
                for: indexPath)
            guard let cellItem = cell as? VFGAppointmentsCollectionViewCell else {
                return cell
            }
            setupActionsForCell(cell: cellItem, row: indexPath.row)
            cellItem.setupCell(appointment: viewModel.appointment(at: indexPath.row))
            cell.isAccessibilityElement = false
            cell.accessibilityIdentifier = "APappointmentCell_\(indexPath.row)"
            return cellItem
        case .error:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ErrorCollectionViewCell.reuseIdentifier,
                for: indexPath)
            guard let cellItem = cell as? ErrorCollectionViewCell else { return cell }
            let errorModel = viewModel.errorModel
            cellItem.setupTitles(
                errorTitle: errorModel?.title ?? "",
                errorDescription: errorModel?.description ?? "",
                tryAgainTitle: nil)
            cell.isAccessibilityElement = false
            cell.accessibilityIdentifier = "APnoAppointmentsCell"
            return cellItem
        case .empty:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "noAppointments",
                for: indexPath)
            guard let cellItem = cell as? VFGNoAppointmentCollectionViewCell else {
                return cell
            }
            cellItem.setupCell(
                title: "your_appointments_no_appointment_title"
                    .localized(bundle: Bundle.mva10Framework),
                subtitle: "your_appointments_no_appointment_subtitle"
                    .localized(bundle: Bundle.mva10Framework),
                desc: "your_appointments_no_appointment_description"
                    .localized(bundle: Bundle.mva10Framework))
            cell.isAccessibilityElement = false
            cell.accessibilityIdentifier = "APnoAppointmentCell"
            return cellItem
        case .filtered:
            return UICollectionViewCell()
        }
    }
}

// MARK: Cell Actions
extension VFGYourAppointmentsViewController {
    func setupActionsForCell(cell: VFGAppointmentsCollectionViewCell, row: Int) {
        cell.storeLocationButtonPressed = { [weak self] in
            self?.getDirectionToStore(row: row)
        }

        cell.cancelButtonPressed = { [weak self] in
            self?.deleteAppointment(at: row)
        }

        cell.changeBookButtonPressed = { [weak self] in
            self?.changeAppointment(at: row)
        }
    }

    func getDirectionToStore(row: Int) {
        guard self.delegate?.appointmentStoreLocationActionHandler(at: row) == nil else {
            self.delegate?.appointmentStoreLocationActionHandler(at: row)?()
            return
        }
        let storeLatitude = viewModel.appointment(at: row).store?.coordinate.latitude
        let storeLongitude = viewModel.appointment(at: row).store?.coordinate.longitude
        let directionsURL = "http://maps.apple.com/?saddr=My+Location&daddr=\(storeLatitude ?? 0),\(storeLongitude ?? 0)&dirflg=d"
        guard let url = URL(string: directionsURL) else { return }
        UIApplication.shared.open(url)
    }

    func deleteAppointment(at index: Int) {
        guard self.delegate?.appointmentCancelActionHandler(at: index) == nil else {
            self.delegate?.appointmentCancelActionHandler(at: index)?()
            return
        }
        if index < VFGYourAppointmentsManager.shared.demoAppointments.count {
            VFGYourAppointmentsManager.shared.demoAppointments.remove(at: index)
        }
        viewModel.fetchAppointments()
        appointmentsCollectionView.reloadData()
    }

    func changeAppointment(at index: Int) {
        guard self.delegate?.appointmentChangeBookActionHandler(at: index) == nil else {
            self.delegate?.appointmentChangeBookActionHandler(at: index)?()
            return
        }
        VFGDebugLog("Edit Appointment")
    }
}

extension VFGYourAppointmentsViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let sizingCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "appointmentCell",
            for: indexPath) as? VFGAppointmentsCollectionViewCell,
            viewModel.numberOfUpcomingAppointments() > indexPath.row else {
                collectionViewHeightConstraint.constant = defaultCellSize.height
                return defaultCellSize
        }
        sizingCell.setupCell(appointment: viewModel.appointment(at: indexPath.row))

        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()

        // size of the cell based on the current items
        let computedSize = sizingCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let finalSize = CGSize(width: cellSize.width, height: computedSize.height)

        collectionViewHeightConstraint.constant = max(collectionViewHeightConstraint.constant, finalSize.height)
        return finalSize
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = cellSize.width
        targetContentOffset.pointee = scrollView.contentOffset
        let factor: CGFloat = velocity.x < 0 ? -0.5 : 0.5
        let offsetPoint: CGFloat = scrollView.contentOffset.x / pageWidth
        var index = Int( round(offsetPoint + factor) )

        if index < 0 {
            index = 0
        } else if index > viewModel.numberOfUpcomingAppointments() - 1 {
            index = viewModel.numberOfUpcomingAppointments() - 1
        }
        let indexPath = IndexPath(row: index, section: 0)
        appointmentsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
