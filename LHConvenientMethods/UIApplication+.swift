//
//  UIApplication+.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 2018/11/6.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

private typealias FirstResponderReportHandler = (UIResponder) -> Void

extension UIApplication {
    
    public var firstResponder: UIResponder? {
        var firstResponder: UIResponder?
        let semaphore = DispatchSemaphore(value: 0)
        let reportHandler: FirstResponderReportHandler = { responder in
            firstResponder = responder
            semaphore.signal()
        }
        if sendAction(#selector(UIResponder.reportAsFirstResponder), to: nil, from: reportHandler, for: nil) {
            semaphore.wait()
            return firstResponder
        } else {
            return nil
        }
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
    
    public func presentUndoAlert(with undoManager: UndoManager) {
        let cancelString = NSLocalizedString("Cancel", comment: "")
        let undoString = NSLocalizedString("Undo", comment: "")
        let redoString = NSLocalizedString("Redo", comment: "")
        
        let undoVC = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelString, style: .cancel)
        func addAction(alertTitle: String?, actionTitle: String, handler: @escaping () -> Void) {
            if let alertTitle = alertTitle {
                undoVC.title = alertTitle
            }
            undoVC.addAction(.init(title: actionTitle, style: .default, handler: { action in
                handler()
            }))
        }
        switch (undoManager.canUndo, undoManager.canRedo) {
        case (true, false):
            undoVC.addAction(cancelAction)
            addAction(alertTitle: undoManager.undoMenuItemTitle, actionTitle: undoString, handler: undoManager.undo)
        case (false, true):
            undoVC.addAction(cancelAction)
            addAction(alertTitle: undoManager.redoMenuItemTitle, actionTitle: redoString, handler: undoManager.redo)
        case (true, true):
            addAction(alertTitle: undoManager.undoMenuItemTitle, actionTitle: undoString, handler: undoManager.undo)
            addAction(alertTitle: nil, actionTitle: undoManager.redoMenuItemTitle, handler: undoManager.redo)
            undoVC.addAction(cancelAction)
        case (false, false):
            return
        }
        presentAlertController(undoVC)
    }
    
}

extension UIResponder {
    
    @objc fileprivate func reportAsFirstResponder(_ sender: Any) {
        if let handler = sender as? FirstResponderReportHandler {
            handler(self)
        }
    }
    
}
