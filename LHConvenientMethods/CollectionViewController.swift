//
//  CollectionViewController.swift
//  StoryboardsStoryboardScene
//
//  Created by 許立衡 on 1/2/2019.
//  Copyright © 2019 narrativesaw. All rights reserved.
//

import UIKit

public protocol CollectionViewControllerDelegate: AnyObject {
    func collectionViewController<Section>(_ collectionVC: CollectionViewController<Section>, prepare cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    func collectionViewController<Section>(_ collectionVC: CollectionViewController<Section>, prepare view: UICollectionReusableView, ofKind kind: String, forItemAt indexPath: IndexPath)
    func collectionViewControllerDidChange<Section>(_ collectionVC: CollectionViewController<Section>)
    func collectionViewController<Section>(_ collectionVC: CollectionViewController<Section>, didSelectItemAt indexPath: IndexPath)
    func collectionViewController<Section>(_ collectionVC: CollectionViewController<Section>, shouldEditItemAt indexPath: IndexPath) -> Bool
    func collectionViewController<Section>(_ collectionVC: CollectionViewController<Section>, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters?
}

private let cellIdentifier = "Cell"

public protocol EmptyInitializing {
    init()
}

public protocol Duplicating {
    func duplicated() -> Self
}

public protocol ArrayManaging {
    associatedtype Item: EmptyInitializing & Duplicating
    var items: [Item] { get set }
}

extension Array where Element: ArrayManaging {
    
    public subscript(indexPath: IndexPath) -> Element.Item {
        get {
            return self[indexPath.section].items[indexPath.item]
        }
        set {
            self[indexPath.section].items[indexPath.item] = newValue
        }
    }
    
    mutating func insertItem(_ item: Element.Item, at indexPath: IndexPath) {
        self[indexPath.section].items.insert(item, at: indexPath.item)
    }
    
    @discardableResult
    mutating func removeItem(at indexPath: IndexPath) -> Element.Item {
        return self[indexPath.section].items.remove(at: indexPath.item)
    }
    
    mutating func moveItem(at fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        let item = removeItem(at: fromIndexPath)
        insertItem(item, at: toIndexPath)
    }
    
}

public class CollectionViewController<Section>: UICollectionViewController, UICollectionViewDragDelegate, UICollectionViewDropDelegate where Section: ArrayManaging {
    
    // MARK: - Properties
    
    public weak var delegate: CollectionViewControllerDelegate?
    
    private var _collection: [Section] = []
    
    public var collection: [Section] {
        get {
            return _collection
        }
        set {
            _collection = newValue
            if isViewLoaded {
                collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    deinit {
        undoManager?.removeAllActions(withTarget: self)
    }
    
    // MARK: - View Managing
    
    public override func loadView() {
        super.loadView()
        collectionView.backgroundColor = .white
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UICollectionView.elementKindSectionHeader)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UICollectionView.elementKindSectionFooter)
    }
    
    // MARK: - Editing
    
    public func updateSection(at index: Int, with newSection: Section) {
        let oldSection = _collection[index]
        undoManager?.registerUndo(withTarget: self) { $0.updateSection(at: index, with: oldSection) }
        
        _collection[index] = newSection
        
        collectionView.reloadSections([index])
        
        delegate?.collectionViewControllerDidChange(self)
    }
    
    public func insertSection(_ section: Section, at index: Int) {
        undoManager?.registerUndo(withTarget: self) { $0.deleteSection(at: index) }
        
        _collection.insert(section, at: index)
        
        collectionView.insertSections([index])
        
        delegate?.collectionViewControllerDidChange(self)
    }
    
    public func deleteSection(at index: Int) {
        let deletedSection = _collection[index]
        undoManager?.registerUndo(withTarget: self) { $0.insertSection(deletedSection, at: index) }
        
        _collection.remove(at: index)
        
        collectionView.deleteSections([index])
        
        delegate?.collectionViewControllerDidChange(self)
    }
    
    public func moveSection(at fromIndex: Int, to toIndex: Int) {
        undoManager?.registerUndo(withTarget: self) { $0.moveSection(at: toIndex, to: fromIndex) }
        
        _collection.moveElement(at: fromIndex, to: toIndex)
        
        collectionView.moveSection(fromIndex, toSection: toIndex)
        
        delegate?.collectionViewControllerDidChange(self)
    }
    
    public func updateItem(at indexPath: IndexPath, with item: Section.Item) {
        let oldItem = _collection[indexPath]
        undoManager?.registerUndo(withTarget: self) { $0.updateItem(at: indexPath, with: oldItem) }
        
        _collection[indexPath] = item
        
        collectionView.reloadItems(at: [indexPath])
        
        delegate?.collectionViewControllerDidChange(self)
    }
    
    public func insertItem(_ item: Section.Item, at indexPath: IndexPath) {
        undoManager?.registerUndo(withTarget: self) { $0.deleteItem(at: indexPath) }
        
        _collection.insertItem(item, at: indexPath)
        
        collectionView.insertItems(at: [indexPath])
        
        delegate?.collectionViewControllerDidChange(self)
    }
    
    public func deleteItem(at indexPath: IndexPath) {
        let deletedItem = _collection[indexPath]
        undoManager?.registerUndo(withTarget: self) { $0.insertItem(deletedItem, at: indexPath) }
        
        _collection.removeItem(at: indexPath)
        
        collectionView.deleteItems(at: [indexPath])
        
        delegate?.collectionViewControllerDidChange(self)
    }
    
    public func moveItem(at fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        undoManager?.registerUndo(withTarget: self) { $0.moveItem(at: toIndexPath, to: fromIndexPath) }
        
        _collection.moveItem(at: fromIndexPath, to: toIndexPath)
        
        collectionView.moveItem(at: fromIndexPath, to: toIndexPath)
        
        delegate?.collectionViewControllerDidChange(self)
    }
    
    // MARK: - Collection View Managing
    
    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _collection.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _collection[section].items.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        delegate?.collectionViewController(self, prepare: cell, forItemAt: indexPath)
        return cell
    }
    
    public override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind, for: indexPath)
        delegate?.collectionViewController(self, prepare: view, ofKind: kind, forItemAt: indexPath)
        return view
    }
    
    public override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionHeader
            || elementKind == UICollectionView.elementKindSectionFooter {
            view.layer.zPosition = 0
        }
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionViewController(self, didSelectItemAt: indexPath)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        if delegate?.collectionViewController(self, shouldEditItemAt: indexPath) ?? true {
            UIMenuController.shared.menuItems = [
                UIMenuItem(title: NSLocalizedString("Insert", comment: ""), action: NSSelectorFromString("insert:")),
                UIMenuItem(title: NSLocalizedString("Duplicate", comment: ""), action: NSSelectorFromString("duplicate:"))
            ]
            return true
        } else {
            return false
        }
    }
    
    public override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        switch action {
        case NSSelectorFromString("delete:"), NSSelectorFromString("insert:"), NSSelectorFromString("duplicate:"):
            return true
        default:
            return false
        }
    }
    
    public override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        switch action {
        case NSSelectorFromString("delete:"):
            deleteItem(at: indexPath)
        case NSSelectorFromString("insert:"):
            insertItem(.init(), at: indexPath)
        case NSSelectorFromString("duplicate:"):
            var newIndexPath = indexPath
            newIndexPath.item += 1
            insertItem(_collection[indexPath].duplicated(), at: newIndexPath)
        default:
            break
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard delegate?.collectionViewController(self, shouldEditItemAt: indexPath) ?? true else { return [] }
        let item = UIDragItem(itemProvider: NSItemProvider())
        item.localObject = _collection[indexPath]
        return [item]
    }
    
    public func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        return delegate?.collectionViewController(self, dragPreviewParametersForItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        guard let indexPath = destinationIndexPath, delegate?.collectionViewController(self, shouldEditItemAt: indexPath) ?? true else {
            return UICollectionViewDropProposal(operation: .cancel)
        }
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else if session.items.first?.localObject is Section.Item {
            return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .cancel)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        coordinator.items.forEach {
            if let destinationIndexPath = coordinator.destinationIndexPath {
                if let sourceIndexPath = $0.sourceIndexPath {
                    undoManager?.registerUndo(withTarget: self) {
                        $0.moveItem(at: destinationIndexPath, to: sourceIndexPath)
                    }
                    collectionView.performBatchUpdates({
                        _collection.moveItem(at: sourceIndexPath, to: destinationIndexPath)

                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    
                    delegate?.collectionViewControllerDidChange(self)
                    
                } else if let item = $0.dragItem.localObject as? Section.Item {
                    insertItem(item, at: destinationIndexPath)
                }
                coordinator.drop($0.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }

}

extension UICollectionViewCell {
    
    open override func delete(_ sender: Any?) {
        performAction(#selector(delete(_:)), withSender: sender)
    }
    
    @objc open func insert(_ sender: Any?) {
        performAction(#selector(insert(_:)), withSender: sender)
    }
    
    @objc open func duplicate(_ sender: Any?) {
        performAction(#selector(duplicate(_:)), withSender: sender)
    }
    
}
