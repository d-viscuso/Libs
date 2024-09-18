//
//  StoryVideoCacheManager.swift
//  VFGStory
//
//  Created by Abdullah Soylemez on 1.02.2021.
//

import Foundation
/// Story video cache manager
class StoryVideoCacheManager {
    /// Video error types
	enum VideoError: Error, CustomStringConvertible {
		case downloadError
		case fileRetrieveError
        /// Video error description
		var description: String {
			switch self {
			case .downloadError:
				return "Can't download video"
			case .fileRetrieveError:
				return "File not found"
			}
		}
	}
    /// Static instance of *StoryVideoCacheManager*
	static let shared = StoryVideoCacheManager()
	private init() {}
	typealias Response = Result<URL, Error>

	private let fileManager = FileManager.default
	private lazy var mainDirectoryUrl: URL? = {
		let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
		return documentsUrl
	}()
    /// Get video data file in case of loading video succeeded
    /// - Parameters:
    ///    - url: File directory URL
    ///    - completionHandler: Handle getting video data response (success or failure)
	func getFile(for url: URL, completionHandler: @escaping (Response) -> Void) {
		guard let file = directoryFor(url: url) else {
			completionHandler(Result.failure(VideoError.fileRetrieveError))
			return
		}

		// return file path if already exists in cache directory
		guard !fileManager.fileExists(atPath: file.path) else {
			DispatchQueue.main.async {
				completionHandler(Result.success(file))
			}
			return
		}

		DispatchQueue.global().async {
			if let videoData = self.getVideoData(for: url) {
				videoData.write(to: file, atomically: true)

				DispatchQueue.main.async {
					completionHandler(Result.success(file))
				}
			} else {
				DispatchQueue.main.async {
					completionHandler(Result.failure(VideoError.downloadError))
				}
			}
		}
	}
    /// Remove file from directory
    /// - Parameters:
    ///    - url: File URL to delete
	func clearCache(for url: URL? = nil) {
		guard let cacheURL = mainDirectoryUrl else { return }
		do {
			// Get the directory contents urls (including subfolders urls)
			let directoryContents = try FileManager.default.contentsOfDirectory(
				at: cacheURL,
				includingPropertiesForKeys: nil,
				options: []
			)
			if let url = url {
				do {
					try fileManager.removeItem(at: url)
				} catch let error as NSError {
					debugPrint("Unable to remove the item: \(error)")
				}
			} else {
				for file in directoryContents {
					do {
						try fileManager.removeItem(at: file)
					} catch let error as NSError {
						debugPrint("Unable to remove the item: \(error)")
					}
				}
			}
		} catch let error as NSError {
			debugPrint(error.localizedDescription)
		}
	}

	private func directoryFor(url: URL) -> URL? {
		guard let mainDirURL = mainDirectoryUrl else { return nil }
		let fileURL = url.lastPathComponent
		let file = mainDirURL.appendingPathComponent(fileURL)
		return file
	}
    /// Get video data
    /// - Parameters:
    ///    - url: Data file directory URL
	func getVideoData(for url: URL) -> NSData? {
		if self.isLocalPath(url: url) {
			return NSData(contentsOfFile: url.absoluteString)
		} else {
			return NSData(contentsOf: url)
		}
	}
    /// Check if given path is local or not
    /// - Parameters:
    ///    - url: File directory URL
	func isLocalPath(url: URL) -> Bool {
		return url.absoluteString.prefix(1) == "/"
	}
}
