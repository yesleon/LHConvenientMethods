//
//  UIWindow+.swift
//  Storyboards
//
//  Created by 許立衡 on 2018/10/25.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import UIKit

extension UIWindow {
    
    public var topViewController: UIViewController? {
        if var topVC = rootViewController {
            while let vc = topVC.presentedViewController {
                topVC = vc
            }
            return topVC
        } else {
            return nil
        }
    }
    
}
