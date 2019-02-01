//
//  UIImage+.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 2018/11/27.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import UIKit

extension UIImage {
    
    public func drawAspectFit(in targetRect: CGRect) {
        let aspect = size.width / size.height
        let rect: CGRect
        if targetRect.size.width / aspect <= targetRect.size.height {
            let height = targetRect.size.width / aspect
            rect = CGRect(x: 0, y: (targetRect.size.height - height) / 2,
                          width: targetRect.size.width, height: height)
        } else {
            let width = targetRect.size.height * aspect
            rect = CGRect(x: (targetRect.size.width - width) / 2, y: 0,
                          width: width, height: targetRect.size.height)
        }
        draw(in: rect)
    }
    
}
