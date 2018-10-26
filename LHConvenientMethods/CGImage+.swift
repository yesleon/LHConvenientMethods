//
//  CGImage+.swift
//  Storyboards
//
//  Created by 許立衡 on 2018/10/21.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import Foundation
import ImageIO
import MobileCoreServices

extension CGImage {
    
    public static func makeThumbnail(imageData: Data, maxPixelSize: Int) -> CGImage? {
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize as CFNumber] as CFDictionary
        let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil)!
        return CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options)
    }
    
    public func jpegData() -> Data? {
        let data = NSMutableData() as CFMutableData
        guard let imageDestination = CGImageDestinationCreateWithData(data, kUTTypeJPEG, 1, nil) else { return nil }
        CGImageDestinationAddImage(imageDestination, self, nil)
        guard CGImageDestinationFinalize(imageDestination) else { return nil }
        return data as Data
    }
    
}
