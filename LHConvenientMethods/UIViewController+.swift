//
//  UIViewController+.swift
//  Storyboards
//
//  Created by 許立衡 on 1/2/2019.
//  Copyright © 2019 narrativesaw. All rights reserved.
//

import UIKit


extension UIViewController {
    
    public func addChild(_ childController: UIViewController, to view: UIView) {
        addChild(childController)
        view.addSubview(childController.view)
        childController.view.frame = view.bounds
        childController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        childController.view.translatesAutoresizingMaskIntoConstraints = true
        childController.didMove(toParent: self)
    }
    
    public func removeFromParentAndSuperview() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
}
