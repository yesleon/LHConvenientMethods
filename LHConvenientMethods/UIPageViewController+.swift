//
//  UIPageViewController+.swift
//  Storyboards
//
//  Created by 許立衡 on 2018/10/23.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import UIKit

extension UIPageViewController {
    
    public func updateItemsFromChildViewController(animated: Bool) {
        if let childVC = viewControllers?.first {
            setToolbarItems(childVC.toolbarItems, animated: animated)
            navigationItem.setLeftBarButtonItems(childVC.navigationItem.leftBarButtonItems, animated: animated)
            navigationItem.setRightBarButtonItems(childVC.navigationItem.rightBarButtonItems, animated: animated)
        }
    }
    
    public func reloadData() {
        let dataSource = self.dataSource
        self.dataSource = nil
        self.dataSource = dataSource
    }
    
}
