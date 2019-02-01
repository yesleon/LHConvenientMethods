//
//  UndoManager+.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 7/1/2019.
//  Copyright © 2019 narrativesaw. All rights reserved.
//

import Foundation


extension UndoManager {
    
    public func registerUndo<TargetType>(withTarget target: TargetType, actionName: String, handler: @escaping (TargetType) -> Void) where TargetType : AnyObject {
        if !isUndoing, !isRedoing {
            setActionName(actionName)
        }
        registerUndo(withTarget: target, handler: handler)
    }
    
}
