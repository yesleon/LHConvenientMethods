//
//  UIPopoverController+.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 2018/10/30.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import Foundation

public enum LHPopoverSource {
    case barButtonItem(UIBarButtonItem), view(UIView, withRect: CGRect)
}

extension UIPopoverPresentationController {
    
    public func setPopoverSource(_ source: LHPopoverSource) {
        switch source {
        case .barButtonItem(let item):
            barButtonItem = item
        case let .view(sourceView, withRect: sourceRect):
            self.sourceView = sourceView
            self.sourceRect = sourceRect
        }
    }
    
}
