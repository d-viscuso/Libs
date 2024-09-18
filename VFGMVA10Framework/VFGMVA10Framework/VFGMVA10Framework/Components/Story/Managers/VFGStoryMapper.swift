//
//  VFGStoryMapper.swift
//  VFGMVA10Framework
//
//  Created by Abdullah Soylemez on 12.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Stories maker
public class VFGStoryMapper: VFGStoryMapperProtocol {
    private enum Constants {
        static let icon = "Icon"
        static let deeplink = "DeepLink"
    }

    public init() {}

    public func createStories(
        using dxlResponse: StoriesDXLResponse?,
        cmsResponse: [StoryCMSData]?
    ) -> [Story]? {
        guard let recommendationItem = dxlResponse?.recommendationItem else {
            return nil
        }

        var stories: [Story] = []
        for item in recommendationItem {
            guard let priority = item.priority
            else { continue }
            let productCount = item.products?.count ?? 0
            let previewType: StoryPreviewType = productCount > 1 ? StoryPreviewType.multiple : StoryPreviewType.single
            if previewType == StoryPreviewType.multiple {
                guard let story = getMultipleStory(
                    storyId: item.id,
                    from: item.products,
                    with: priority,
                    type: item.type,
                    cmsResponse: cmsResponse
                )
                else { continue }

                stories.append(story)
            } else {
                guard let story = getSingleStory(
                    storyId: item.id,
                    from: item.products?.first,
                    with: priority,
                    type: item.type,
                    cmsResponse: cmsResponse
                )
                else { continue }

                stories.append(story)
            }
        }
        return stories
    }

    private func getSingleStory(
        storyId: String?,
        from product: StoriesProduct?,
        with priority: Int,
        type: StoryType,
        cmsResponse: [StoryCMSData]?
    ) -> Story? {
        guard
            let storyId = storyId,
            let title = product?.name,
            let iconProduct = product?.productCharacteristic?.first(where: { $0.id == Constants.icon }),
            let icon = iconProduct.valueType
        else {
            return nil
        }
        let description = product?.description
        let image = product?.productCharacteristic?.first {
            $0.id == StoryMediaType.image.rawValue
        }?.valueType

        var btnLink: String?
        var secondBtnLink: String?
        if product?.productSpecification?.id == Constants.deeplink,
            let href = product?.productSpecification?.href {
            btnLink = href
            if let href2 = product?.productSpecification?.href {
                secondBtnLink = href2
            }
        }

        var duration: Double?
        if let startDateTime = product?.productTerm?.first?.validFor?.startDateTime,
            let startDate = VFGDateHelper.getDateFromString(dateString: startDateTime),
            let endDateTime = product?.productTerm?.first?.validFor?.endDateTime,
            let endDate = VFGDateHelper.getDateFromString(dateString: endDateTime),
            endDate >= startDate {
            duration = endDate.timeIntervalSince(startDate)
        }

        let cmsData = cmsResponse?.first { $0.id == product?.id }

        return Story(
            storyId: storyId,
            storyType: type,
            title: title,
            storyDescription: description ?? "",
            icon: icon,
            image: image,
            gif: product?.productCharacteristic?.first { $0.id == StoryMediaType.gif.rawValue }?.valueType,
            btnTitle: cmsData?.btnTitle,
            btnLink: btnLink,
            duration: duration,
            priority: "\(priority)",
            btnColor: cmsData?.btnColor,
            btnTextColor: cmsData?.btnTextColor,
            videoUrl: product?.productCharacteristic?.first {
                $0.id == StoryMediaType.video.rawValue
            }?.valueType,
            gridData: product?.productGrid,
            secondBtnTitle: cmsData?.secondBtnTitle,
            secondBtnLink: secondBtnLink,
            secondBtnTextColor: cmsData?.secondBtnTextColor,
            secondBtnColor: cmsData?.secondBtnColor
        )
    }

    private func getMultipleStory(
        storyId: String?,
        from products: [StoriesProduct]?,
        with priority: Int,
        type: StoryType,
        cmsResponse: [StoryCMSData]?
    ) -> Story? {
        guard
            let storyId = storyId,
            let products = products,
            let firstProduct = products.first
        else { return nil }

        let story = getSingleStory(
            storyId: storyId,
            from: firstProduct,
            with: priority,
            type: type,
            cmsResponse: cmsResponse)
        story?.storyPreviewType = .multiple

        for product in products {
            guard let singleStory = getSingleStory(
                storyId: product.id,
                from: product,
                with: priority,
                type: type,
                cmsResponse: cmsResponse)
            else { continue }
            story?.stories.append(singleStory)
        }

        return story
    }
}
