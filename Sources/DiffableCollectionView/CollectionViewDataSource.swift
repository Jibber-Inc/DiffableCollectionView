//
//  
//
//  Created by Benji Dodgson on 9/21/22.
//

import Foundation
import UIKit

typealias CompletionOptional = (() -> Void)?

class DiffableDataSource<SectionType: Hashable, ViewModelType: Hashable>: UICollectionViewDiffableDataSource<SectionType, ViewModelType> {}

class CollectionViewDataSource<SectionType: Hashable, ViewModelType: Hashable> {
    
    typealias SnapshotType = NSDiffableDataSourceSnapshot<SectionType, ViewModelType>
    
    private var diffableDataSource: DiffableDataSource<SectionType, ViewModelType>!
    
    var didApplyChanges: CompletionOptional = nil
    var didApplySnapshot: CompletionOptional = nil
            
    required init(collectionView: UICollectionView) {
        self.diffableDataSource = DiffableDataSource<SectionType, ViewModelType>(collectionView: collectionView,
                                                                                 cellProvider: { [unowned self] (collectionView, indexPath, type) in
            guard let section = self.sectionIdentifier(for: indexPath.section) else { return nil }
            
            return self.dequeueCell(with: collectionView,
                                    indexPath: indexPath,
                                    section: section,
                                    type: type)
        })
        
        self.diffableDataSource.supplementaryViewProvider = { [unowned self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let section = self.sectionIdentifier(for: indexPath.section) else { return nil }
            
            return self.dequeueSupplementaryView(with: collectionView,
                                                 kind: kind,
                                                 section: section,
                                                 indexPath: indexPath)
        }
    }
    
    /// Returns a configured UICollectionViewCell dequeued from the passed in collection view.
    func dequeueCell(with collectionView: UICollectionView,
                     indexPath: IndexPath,
                     section: SectionType,
                     type: ViewModelType) -> UICollectionViewCell? {
        fatalError()
    }
    
    /// Returns a configured supplemental view dequeued from the passed in collection view.
    func dequeueSupplementaryView(with collectionView: UICollectionView,
                                  kind: String,
                                  section: SectionType,
                                  indexPath: IndexPath) -> UICollectionReusableView? {
        return nil
    }
}

// MARK: - NSDiffableDataSource Functions

// These functions forward to the corresponding functions in the underlying NSDiffableDataSource

extension CollectionViewDataSource {
    
    // MARK: - Standard DataSource Functions
    
    func apply(_ snapshot: SnapshotType, animatingDifferences: Bool = true) {
        self.diffableDataSource.apply(snapshot, animatingDifferences: animatingDifferences) {
            self.didApplySnapshot?()
        }
    }
    
    func apply(_ snapshot: SnapshotType, animatingDifferences: Bool = true) async {
        await self.diffableDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        self.didApplySnapshot?()
    }
    
    func applySnapshotUsingReloadData(_ snapshot: SnapshotType) async {
        await self.diffableDataSource.applySnapshotUsingReloadData(snapshot)
        self.didApplySnapshot?()
    }
    
    func snapshot() -> SnapshotType {
        return self.diffableDataSource.snapshot()
    }
    
    func sectionIdentifier(for index: Int) -> SectionType? {
        return self.diffableDataSource.sectionIdentifier(for: index)
    }
    
    func index(for sectionIdentifier: SectionType) -> Int? {
        return self.diffableDataSource.index(for: sectionIdentifier)
    }
    
    func itemIdentifier(for indexPath: IndexPath) -> ViewModelType? {
        return self.diffableDataSource.itemIdentifier(for: indexPath)
    }
    
    func indexPath(for itemIdentifier: ViewModelType) -> IndexPath? {
        return self.diffableDataSource.indexPath(for: itemIdentifier)
    }
    
    // MARK: - Getter Convenience
    
    func itemIdentifiers(in section: SectionType) -> [ViewModelType] {
        return self.snapshot().itemIdentifiers(inSection: section)
    }
}

// MARK: - Snapshot Convenience Functions
extension CollectionViewDataSource {
    
    // MARK: - Synchronous Functions
    
    func applyChanges(_ changes: (inout SnapshotType) -> Void) {
        var snapshot = self.snapshot()
        changes(&snapshot)
        self.apply(snapshot)
        self.didApplyChanges?()
    }
    
    func appendItems(_ identifiers: [ViewModelType], toSection sectionIdentifier: SectionType? = nil) {
        self.applyChanges { snapshot in
            snapshot.appendItems(identifiers, toSection: sectionIdentifier)
        }
    }
    
    func insertItems(_ identifiers: [ViewModelType], in section: SectionType, atIndex index: Int) {
        self.applyChanges { snapshot in
            snapshot.insertItems(identifiers, in: section, atIndex: index)
        }
    }
    
    func insertItems(_ identifiers: [ViewModelType], beforeItem beforeIdentifier: ViewModelType) {
        self.applyChanges { snapshot in
            snapshot.insertItems(identifiers, beforeItem: beforeIdentifier)
        }
    }
    
    func insertItems(_ identifiers: [ViewModelType], afterItem afterIdentifier: ViewModelType) {
        self.applyChanges { snapshot in
            snapshot.insertItems(identifiers, afterItem: afterIdentifier)
        }
    }
    
    func deleteItems(_ identifiers: [ViewModelType]) {
        self.applyChanges { snapshot in
            snapshot.deleteItems(identifiers)
        }
    }
    
    func deleteAllItems() {
        self.applyChanges { snapshot in
            snapshot.deleteAllItems()
        }
    }
    
    func moveItem(_ identifier: ViewModelType, beforeItem toIdentifier: ViewModelType) {
        self.applyChanges { snapshot in
            snapshot.moveItem(identifier, beforeItem: toIdentifier)
        }
    }
    
    func moveItem(_ identifier: ViewModelType, afterItem toIdentifier: ViewModelType) {
        self.applyChanges { snapshot in
            snapshot.moveItem(identifier, afterItem: toIdentifier)
        }
    }
    
    func reloadItems(_ identifiers: [ViewModelType]) {
        self.applyChanges { snapshot in
            snapshot.reloadItems(identifiers)
        }
    }
    
    func reconfigureItems(_ identifiers: [ViewModelType]) {
        self.applyChanges { snapshot in
            snapshot.reconfigureItems(identifiers)
        }
    }
    
    func reconfigureAllItems() {
        self.applyChanges { snapshot in
            let allItems = snapshot.itemIdentifiers
            snapshot.reconfigureItems(allItems)
        }
    }
    
    func reconfigureItem(atIndex index: Int, in section: SectionType) {
        self.applyChanges { snapshot in
            snapshot.reconfigureItem(atIndex: index, in: section)
        }
    }
    
    func appendSections(_ identifiers: [SectionType]) {
        self.applyChanges { snapshot in
            snapshot.appendSections(identifiers)
        }
    }
    
    func insertSections(_ identifiers: [SectionType], beforeSection toIdentifier: SectionType) {
        self.applyChanges { snapshot in
            snapshot.insertSections(identifiers, beforeSection: toIdentifier)
        }
    }
    
    func insertSections(_ identifiers: [SectionType], afterSection toIdentifier: SectionType) {
        self.applyChanges { snapshot in
            snapshot.insertSections(identifiers, afterSection: toIdentifier)
        }
    }
    
    func deleteSections(_ identifiers: [SectionType]) {
        self.applyChanges { snapshot in
            snapshot.deleteSections(identifiers)
        }
    }
    
    func moveSection(_ identifier: SectionType, beforeSection toIdentifier: SectionType) {
        self.applyChanges { snapshot in
            snapshot.moveSection(identifier, beforeSection: toIdentifier)
        }
    }
    
    func moveSection(_ identifier: SectionType, afterSection toIdentifier: SectionType) {
        self.applyChanges { snapshot in
            snapshot.moveSection(identifier, afterSection: toIdentifier)
        }
    }
    
    func reloadSections(_ identifiers: [SectionType]) {
        self.applyChanges { snapshot in
            snapshot.reloadSections(identifiers)
        }
    }
    
    // MARK: Asynchronous Functions
    func applyChanges(_ changes: (inout SnapshotType) -> Void) async {
        var snapshot = self.snapshot()
        changes(&snapshot)
        await self.apply(snapshot)
    }
    
    func appendItems(_ identifiers: [ViewModelType], toSection sectionIdentifier: SectionType? = nil) async {
        await self.applyChanges { snapshot in
            snapshot.appendItems(identifiers, toSection: sectionIdentifier)
        }
    }
    
    func insertItems(_ identifiers: [ViewModelType], in section: SectionType, atIndex index: Int) async {
        await self.applyChanges { snapshot in
            snapshot.insertItems(identifiers, in: section, atIndex: index)
        }
    }
    
    func insertItems(_ identifiers: [ViewModelType], beforeItem beforeIdentifier: ViewModelType) async {
        await self.applyChanges { snapshot in
            snapshot.insertItems(identifiers, beforeItem: beforeIdentifier)
        }
    }
    
    func insertItems(_ identifiers: [ViewModelType], afterItem afterIdentifier: ViewModelType) async {
        await self.applyChanges { snapshot in
            snapshot.insertItems(identifiers, afterItem: afterIdentifier)
        }
    }
    
    func deleteItems(_ identifiers: [ViewModelType]) async {
        await self.applyChanges { snapshot in
            snapshot.deleteItems(identifiers)
        }
    }
    
    func deleteAllItems() async {
        await self.applyChanges { snapshot in
            snapshot.deleteAllItems()
        }
    }
    
    func moveItem(_ identifier: ViewModelType, beforeItem toIdentifier: ViewModelType) async {
        await self.applyChanges { snapshot in
            snapshot.moveItem(identifier, beforeItem: toIdentifier)
        }
    }
    
    func moveItem(_ identifier: ViewModelType, afterItem toIdentifier: ViewModelType) async {
        await self.applyChanges { snapshot in
            snapshot.moveItem(identifier, afterItem: toIdentifier)
        }
    }
    
    func reloadItems(_ identifiers: [ViewModelType]) async {
        await self.applyChanges { snapshot in
            snapshot.reloadItems(identifiers)
        }
    }
    
    func reconfigureItems(_ identifiers: [ViewModelType]) async {
        await self.applyChanges { snapshot in
            snapshot.reconfigureItems(identifiers)
        }
    }
    
    func reconfigureAllItems() async {
        await self.applyChanges { snapshot in
            let allItems = snapshot.itemIdentifiers
            snapshot.reconfigureItems(allItems)
        }
    }
    
    func appendSections(_ identifiers: [SectionType]) async {
        await self.applyChanges { snapshot in
            snapshot.appendSections(identifiers)
        }
    }
    
    func insertSections(_ identifiers: [SectionType], beforeSection toIdentifier: SectionType) async {
        await self.applyChanges { snapshot in
            snapshot.insertSections(identifiers, beforeSection: toIdentifier)
        }
    }
    
    func insertSections(_ identifiers: [SectionType], afterSection toIdentifier: SectionType) async {
        await self.applyChanges { snapshot in
            snapshot.insertSections(identifiers, afterSection: toIdentifier)
        }
    }
    
    func deleteSections(_ identifiers: [SectionType]) async {
        await self.applyChanges { snapshot in
            snapshot.deleteSections(identifiers)
        }
    }
    
    func moveSection(_ identifier: SectionType, beforeSection toIdentifier: SectionType) async {
        await self.applyChanges { snapshot in
            snapshot.moveSection(identifier, beforeSection: toIdentifier)
        }
    }
    
    func moveSection(_ identifier: SectionType, afterSection toIdentifier: SectionType) async {
        await self.applyChanges { snapshot in
            snapshot.moveSection(identifier, afterSection: toIdentifier)
        }
    }
    
    func reloadSections(_ identifiers: [SectionType]) async {
        await self.applyChanges { snapshot in
            snapshot.reloadSections(identifiers)
        }
    }
    
    func reset(sections: [SectionType], withIdentifiers identifiers: [ViewModelType]) async {
        await self.applyChanges({ snapshot in
            sections.forEach { section in
                snapshot.setItems([], in: section)
                snapshot.setItems(identifiers, in: section)
            }
        })
    }
    
    func resetItemIdentifiers() async {
        await self.applyChanges({ snapshot in
            snapshot.resetItemIdentifiers()
        })
    }
}
