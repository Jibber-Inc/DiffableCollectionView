//
//  NSDiffableDataSourceSnapshot+Extensions
//  
//
//  Created by Benji Dodgson on 9/21/22.
//

import Foundation
import UIKit

extension NSDiffableDataSourceSnapshot {

    /// Inserts the given items into the section starting at the given index. If the index is is greater than the number of items in the section,
    /// then the new items are appended to the section.
    mutating func insertItems(_ identifiers: [ItemIdentifierType],
                              in section: SectionIdentifierType,
                              atIndex index: Int) {

        let itemsInSection = self.itemIdentifiers(inSection: section)
        if let itemAtIndex = itemsInSection[safe: index] {
            self.insertItems(identifiers, beforeItem: itemAtIndex)
        } else {
            self.appendItems(identifiers, toSection: section)
        }
    }

    /// Removes all of the current items in the specified section and inserts all the items in the given array.
    /// If the section doesn't exist in the snapshot yet, then it is appended before inserting the items.
    mutating func setItems(_ identifiers: [ItemIdentifierType], in section: SectionIdentifierType) {
        if !self.sectionIdentifiers.contains(section) {
            self.appendSections([section])
        }

        self.deleteItems(self.itemIdentifiers(inSection: section))
        self.appendItems(identifiers, toSection: section)
    }

    /// Reloads the item contained in the specified section at that section's specified index.
    /// If no item exists at that index, this function does nothing.
    mutating func reloadItem(atIndex index: Int, in section: SectionIdentifierType) {
        let itemsInSection = self.itemIdentifiers(inSection: section)
        if let itemAtIndex = itemsInSection[safe: index] {
            self.reloadItems([itemAtIndex])
        }
    }

    /// Reconfigures the item contained in the specified section at that section's specified index.
    /// If no item exists at that index, this function does nothing.
    mutating func reconfigureItem(atIndex index: Int, in section: SectionIdentifierType) {
        let itemsInSection = self.itemIdentifiers(inSection: section)
        if let itemAtIndex = itemsInSection[safe: index] {
            self.reconfigureItems([itemAtIndex])
        }
    }

    func indexPathOfItem(_ identifier: ItemIdentifierType) -> IndexPath? {
        guard let indexOfItem = self.indexOfItem(identifier),
              let containingSection = self.sectionIdentifier(containingItem: identifier),
              let indexOfSection = self.indexOfSection(containingSection) else { return nil }

        return IndexPath(item: indexOfItem, section: indexOfSection)
    }
}
