//
//  UICollectionView+.swift
//  LHConvenientMethods
//
//  Created by 許立衡 on 22/12/2018.
//  Copyright © 2018 narrativesaw. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    public func indexPath(for supplementaryView: UICollectionReusableView, ofKind kind: String) -> IndexPath? {
        guard let index = visibleSupplementaryViews(ofKind: kind).firstIndex(of: supplementaryView) else { return nil }
        return indexPathsForVisibleSupplementaryElements(ofKind: kind)[index]
    }
    
    public func scrollToSection(_ section: Int, animated: Bool) {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let sectionHeaderIsSticky = layout.sectionHeadersPinToVisibleBounds
            layout.sectionHeadersPinToVisibleBounds = false
            
            if var rect = layout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section))?.frame {
                rect.size.height = frame.size.height - (adjustedContentInset.top + adjustedContentInset.bottom)
                scrollRectToVisible(rect, animated: animated)
            }
            layout.sectionHeadersPinToVisibleBounds = sectionHeaderIsSticky
        }
    }
    
}
