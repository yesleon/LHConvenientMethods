//
//  UIApplication+.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 2018/11/6.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import UIKit

extension UIApplication {
    
    public var firstResponder: UIResponder? {
        var firstResponder: UIResponder?
        let reportAsFirstHandler: UIResponder.ReportAsFirstHandler = { responder in
            firstResponder = responder
        }
        sendAction(#selector(UIResponder.reportAsFirst), to: nil, from: reportAsFirstHandler, for: nil)
        return firstResponder
    }
    
    public func presentAlertController(_ alertController: UIAlertController) {
        let vc = UIViewController()
        let window = UIWindow()
        window.backgroundColor = nil
        window.tintColor = keyWindow?.tintColor
        window.windowLevel = .alert
        window.isHidden = false
        window.rootViewController = vc
        vc.present(alertController, animated: true)
    }
    
}

extension UIResponder {
    
    fileprivate typealias ReportAsFirstHandler = (UIResponder) -> Void
    
    @objc fileprivate func reportAsFirst(_ sender: Any) {
        if let handler = sender as? ReportAsFirstHandler {
            handler(self)
        }
    }
    
}
