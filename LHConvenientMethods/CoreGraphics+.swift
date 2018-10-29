//
//  CoreGraphics+.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 2018/10/29.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import CoreGraphics


public extension CGPoint {
    
    func vector(to point: CGPoint) -> CGVector {
        return CGVector(dx: point.x - x, dy: point.y - y)
    }
    
    func applying(_ vector: CGVector) -> CGPoint {
        return CGPoint(x: x + vector.dx, y: y + vector.dy)
    }
    
}

public extension CGVector {
    
    static func *(lhs: CGVector, rhs: CGFloat) -> CGVector {
        return CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }
    
    func distance() -> CGFloat {
        return ((dx * dx) + (dy * dy)).squareRoot()
    }
    
    func angle() -> CGFloat {
        return atan2(dy, dx)
    }
    
    init(angle: CGFloat) {
        self.init(dx: cos(angle), dy: sin(angle))
    }
    
    init(point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }
    
}

public extension CGSize {
    
    static func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    
}
