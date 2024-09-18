//
//  IntrinsicTableView.swift
//  VFGReferAFriend
//
//  Created by Abdullah Soylemez on 24.03.2021.
//

import UIKit

public class IntrinsicTableView: UITableView {
	public override var contentSize: CGSize {
		didSet {
			self.invalidateIntrinsicContentSize()
		}
	}

	public override var intrinsicContentSize: CGSize {
		self.layoutIfNeeded()
		return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
	}
}
