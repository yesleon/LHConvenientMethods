//
//  UIScrollView+.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 2018/11/4.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import Foundation

extension UIScrollView {
    
    public func setHandlesKeyboard(_ handlesKeyboard: Bool) {
        if handlesKeyboard {
            NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidChangeFrameNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameDidChange), name: UIWindow.keyboardDidChangeFrameNotification, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidChangeFrameNotification, object: nil)
        }
    }
    
    @objc private func keyboardFrameDidChange(notification: Notification) {
        let kbFrame = notification.userInfo![UIWindow.keyboardFrameEndUserInfoKey] as! CGRect
        let viewFrame: CGRect
        if let window = window {
            viewFrame = convert(bounds, to: window)
        } else {
            viewFrame = frame
        }
        let overlap = kbFrame.intersection(viewFrame)
        let contentInsets = overlap.isEmpty ? .zero : UIEdgeInsets(top: 0, left: 0, bottom: overlap.height - safeAreaInsets.bottom, right: 0)
        
        UIView.animateObject(object: self, withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
            $0.contentInset = contentInsets
            $0.scrollIndicatorInsets = contentInsets
        })
        
        
    }
    
}
