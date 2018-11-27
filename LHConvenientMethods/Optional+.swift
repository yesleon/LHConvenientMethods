//
//  Optional+.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 2018/11/13.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

//import Foundation

extension Optional {
    
    public mutating func remove() -> Wrapped? {
        let returnValue = self
        self = nil
        return returnValue
    }
    
}
