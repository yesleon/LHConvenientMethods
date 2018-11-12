//
//  UIBarButtonItem+.swift
//  StoryboardsStoryboardScene
//
//  Created by 許立衡 on 2018/11/9.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    public convenience init(_ view: UIView, target: AnyObject?, action: Selector?) {
        
        self.init(customView: view)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPress)))
        self.target = target
        self.action = action
    }
    
    @objc private func didPress(_ sender: UITapGestureRecognizer) {
        _ = target?.perform(action, with: self)
    }

}
