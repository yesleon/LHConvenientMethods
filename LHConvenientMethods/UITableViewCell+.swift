//
//  UITableViewCell+.swift
//  Storyboards
//
//  Created by 許立衡 on 2018/10/22.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    public func performAction(_ action: Selector, withSender sender: Any?) {
        guard let tableView = superview as? UITableView else { return }
        let indexPath = tableView.indexPath(for: self)!
        tableView.delegate?.tableView?(tableView, performAction: action, forRowAt: indexPath, withSender: sender)
    }
    
}
