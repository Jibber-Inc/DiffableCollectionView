//
//  
//
//  Created by Benji Dodgson on 9/21/22.
//

import Foundation
import UIKit

// MARK: - NSDiffableDataSource Functions

// These functions forward to the corresponding functions in the underlying NSDiffableDataSource
public extension CollectionViewDataSource {
    
    // MARK: - Standard DataSource Functions
    
    func apply(_ snapshot: SnapshotType, animatingDifferences: Bool = true) {
        self.diffableDataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: nil)
    }
    
    func apply(_ snapshot: SnapshotType, animatingDifferences: Bool = true) async {
        await self.diffableDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func applySnapshotUsingReloadData(_ snapshot: SnapshotType) async {
        await self.diffableDataSource.applySnapshotUsingReloadData(snapshot)
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
    
    func itemIdentifier(for indexPath: IndexPath) -> ItemType? {
        return self.diffableDataSource.itemIdentifier(for: indexPath)
    }
    
    func indexPath(for itemIdentifier: ItemType) -> IndexPath? {
        return self.diffableDataSource.indexPath(for: itemIdentifier)
    }
    
    // MARK: - Getter Convenience
    
    func itemIdentifiers(in section: SectionType) -> [ItemType] {
        return self.snapshot().itemIdentifiers(inSection: section)
    }
}

// MARK: - Snapshot Convenience Functions

public extension CollectionViewDataSource {
    
    // MARK: - Synchronous Functions
    
    func applyChanges(_ changes: (inout SnapshotType) -> Void) {
        var snapshot = self.snapshot()
        changes(&snapshot)
        self.apply(snapshot)
    }
    
    func appendItems(_ identifiers: [ItemType], toSection sectionIdentifier: SectionType? = nil) {
        self.applyChanges { snapshot in
            snapshot.appendItems(identifiers, toSection: sectionIdentifier)
        }
    }
    
    func insertItems(_ identifiers: [ItemType], in section: SectionType, atIndex index: Int) {
        self.applyChanges { snapshot in
            snapshot.insertItems(identifiers, in: section, atIndex: index)
        }
    }
    
    func insertItems(_ identifiers: [ItemType], beforeItem beforeIdentifier: ItemType) {
        self.applyChanges { snapshot in
            snapshot.insertItems(identifiers, beforeItem: beforeIdentifier)
        }
    }
    
    func insertItems(_ identifiers: [ItemType], afterItem afterIdentifier: ItemType) {
        self.applyChanges { snapshot in
            snapshot.insertItems(identifiers, afterItem: afterIdentifier)
        }
    }
    
    func deleteItems(_ identifiers: [ItemType]) {
        self.applyChanges { snapshot in
            snapshot.deleteItems(identifiers)
        }
    }
    
    func deleteAllItems() {
        self.applyChanges { snapshot in
            snapshot.deleteAllItems()
        }
    }
    
    func moveItem(_ identifier: ItemType, beforeItem toIdentifier: ItemType) {
        self.applyChanges { snapshot in
            snapshot.moveItem(identifier, beforeItem: toIdentifier)
        }
    }
    
    func moveItem(_ identifier: ItemType, afterItem toIdentifier: ItemType) {
        self.applyChanges { snapshot in
            snapshot.moveItem(identifier, afterItem: toIdentifier)
        }
    }
    
    func reloadItems(_ identifiers: [ItemType]) {
        self.applyChanges { snapshot in
            snapshot.reloadItems(identifiers)
        }
    }
    
    func reconfigureItems(_ identifiers: [ItemType]) {
        self.applyChanges { snapshot in
            snapshot.reconfigureItems(identifiers)
        }
    }
    
    func reconfigureAllItems() {
        self.applyChanges{ snapshot in
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
    
    // MARK: -  Asynchronous Functions
    
    func applyChanges(_ changes: (inout SnapshotType) -> Void) async {
        var snapshot = self.snapshot()
        changes(&snapshot)
        await self.apply(snapshot)
    }
    
    func appendItems(_ identifiers: [ItemType], toSection sectionIdentifier: SectionType? = nil) async {
        await self.applyChanges { snapshot in
            snapshot.appendItems(identifiers, toSection: sectionIdentifier)
        }
    }
    
    func insertItems(_ identifiers: [ItemType], in section: SectionType, atIndex index: Int) async {
        await self.applyChanges { snapshot in
            snapshot.insertItems(identifiers, in: section, atIndex: index)
        }
    }
    
    func insertItems(_ identifiers: [ItemType], beforeItem beforeIdentifier: ItemType) async {
        await self.applyChanges { snapshot in
            snapshot.insertItems(identifiers, beforeItem: beforeIdentifier)
        }
    }
    
    func insertItems(_ identifiers: [ItemType], afterItem afterIdentifier: ItemType) async {
        await self.applyChanges { snapshot in
            snapshot.insertItems(identifiers, afterItem: afterIdentifier)
        }
    }
    
    func deleteItems(_ identifiers: [ItemType]) async {
        await self.applyChanges { snapshot in
            snapshot.deleteItems(identifiers)
        }
    }
    
    func deleteAllItems() async {
        await self.applyChanges { snapshot in
            snapshot.deleteAllItems()
        }
    }
    
    func moveItem(_ identifier: ItemType, beforeItem toIdentifier: ItemType) async {
        await self.applyChanges { snapshot in
            snapshot.moveItem(identifier, beforeItem: toIdentifier)
        }
    }
    
    func moveItem(_ identifier: ItemType, afterItem toIdentifier: ItemType) async {
        await self.applyChanges { snapshot in
            snapshot.moveItem(identifier, afterItem: toIdentifier)
        }
    }
    
    func reloadItems(_ identifiers: [ItemType]) async {
        await self.applyChanges { snapshot in
            snapshot.reloadItems(identifiers)
        }
    }
    
    func reconfigureItems(_ identifiers: [ItemType]) async {
        await self.applyChanges { snapshot in
            snapshot.reconfigureItems(identifiers)
        }
    }
    
    func reconfigureAllItems() async {
        await self.applyChanges{ snapshot in
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
}
