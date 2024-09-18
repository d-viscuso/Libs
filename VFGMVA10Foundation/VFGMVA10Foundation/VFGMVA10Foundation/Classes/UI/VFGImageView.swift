//
//  VFGImageView.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 2/24/21.
//

import UIKit
/// Designable and inspectable UIImageView that can get an image by its name from assets
/// or download it from given URL and store it
/// and set its direction
@IBDesignable
public class VFGImageView: UIImageView {
    @IBInspectable var imageName: String = "" {
        didSet {
            image = VFGImage(named: imageName)
        }
    }
    var imageDownloader: VFGImageDownloader?
    /// Determine whether image direction can be changed or not
    public var enableDynamicDirection = true {
        didSet {
            updateDirection(isDynamic: enableDynamicDirection)
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        updateDirection(isDynamic: enableDynamicDirection)
    }
    /// Update image presentation direction (right to left) or (left to right)
    /// - Parameters:
    ///    - isDynamic: Determine if image direction can be changed or not
    func updateDirection(isDynamic: Bool = true) {
        if isDynamic && UIApplication.isRightToLeft {
            transform = CGAffineTransform(scaleX: -1, y: 1)
        } else {
            transform = .identity
        }
    }

	/// Set image from a URL.
	///
	/// - Parameters:
	///   - url: URL of image.
	///   - placeHolder: optional placeholder image
	///   - completionHandler: optional completion handler to run when download finishes (default is nil).
	public func download(
        from url: URL,
        cacheAttributes: [String] = [],
        placeholder: UIImage? = nil,
        completion: ((UIImage?) -> Void)? = nil
    ) {
        image = placeholder
        imageDownloader = VFGImageDownloader()
        imageDownloader?.download(from: url, cacheAttributes: cacheAttributes) { image in
            DispatchQueue.main.async { [weak self] in
                self?.image = image == nil ? placeholder : image
                completion?(image)
            }
        }
    }

    /// Set image from a URL or image name.
    ///
    /// - Parameters:
    ///   - imageIdentifier: URL or name of image.
    ///   - placeHolder: optional placeholder image
    ///   - completionHandler: optional completion handler to run when download finishes (default is nil).
    public func download(
        by imageIdentifier: String,
        cacheAttributes: [String] = [],
        placeholder: UIImage? = nil,
        completion: ((UIImage?) -> Void)? = nil
    ) {
        if let image = VFGImage(named: imageIdentifier) {
            self.image = image
            completion?(image)
        } else if let url = URL(string: imageIdentifier) {
            download(from: url, cacheAttributes: cacheAttributes, placeholder: placeholder, completion: completion)
        } else {
            self.image = placeholder
            completion?(nil)
        }
    }
}
