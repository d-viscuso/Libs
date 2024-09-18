//
//  VFGImageView+GIF.swift
//  VFGMVA10Foundation
//
//  Created by Abdullah Soylemez on 1.04.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public extension VFGImageView {
    /// Set GIF from a URL.
    ///
    /// - Parameters:
    ///   - url: URL of GIF.
    ///   - completionHandler: optional completion handler to run when download finishes (default is nil).
    func loadGIF(
        from url: URL,
        completionHandler: ((UIImage?) -> Void)? = nil
    ) {
        DispatchQueue.global().async { [weak self] in
            let image = VFGImageView.gif(url: url)
            DispatchQueue.main.async { [weak self] in
                if let completionHandler = completionHandler {
                    completionHandler(image)
                } else {
                    self?.image = image
                }
            }
        }
    }
}

/// Private class functions for GIF support
extension VFGImageView {
    class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            VFGDebugLog("Source for the image does not exist")
            return nil
        }

        return animatedImageWithSource(source)
    }

    class func gif(url: URL) -> UIImage? {
        // Validate data
        guard let imageData = try? Data(contentsOf: url) else {
            VFGDebugLog("Cannot turn image named \"\(url)\" into NSData")
            return nil
        }

        return gif(data: imageData)
    }

    class func delayForImageAtIndex(_ index: Int, source: CGImageSource) -> Double {
        var delay = 0.1

        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }

        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)

        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(
                gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()
            ),
            to: AnyObject.self
        )
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(
                CFDictionaryGetValue(
                    gifProperties,
                    Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()
                ),
                to: AnyObject.self
            )
        }

        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1 // Make sure they're not too fast
        }

        return delay
    }

    class func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        // Check if one of them is nil
        if rhs == nil || lhs == nil {
            if let rhs = rhs {
                return rhs
            } else if let lhs = lhs {
                return lhs
            } else {
                return 0
            }
        }

        guard var lhs = lhs, var rhs = rhs else {
            return 0
        }

        // Swap for modulo
        if lhs < rhs {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }

        // Get greatest common divisor
        var rest: Int
        while true {
            rest = lhs % rhs

            if rest == 0 {
                return rhs // Found it
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }

    class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            gcd = gcdForPair(val, gcd)
        }

        return gcd
    }

    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images: [CGImage] = []
        var delays: [Int] = []

        // Fill arrays
        for index in 0 ..< count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }

            // At it's delay in cs
            let delaySeconds = delayForImageAtIndex(
                Int(index),
                source: source
            )
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }

        // Calculate full duration
        let duration: Int = {
            var sum = 0

            for val: Int in delays {
                sum += val
            }

            return sum
        }()

        // Get frames
        let gcd = gcdForArray(delays)
        var frames: [UIImage] = []

        var frame: UIImage
        var frameCount: Int
        for index in 0 ..< count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)

            for _ in 0 ..< frameCount {
                frames.append(frame)
            }
        }

        let animation = UIImage.animatedImage(
            with: frames,
            duration: Double(duration) / 1000.0
        )

        return animation
    }
}
