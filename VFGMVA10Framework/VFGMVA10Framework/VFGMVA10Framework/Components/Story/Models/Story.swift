//
//  Story.swift
//  VFGStory
//
//  Created by Mithat Samet Kaskara on 12.01.2021.
//

import Foundation
import VFGMVA10Foundation

/// Story type
public enum StoryType: String, Codable, CaseIterable {
    case countdown = "Countdown"
    case pinned = "Pinned"
    case pinnedLocked = "PinnedLocked"
    case pinnedUnlocked = "PinnedUnlocked"
    case featured = "Featured"
    case regular = "Regular"
    case locked = "Locked"
    case unlocked = "Unlocked"
    case sponsored = "Sponsored"
    case unknown
}


/// Story preview  type
public enum StoryPreviewType: String {
    case single = "Single"
    case multiple = "Multiple"
}

extension StoryType {
    var sortIndex: Int {
        switch self {
        case .countdown:
            return 0
        case .pinned:
            return 1
        case .pinnedLocked:
            return 2
        case .pinnedUnlocked:
            return 3
        case .featured:
            return 4
        case .locked:
            return 5
        case .unlocked:
            return 6
        case .regular, .sponsored:
            return 7
        case .unknown:
            return Int.max
        }
    }
}

/// Story media type
public enum StoryMediaType: String {
    case image = "Image"
    case gif = "Gif"
    case video = "Video"
}

/// Story model
public class Story: Codable {
    // MARK: - Service variables
    /// Story id
    public var storyId: String
    /// Story title
    public var title: String
    /// Story description
    public var storyDescription: String
    /// Story icon name
    public var icon: String
    /// Story image name
    private var image: String?
    /// Story GIF name
    private var gif: String?
    /// Story button title
    public var btnTitle: String?
    /// Story button link
    public var btnLink: String?
    /// Story display duration
    public var duration: Double?
    /// Story priority
    public var priority: String
    /// Story button color name
    public var btnColor: String?
    /// Story button title color name
    public var btnTextColor: String?
    /// Story video URL
    private var videoUrl: String?
    /// Story button title
    public var secondBtnTitle: String?
    /// Story button link
    public var secondBtnLink: String?
    /// Story second button title color name
    public var secondBtnTextColor: String?
    /// Story button color name
    public var secondBtnColor: String?

    // MARK: - Custom variables
    /// Determine whether story is viewed or not
    var isViewed: Bool {
        get {
            /// Multiple stories are set to be viewed once every story within is viewed
            if storyPreviewType == .multiple {
                let views = stories.map { $0.isViewed }
                return !views.contains(false)
            }

            return UserDefaults.standard.storySeenList[storyId] != nil
        }
        set {
            if newValue, UserDefaults.standard.storySeenList[storyId] == nil {
                VFGInfoLog("\(title) story marked as viewed")
                UserDefaults.standard.storySeenList[storyId] = Date()
            }
        }
    }
    /// Story end date
    var endDate: Date?
    /// Determine whether story is completely visible on screen or not
    var isCompletelyVisible = false
    /// Story type
    public var type: StoryType
    /// Story single/multiple
    var storyPreviewType: StoryPreviewType = .single
    /// Story media type
    var mediaType: StoryMediaType
    /// Story media URL
    var mediaURL: URL?
    /// Stories for multiple story types
    var stories: [Story] = []
    /// Story grid view for products or editorial types cards
    var gridData: GridData?
    /// Keep story view timestamp
    var viewedTime: Date? {
        if storyPreviewType == .multiple, let lastStory = stories.last {
            return lastStory.viewedTime
        }
        return UserDefaults.standard.storySeenList[storyId]
    }
    /// Last viewed multiple story index
    var lastViewedMultipleStoryIndex: Int = 0

    public enum CodingKeys: String, CodingKey {
        case storyId = "id"
        case title, icon, image
        case storyDescription = "description"
        case gif, btnTitle, btnLink
        case type
        case duration
        case priority, btnColor
        case btnTextColor, videoUrl
        case gridData
        case secondBtnTitle, secondBtnLink, secondBtnTextColor, secondBtnColor
    }
    /// *Story* initializer
    /// - Parameters:
    ///    - storyId: Story id
    ///    - storyType: storyType: featured, pinned or countdown
    ///    - title: Story title
    ///    - icon: Story icon name
    ///    - image: Story image name
    ///    - gif: Story GIF name
    ///    - btnTitle: Story button title
    ///    - btnLink: Story button link
    ///    - duration: Story display duration
    ///    - priority: Story priority
    ///    - btnColor: Story button color name
    ///    - btnTextColor: Story button title color name
    ///    - videoUrl: Story video URL
    ///    - gridData: Story grid layout data
    public init(
        storyId: String,
        storyType: StoryType,
        title: String,
        storyDescription: String,
        icon: String,
        image: String? = nil,
        gif: String? = nil,
        btnTitle: String? = nil,
        btnLink: String? = nil,
        duration: Double? = nil,
        priority: String,
        btnColor: String? = nil,
        btnTextColor: String? = nil,
        videoUrl: String? = nil,
        gridData: GridData? = nil,
        secondBtnTitle: String? = nil,
        secondBtnLink: String? = nil,
        secondBtnTextColor: String? = nil,
        secondBtnColor: String? = nil
    ) {
        self.storyId = storyId
        self.title = title
        self.storyDescription = storyDescription
        self.icon = icon
        self.image = image
        self.gif = gif
        self.btnTitle = btnTitle
        self.btnLink = btnLink
        self.type = storyType
        self.duration = duration
        self.priority = priority
        self.btnColor = btnColor
        self.btnTextColor = btnTextColor
        self.videoUrl = videoUrl
        self.gridData = gridData
        self.secondBtnTitle = secondBtnTitle
        self.secondBtnLink = secondBtnLink
        self.secondBtnTextColor = secondBtnTextColor
        self.secondBtnColor = secondBtnColor

        // Custom variables
        if storyType == .countdown, let duration = duration, duration > 0 {
            endDate = Date(timeIntervalSinceNow: duration)
        }

        if let videoUrl = videoUrl, !videoUrl.isEmpty {
            mediaType = .video
            mediaURL = URL(string: videoUrl)
        } else if let gif = gif, !gif.isEmpty {
            mediaType = .gif
            mediaURL = URL(string: gif)
        } else {
            mediaType = .image
            mediaURL = URL(string: image ?? "")
        }
    }

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        storyId = try values.decode(String.self, forKey: .storyId)
        title = try values.decode(String.self, forKey: .title)
        storyDescription = try values.decode(String.self, forKey: .storyDescription)
        icon = try values.decode(String.self, forKey: .icon)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        gif = try values.decodeIfPresent(String.self, forKey: .gif)
        btnTitle = try values.decodeIfPresent(String.self, forKey: .btnTitle)
        btnLink = try values.decodeIfPresent(String.self, forKey: .btnLink)
        duration = try values.decodeIfPresent(Double.self, forKey: .duration)
        priority = try values.decode(String.self, forKey: .priority)
        btnColor = try values.decodeIfPresent(String.self, forKey: .btnColor)
        btnTextColor = try values.decodeIfPresent(String.self, forKey: .btnTextColor)
        videoUrl = try values.decodeIfPresent(String.self, forKey: .videoUrl)
        gridData = try values.decodeIfPresent(GridData.self, forKey: .gridData)
        type = try values.decodeIfPresent(StoryType.self, forKey: .type) ?? .unknown
        secondBtnTitle = try values.decodeIfPresent(String.self, forKey: .secondBtnTitle)
        secondBtnLink = try values.decodeIfPresent(String.self, forKey: .secondBtnLink)
        secondBtnTextColor = try values.decodeIfPresent(String.self, forKey: .secondBtnTextColor)
        secondBtnColor = try values.decodeIfPresent(String.self, forKey: .secondBtnColor)

        // Custom variables
        if type == .countdown, let duration = duration, duration > 0 {
            endDate = Date(timeIntervalSinceNow: duration)
        }

        if let videoUrl = videoUrl, !videoUrl.isEmpty {
            mediaType = .video
            mediaURL = URL(string: videoUrl)
        } else if let gif = gif, !gif.isEmpty {
            mediaType = .gif
            mediaURL = URL(string: gif)
        } else {
            mediaType = .image
            mediaURL = URL(string: image ?? "")
        }
    }
}

extension Story: Equatable {
    public static func == (lhs: Story, rhs: Story) -> Bool {
        return lhs.storyId == rhs.storyId
    }
}

/// Sorting alghorythm implementation:
/// 1: check if type is countdown or pinned: in such cases we don't check the viewed state and
/// use only priority or type index
/// 2: for all other stories, if the view state is not the same show first the unviewed story
///     a: if the stories are both not viewed sort by priority
///     b: if the stories are both viewed and the view timestamp is available, sort by view time
///     c: fallback sorting by priority
///     d: fallback sorting by storyId
extension Story: Comparable {
    public static func < (lhs: Story, rhs: Story) -> Bool {
        if lhs.type == .countdown || lhs.type == .pinned
            || lhs.type == .pinnedLocked || lhs.type == .pinnedUnlocked
            || rhs.type == .countdown || rhs.type == .pinned
            || rhs.type == .pinnedLocked || rhs.type == .pinnedUnlocked {
            if lhs.type == rhs.type {
                return lhs.priority < rhs.priority
            }
            return lhs.type.sortIndex < rhs.type.sortIndex
        }
        guard lhs.isViewed == rhs.isViewed else {
            return lhs.isViewed == false
        }
        if lhs.isViewed == false {
            return lhs.type.sortIndex < rhs.type.sortIndex
        } else if let leftDate = lhs.viewedTime, let rightDate = rhs.viewedTime {
            return leftDate.timeIntervalSince1970 < rightDate.timeIntervalSince1970
        } else if lhs.priority != rhs.priority {
            return lhs.priority < rhs.priority
        }
        return lhs.storyId < rhs.storyId
    }
}
