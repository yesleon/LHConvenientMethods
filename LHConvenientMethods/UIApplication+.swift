//
//  UIApplication+.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 2018/11/6.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import UIKit

private typealias FirstResponderReportHandler = (UIResponder) -> Void

extension UIApplication {
    
    public var firstResponder: UIResponder? {
        var firstResponder: UIResponder?
        let reportHandler: FirstResponderReportHandler = { responder in
            firstResponder = responder
        }
        sendAction(#selector(UIResponder.reportAsFirstResponder), to: nil, from: reportHandler, for: nil)
        return firstResponder
    }
    
    public func presentAlertController(_ alertController: UIAlertController) {
        let undoWindow = UIWindow()
        undoWindow.backgroundColor = nil
        undoWindow.tintColor = keyWindow?.tintColor
        let rootVC = UIViewController()
        undoWindow.rootViewController = rootVC
        undoWindow.makeKeyAndVisible()
        rootVC.present(alertController, animated: true)
    }
    
}

extension UIResponder {
    
    @objc fileprivate func reportAsFirstResponder(_ sender: Any) {
        if let handler = sender as? FirstResponderReportHandler {
            handler(self)
        }
    }
    
}
