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
    
}

extension UIAlertController {
    
    convenience public init?(undoManager: UndoManager) {
        guard undoManager.canUndo || undoManager.canRedo else { return nil }
        let cancelString = NSLocalizedString("Cancel", comment: "")
        let undoString = NSLocalizedString("Undo", comment: "")
        let redoString = NSLocalizedString("Redo", comment: "")
        
        self.init(title: nil, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelString, style: .cancel)
        let undoActionHandler: (UIAlertAction) -> Void = { action in
            undoManager.undo()
        }
        let redoActionHandler: (UIAlertAction) -> Void = { action in
            undoManager.redo()
        }
        switch (undoManager.canUndo, undoManager.canRedo) {
        case (true, false):
            addAction(cancelAction)
            title = undoManager.undoMenuItemTitle
            addAction(.init(title: undoString, style: .default, handler: undoActionHandler))
            
        case (false, true):
            addAction(cancelAction)
            title = undoManager.redoMenuItemTitle
            addAction(.init(title: redoString, style: .default, handler: redoActionHandler))
            
        case (true, true):
            title = undoManager.undoMenuItemTitle
            addAction(.init(title: undoString, style: .default, handler: undoActionHandler))
            addAction(.init(title: undoManager.redoMenuItemTitle, style: .default, handler: redoActionHandler))
            addAction(cancelAction)
            
        case (false, false):
            fatalError()
        }
    }
    
}

extension UIResponder {
    
    @objc fileprivate func reportAsFirstResponder(_ sender: Any) {
        if let handler = sender as? FirstResponderReportHandler {
            handler(self)
        }
    }
    
}
