//
//  UIDocument+.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 17/1/2019.
//  Copyright © 2019 narrativesaw. All rights reserved.
//

import UIKit

extension UIDocument {
    
    public func updateChangeCount(with undoManager: UndoManager) {
        if undoManager.isUndoing {
            updateChangeCount(.undone)
        } else if undoManager.isRedoing {
            updateChangeCount(.redone)
        } else {
            updateChangeCount(.done)
        }
    }
    
}
