//
//  UIImageView+.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 2018/10/25.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import UIKit

extension UIImageView {
    
    public func frameForImage() -> CGRect {
        guard let image = image else { return .zero }
        let imageSize = image.size
        let imageScale = min(bounds.width/imageSize.width, bounds.height/imageSize.height)
        let scaledImageSize = CGSize(width: imageSize.width * imageScale, height: imageSize.height * imageScale)
        return CGRect(x: (bounds.width - scaledImageSize.width) / 2, y: (self.bounds.height - scaledImageSize.height) / 2, width: scaledImageSize.width, height: scaledImageSize.height)
    }
    
}
