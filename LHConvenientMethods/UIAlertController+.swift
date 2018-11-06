//
//  UIAlertController+.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 2018/11/6.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import Foundation

private let bundle = Bundle(identifier: "com.narrativesaw.LHConvenientMethods")!

extension UIAlertController {
    
    convenience public init?(undoManager: UndoManager) {
        guard undoManager.canUndo || undoManager.canRedo else { return nil }
        let cancelString = NSLocalizedString("Cancel", bundle: bundle, comment: "")
        let undoString = NSLocalizedString("Undo", bundle: bundle, comment: "")
        let redoString = NSLocalizedString("Redo", bundle: bundle, comment: "")
        
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
