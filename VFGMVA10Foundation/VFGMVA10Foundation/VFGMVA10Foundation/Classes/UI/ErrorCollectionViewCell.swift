//
//  ErrorCollectionViewCell.swift
//  VFGMVA10Foundation
//
//  Created by Amr Koritem on 04/09/2022.
//

/// Error collection view cell for data loading failure
public class ErrorCollectionViewCell: UICollectionViewCell, NibLoadable {
    @IBOutlet weak var warningImageView: VFGImageView!
    @IBOutlet weak var errorTitleLabel: VFGLabel!
    @IBOutlet weak var errorDescriptionLabel: VFGLabel!
    @IBOutlet weak var tryAgainView: UIView!
    @IBOutlet weak var tryAgainLabel: VFGLabel!
    @IBOutlet weak var tryAgainImageView: VFGImageView!
    @IBOutlet weak var tryAgainButton: VFGButton!

    /// Action handler for the try again function
    public var tryAgainButtonDidPress: (() -> Void)?

    public override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    /// A function to set the localizable strings
    public func setupTitles(errorTitle: String, errorDescription: String, tryAgainTitle: String?) {
        errorTitleLabel.text = errorTitle
        errorDescriptionLabel.text = errorDescription
        guard let tryAgainTitle = tryAgainTitle else {
            tryAgainView.isHidden = true
            return
        }
        tryAgainView.isHidden = false
        tryAgainLabel.text = tryAgainTitle
    }
    /// A function to setup UI
    func setupUI() {
        warningImageView?.image = VFGFoundationAsset.Image.icWarningHiLightTheme
        tryAgainImageView?.image = VFGFoundationAsset.Image.icRefreshRed
    }
    /// A function to try again
    /// - Parameters:
    ///   - sender: should be try again UIButton.
    @IBAction func tryAgainButtonDidPress(_ sender: Any) {
        tryAgainButtonDidPress?()
    }
}
