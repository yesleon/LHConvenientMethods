//
//  UIViewController+.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 2018/11/14.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import Foundation

let floatingWindowAppearanceNeedsUpdate = NSNotification.Name("floatingWindowAppearanceNeedsUpdate")

extension UIViewController {
    
    @objc open var prefersFloatingWindowHidden: Bool {
        if let child = childForFloatingWindowHidden {
            return child.prefersFloatingWindowHidden
        } else {
            return false
        }
    }
    
    @objc open var childForFloatingWindowHidden: UIViewController? {
        return nil
    }
    
    open func setNeedsFloatingWindowAppearanceUpdate() {
        NotificationCenter.default.post(name: floatingWindowAppearanceNeedsUpdate, object: nil)
    }
    
}

extension UINavigationController {
    
    open override var childForFloatingWindowHidden: UIViewController? {
        return viewControllers.first
    }
    
}

extension UIApplication {
    
    var floatingWindow: FloatingWindow? {
        return windows.compactMap({ $0 as? FloatingWindow }).first
    }
    
    open var installsFloatingWindow: Bool {
        get {
            return floatingWindow != nil
        }
        set {
            if newValue {
                guard floatingWindow == nil else { return }
                let floatingVC = FloatingViewController()
                FloatingWindow(floatingVC: floatingVC).persistAndShow()
                NotificationCenter.default.addObserver(self, selector: #selector(updateFloatingWindowAppearance), name: floatingWindowAppearanceNeedsUpdate, object: nil)
                
            } else {
                floatingWindow?.destroy()
            }
        }
    }
    
    @objc func updateFloatingWindowAppearance() {
        guard var topVC = keyWindow?.topViewController else { return }
        if topVC.isBeingDismissed, let presentingViewController = topVC.presentingViewController {
            topVC = presentingViewController
        }
        floatingWindow?.alpha = topVC.prefersFloatingWindowHidden ? 0 : 1
    }
    
}

class FloatingWindow: UIWindow {
    
    var floatingVC: FloatingViewController! {
        return rootViewController as? FloatingViewController
    }

    convenience init(floatingVC: FloatingViewController) {
        self.init(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        rootViewController = floatingVC
        windowLevel = .normal + 1
        floatingVC.savedWindow = self
    }
    
    func persistAndShow() {
        floatingVC.savedWindow = self
        isHidden = false
    }
    
    func destroy() {
        floatingVC.savedWindow = nil
    }
    
}

class FloatingViewController: UIViewController {
    
    var savedWindow: FloatingWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
}
