//
//  VFGTabBarOverlay.swift
//  VFGMVA10Foundation
//
//  Created by Ayman Ata on 16/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import Foundation

/// *VFGTabBarOverlay* is an overlay view that can be used with *VFGTabBar* or it can be used independently.
/// You can intialize it with a UIView or UIViewController.
public class VFGTabBarOverlay: UIViewController {
    private var maxHeightRatio: CGFloat = 0.9
    private var viewToPresent: UIView?
    private var childVC: UIViewController?
    private let baseAlpha: CGFloat = 0.6

    let overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.roundUpperCorners(cornerRadius: 6)
        view.backgroundColor = .white
        return view
    }()

    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var closeButton: VFGButton = {
        let button = VFGButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(VFGFoundationAsset.Image.icXClose, for: .normal)
        button.addTarget(self, action: #selector(animateDismiss), for: .touchUpInside)
        return button
    }()

    let titleLabel: VFGLabel = {
        let label = VFGLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .vodafoneBold(16)
        label.textColor = .primaryTextColor
        return label
    }()

    lazy private var heightConstraint = overlayView.heightAnchor.constraint(
        equalTo: view.heightAnchor,
        multiplier: maxHeightRatio
    )

    /// Creates new instance of VFGTabBarOverlay containing tthe given view.
    /// - Parameters:
    ///   - view: A view that will be embeded in the overlay view.
    ///   - overlayTitle: Title of the overlay.
    ///   - maxHeightRatio: Maximum height ratio of the overlay, it is 0.9 by default.
    /// - Note: If you provide ratio more than 0.9, it will be neglicted and the overlay height will be 0.9 of the screen height.
    public required init(view: UIView, overlayTitle: String, maxHeightRatio: CGFloat = 0.9) {
        super.init(nibName: nil, bundle: nil)
        viewToPresent = view
        self.maxHeightRatio = min(maxHeightRatio, self.maxHeightRatio)
        self.titleLabel.text = overlayTitle
    }

    /// Creates new instance of VFGTabBarOverlay containing tthe given view controller.
    /// - Parameters:
    ///   - childVC: A view controller that will be embeded in the overlay view.
    ///   - overlayTitle: Title of the overlay.
    ///   - maxHeightRatio: Maximum height ratio of the overlay, it is 0.9 by default.
    /// - Note: If you provide ratio more than 0.9, it will be neglicted and the overlay height will be 0.9 of the screen height.
    public required init(childVC: UIViewController, overlayTitle: String, maxHeightRatio: CGFloat = 0.9) {
        super.init(nibName: nil, bundle: nil)
        self.childVC = childVC
        self.maxHeightRatio = min(maxHeightRatio, self.maxHeightRatio)
        self.titleLabel.text = overlayTitle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addPanGesture()
        embedeView()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // This is needed to return view transision to it's original position.
        UIView.animate(withDuration: 0.1) { [unowned self] in
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.overlayView.transform = transform
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: baseAlpha)
        }
    }

    private func embedeView() {
        guard let childVC else {
            guard let viewToPresent else { return }
            contentView.embed(view: viewToPresent)
            viewToPresent.layoutIfNeeded()
            return
        }
        childVC.willMove(toParent: self)
        contentView.addSubview(childVC.view)
        addChild(childVC)
        childVC.view.frame = contentView.bounds
        childVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childVC.didMove(toParent: self)
        childVC.view.layoutIfNeeded()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: baseAlpha)
        closeButton.addTarget(self, action: #selector(animateDismiss), for: .touchUpInside)
        setupConstraints()
    }

    private func setupConstraints() {
        view.addSubview(overlayView)
        [contentView, closeButton, titleLabel].forEach { overlayView.addSubview($0) }

        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            heightConstraint,

            contentView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 55),
            contentView.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 26),
            titleLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),

            closeButton.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -21),
            closeButton.heightAnchor.constraint(equalToConstant: 22),
            closeButton.widthAnchor.constraint(equalToConstant: 22),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }

    private func addPanGesture() {
        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(viewDidDrag(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }

    @objc func viewDidDrag(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let yPosition = translation.y
        let state = gesture.state
        var alpha = baseAlpha * (1 - (yPosition / overlayView.frame.height))
        alpha = min(max(0, alpha), baseAlpha)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)

        if yPosition > 0 {
            let transform = CGAffineTransform(translationX: 0, y: yPosition)
            overlayView.transform = transform
        }

        guard state == .ended else { return }
        if yPosition >= overlayView.frame.height / 2 {
            animateDismiss()
        } else {
            UIView.animate(withDuration: 0.1) { [unowned self] in
                let transform = CGAffineTransform(translationX: 0, y: 0)
                self.overlayView.transform = transform
                alpha = baseAlpha
                self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
            }
        }
    }

    @objc func animateDismiss() {
        UIView.animate(
            withDuration: 0.2,
            animations: { [unowned self] in
                self.view.backgroundColor = .clear
                let transform = CGAffineTransform(translationX: 0, y: self.overlayView.frame.height)
                self.overlayView.transform = transform
            }, completion: { [weak self] _ in
                self?.dismiss(animated: false)
            })
    }
}
