//
//  UIAlertController+.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 2018/11/6.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import UIKit

private let bundle = Bundle(identifier: "com.narrativesaw.LHConvenientMethods")!

extension UIAlertController {
    
    convenience public init?(undoManager: UndoManager) {
        self.init(title: nil, message: nil, preferredStyle: .alert)
        let undoAction = UIAlertAction(title: NSLocalizedString("Undo", bundle: bundle, comment: ""), style: .default) { action in
            undoManager.undo()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", bundle: bundle, comment: ""), style: .cancel)
        let redoActionHandler: (UIAlertAction) -> Void = { action in
            undoManager.redo()
        }
        switch (undoManager.canUndo, undoManager.canRedo) {
        case (true, false):
            addAction(cancelAction)
            title = undoManager.undoMenuItemTitle
            addAction(undoAction)
            
        case (false, true):
            addAction(cancelAction)
            title = undoManager.redoMenuItemTitle
            addAction(.init(title: NSLocalizedString("Redo", bundle: bundle, comment: ""), style: .default, handler: redoActionHandler))
            
        case (true, true):
            title = undoManager.undoMenuItemTitle
            addAction(undoAction)
            addAction(.init(title: undoManager.redoMenuItemTitle, style: .default, handler: redoActionHandler))
            addAction(cancelAction)
            
        case (false, false):
            return nil
        }
    }
    
    public func present() {
        let vc = UIViewController()
        let window = UIWindow()
        window.backgroundColor = nil
        window.windowLevel = .alert
        window.isHidden = false
        window.rootViewController = vc
        vc.present(self, animated: true)
    }
    
}
