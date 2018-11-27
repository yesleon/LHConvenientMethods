//
//  Declarative.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 2018/11/9.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import Foundation

public protocol Declarative { }
extension NSObject: Declarative { }
extension Array: Declarative { }

extension Declarative {
    
    public func set(handler: @escaping (Self) -> Void) {
        handler(self)
    }
    
    public mutating func modify(handler: @escaping (inout Self) -> Void) {
        handler(&self)
    }
    
}

extension Declarative where Self: NSObject {
    
    public init(configureHanler: (Self) -> Void) {
        self.init()
        configureHanler(self)
    }
    
    public init(configureHanler: (Self) throws -> Void) rethrows {
        self.init()
        try configureHanler(self)
    }
    
}

extension Declarative where Self: UIView {
    
    public static func animateObject<T>(object: T, withDuration duration: TimeInterval, delay: TimeInterval, options: UIView.AnimationOptions = [], animations: @escaping (T) -> Void, completion: ((T, Bool) -> Void)? = nil) {
        animate(withDuration: duration, delay: delay, options: options, animations: {
            animations(object)
        }) { success in
            completion?(object, success)
        }
    }
    
    public static func animateObject<T>(object: T, withDuration duration: TimeInterval, animations: @escaping (T) -> Void, completion: ((T, Bool) -> Void)?) {
        animateObject(object: object, withDuration: duration, delay: 0, animations: animations, completion: completion)
    }
    
    public static func animateObject<T>(object: T, withDuration duration: TimeInterval, animations: @escaping (T) -> Void) {
        animateObject(object: object, withDuration: duration, delay: 0, animations: animations)
    }
    
}
