//
//  UIView+.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 2018/11/8.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import UIKit


extension UIView {
    
    public func setViewHierarchyNeedsLayout() {
        setNeedsLayout()
        subviews.forEach { $0.setViewHierarchyNeedsLayout() }
    }
    
}
