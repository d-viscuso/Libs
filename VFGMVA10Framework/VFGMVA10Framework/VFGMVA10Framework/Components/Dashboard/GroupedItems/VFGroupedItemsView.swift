//
//  VFGroupedItemsView.swift
//  VFGMVA10Group
//
//  Created by Mohamed Mahmoud Zaki on 10/15/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// Dashboard grouped items section view
public class VFGroupedItemsView: UIView {
    let nibName = "VFGroupedItemsView"
    /// Determine if dashboard grouped items section is expanded or not
    public var isExpanded = false
    /// Determine if dashboard grouped items section has show more button or not
    public var hasShowMore = false
    /// Dashboard grouped items section show more button action
    public var showMoreAction: (() -> Void)?
    /// Dashboard grouped items section item
    public var item: VFGDashboardItem? {
        didSet {
            setupView()
        }
    }
    /// dashboard theme
    public var isMva12Theme = false
    /// Instance of *VFGErrorView*.
    var errorView: VFGErrorView?
    /// Instance of *VFGroupedItemsShimmerView*.
    var shimmerView: VFGroupedItemsShimmerView?
    /// A completion handler that returns the dashboard categories view height.
    var cardViewHeightCompletion: ((CGFloat) -> Void)?
    /// ErrorView height .
    let errorViewHeight: CGFloat = 232
    /// ShimmerView height .
    let shimmerViewHeight: CGFloat = 232

    /// the state of  **VFGCategoriesView**
    public var state: VFGContentState = .loading {
        didSet {
            if state != .error {
                removeErrorCard()
            }
            setupView()
        }
    }

    /// Dashboard actions list
    public let actions = VFGManagerFramework.dashboardDelegate?.dashboardActions()
    var contentView: UIView?
    @IBOutlet weak var showMoreButton: VFGButton!
    @IBOutlet weak var showMoreView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBAction func showMoreButton(_ sender: Any) {
        configureMoreButtonView(showMoreTitle: isExpanded)
        isExpanded.toggle()
        showMoreAction?()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    public func showErrorCard(
        with errorConfig: VFGErrorModel,
        tryAgain completion: (() -> Void)?
    ) {
        state = .error
        removeShimmerView()
        errorView = VFGErrorView(error: errorConfig)
        errorView?.errorImageView.image = VFGFrameworkAsset.Image.warning
        errorView?.configureErrorViewConstraints()
        embed(view: errorView ?? UIView())
        errorView?.refreshingClosure = {
            self.state = .loading
            completion?()
        }
        DispatchQueue.main.async { [weak self] in
            self?.cardViewHeightCompletion?(self?.errorViewHeight ?? 0.0)
        }
    }

    public func removeErrorCard() {
        errorView?.removeFromSuperview()
        errorView = nil
    }

    public func removeShimmerView() {
        shimmerView?.removeFromSuperview()
        shimmerView = nil
    }

    private func setupView() {
        guard let item = item, state != .error else {
            return
        }
        stackView.removeSubviews()
        if state == .loading {
            removeErrorCard()
            shimmerView = VFGroupedItemsShimmerView()
            shimmerView?.startShimmer()
            embed(view: shimmerView ?? UIView())
            DispatchQueue.main.async { [weak self] in
                self?.cardViewHeightCompletion?(self?.shimmerViewHeight ?? 0.0)
            }
            return
        }
        let subItems = item.value(for: VFGroupedItemMetaDataKeys.subItems) as? [VFGSubItem]
        var localizedTitle = ""
        if let title = item.value(for: VFGroupedItemMetaDataKeys.accessibilityTitle) as? String {
            localizedTitle = separateStringIfNeeded(title.localized(bundle: Bundle.mva10Framework))
            stackView.accessibilityIdentifier = "DB\(localizedTitle.lowercased())Section"
        }
        if let subItems = subItems {
            subItems.forEach { [weak self] subItem in
                guard let self = self else { return }
                let itemView = VFGroupItemView()
                stackView.addArrangedSubview(itemView)
                itemView.itemModel = subItem
                itemView.accessibilityIdentifier = generateAccessibilityId(
                    localizedTitle,
                    itemView.itemModel?.title)
                if let actionId = subItem.actionId {
                    itemView.itemAction = self.actions?[actionId]
                }
            }
        }
        configureMoreButtonView(showMoreTitle: !isExpanded)
        showMoreButton.accessibilityIdentifier = "DB\(localizedTitle.lowercased())ShowMore"
    }

    /// Dashboard grouped items section show more button configuration
    /// - Parameters:
    ///    - showMoreTitle: Determine if dashboard grouped items section has show more button or not
    func configureMoreButtonView(showMoreTitle: Bool) {
        if !hasShowMore {
            return
        }
        let title = showMoreTitle ? "dashboard_group_component_show_more".localized(bundle: Bundle.mva10Framework) :
            "dashboard_group_component_show_less".localized(bundle: Bundle.mva10Framework)
        showMoreButton.setTitle(title, for: .normal)
        let buttonColor = isMva12Theme ? UIColor.VFGRedOrangeTextMva12 : UIColor.VFGRedOrangeText
        showMoreButton.setTitleColor(buttonColor, for: .normal)
        showMoreButton.titleLabel?.adjustsFontSizeToFitWidth = true
        showMoreView.isHidden = !hasShowMore
    }

    private func separateStringIfNeeded(_ string: String) -> String {
        if string.contains(" "),
            let separatedTitle = string.split(separator: " ").first {
            return String(separatedTitle)
        }

        return string
    }

    private func showMoreVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "Show More"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(showMoreButton(_:)))
    }

    private func setupVoiceoverAccessibility() {
        showMoreView.isAccessibilityElement = false
        showMoreButton.isAccessibilityElement = true
        showMoreButton.accessibilityCustomActions = [showMoreVoiceOverAction()]
    }
}

extension VFGroupedItemsView {
    /// Dashboard grouped items section XIB load
    func xibSetup() {
        guard let view = loadViewFromNib(nibName: nibName) else {
            VFGErrorLog("VFGroupItemView is nil")
            return
        }
        contentView = view
        guard let contentView = contentView else { return }
        xibSetup(contentView: contentView)
        setupVoiceoverAccessibility()
    }
}

extension VFGroupedItemsView {
    private func generateAccessibilityId(_ localizedTitle: String, _ itemTitle: String?) -> String {
        guard var itemTitle = itemTitle else {
            return ""
        }

        itemTitle = itemTitle.localized(bundle: Bundle.mva10Framework)
        itemTitle = itemTitle.replacingOccurrences(
            of: "-",
            with: "")
        itemTitle = String(itemTitle.split(separator: " ").first ?? "")
        if itemTitle == "Developer" {
            itemTitle += "Settings"
        }
        return "DB\(localizedTitle.lowercased() + itemTitle)"
    }
}
