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
    
    static func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
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
    
    func aspectRatio() -> CGFloat {
        return width / height
    }
    
}

public extension CGRect {
    
    func aspectRatio() -> CGFloat {
        return size.aspectRatio()
    }
    
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    
}

public extension UIEdgeInsets {
    init(containing: CGRect, contained: CGRect) {
        self.init(top: contained.minY - containing.minY,
                  left: contained.minX - containing.minX,
                  bottom: containing.maxY - contained.maxY,
                  right: containing.maxX - contained.maxX)
    }
    static func *(insets: UIEdgeInsets, scale: CGScale) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: insets.top * scale.height, left: insets.left * scale.width, bottom: insets.bottom * scale.height, right: insets.right * scale.width)
    }
    static func /(insets: UIEdgeInsets, scale: CGScale) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: insets.top / scale.height, left: insets.left / scale.width, bottom: insets.bottom / scale.height, right: insets.right / scale.width)
    }
    func inverted() -> UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }
}

public typealias CGScale = CGSize
