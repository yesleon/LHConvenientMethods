//
//  UICollectionViewCell+.swift
//  Storyboards
//
//  Created by 許立衡 on 2018/10/22.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
    public func performAction(_ action: Selector, withSender sender: Any?) {
        guard let collectionView = superview as? UICollectionView else { return }
        guard let indexPath = collectionView.indexPath(for: self) else { return }
        collectionView.delegate?.collectionView?(collectionView, performAction: action, forItemAt: indexPath, withSender: sender)
    }
    
}
