//
//
//
//  Created by Benji Dodgson on 9/21/22.
//

import Foundation
import UIKit
import Combine

// Both this and the DiffableCollectionViewController are exactly the same except one is a view controller, and this is not.
public class DiffableCollectionViewManager<SectionType: Hashable,
                                    ItemType: Hashable,
                                    DataSource: CollectionViewDataSource<SectionType, ItemType>>:
                                        NSObject, UICollectionViewDelegate {

    public lazy var dataSource = DataSource(collectionView: self.collectionView)

    @Published public var selectedItems: [ItemType] = []

    public final var __selectedItems: [ItemType] {
        return self.collectionView.indexPathsForSelectedItems?.compactMap({ ip in
            return self.dataSource.itemIdentifier(for: ip)
        }) ?? []
    }

    public let collectionView: UICollectionView

    public init(with collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        self.initializeCollectionView()
    }

    public func initializeCollectionView() {
        self.collectionView.allowsMultipleSelection = true
        self.collectionView.delegate = self
    }

    @MainActor
    public func loadData() async {
        
        // Forces the collectionView to layout
        self.collectionView.setNeedsLayout()
        self.collectionView.layoutIfNeeded()

        guard !Task.isCancelled else {
            return
        }

        let dataDictionary =  await self.retrieveDataForSnapshot()

        let snapshot = self.getInitialSnapshot(with: dataDictionary)
        await self.dataSource.apply(snapshot)
    }

    public func getInitialSnapshot(with dictionary: [SectionType: [ItemType]])
    -> NSDiffableDataSourceSnapshot<SectionType, ItemType> {

        var snapshot = self.dataSource.snapshot()
        snapshot.deleteAllItems()

        let allSections: [SectionType] = self.getAllSections()

        snapshot.appendSections(allSections)

        allSections.forEach { section in
            if let items = dictionary[section] {
                snapshot.appendItems(items, toSection: section)
            }
        }

        return snapshot
    }

    // MARK: Overrides

    // Used to capture and store any data needed for the snapshot
    // Dictionary must include all SectionType's in order to be properly displayed
    // Empty array may be returned for sections that dont have items.
    public func retrieveDataForSnapshot() async -> [SectionType: [ItemType]] {
        fatalError("retrieveDataForSnapshot NOT IMPLEMENTED")
    }

    public func getAllSections() -> [SectionType] {
        fatalError("getAllSections NOT IMPLEMENTED")
    }

    //MARK: CollectionViewDelegate

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewManagerCell {
            cell.update(isSelected: true )
        }

        self.selectedItems = __selectedItems
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewManagerCell {
            cell.update(isSelected: false)
        }

        self.selectedItems = __selectedItems
    }
}
