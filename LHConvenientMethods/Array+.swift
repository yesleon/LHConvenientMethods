//
//  Array+.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 2019/2/11.
//  Copyright © 2019 narrativesaw. All rights reserved.
//

import Foundation


extension Array {
    
    public mutating func moveElement(at fromIndex: Index, to toIndex: Index) {
        insert(remove(at: fromIndex), at: toIndex)
    }
    
}
