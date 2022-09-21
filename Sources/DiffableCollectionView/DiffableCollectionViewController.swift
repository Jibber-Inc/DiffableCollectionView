//
//
//
//  Created by Benji Dodgson on 9/21/22.
//

import Foundation
import UIKit
import Combine

// Both this and the DiffableCollectionViewManager are exactly the same except one is a view controller, and the other is not.
public class DiffableCollectionViewController<SectionType: Hashable,
                                       ItemType: Hashable,
                                       DataSource: CollectionViewDataSource<SectionType, ItemType>>:
                                        UIViewController, UICollectionViewDelegate {
    
    public lazy var dataSource = DataSource(collectionView: self.collectionView)

    @Published public var selectedItems: [ItemType] = []

    // This private getter ensures we use the internal selected items value, map it to our ItemType, and support multi/single selection
    private var __selectedItems: [ItemType] {
        return self.collectionView.indexPathsForSelectedItems?.compactMap({ ip in
            return self.dataSource.itemIdentifier(for: ip)
        }) ?? []
    }

    public let collectionView: UICollectionView

    public init(with collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        self.initializeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        self.collectionView = UICollectionView()
        super.init(coder: aDecoder)
        self.initializeViews()
    }

    public func initializeViews() {
        self.view.addSubview(self.collectionView)
        self.collectionView.delegate = self
    }

    public func collectionViewDataWasLoaded() {}

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.layoutCollectionView(self.collectionView)
    }

    /// Subclasses should override this function if they don't want the collection view to be full screen.
    public func layoutCollectionView(_ collectionView: UICollectionView) {
        self.collectionView.frame = self.view.bounds
    }

    @MainActor
    public func loadData() async {
        // Forces layoutCollectionView(_ collectionView: UICollectionView) to be called.
        // Weird stuff/crashes can happen if the data sources collection view has a zero frame
        
        self.collectionView.setNeedsLayout()
        self.collectionView.layoutIfNeeded()

        let dataDictionary = await self.retrieveDataForSnapshot()

        guard !Task.isCancelled else {
            return
        }

        let snapshot = self.getInitialSnapshot(with: dataDictionary)

        await self.dataSource.apply(snapshot)

        guard !Task.isCancelled else {
            return
        }

        self.collectionViewDataWasLoaded()
    }

    // Using a dictionary here allows for easily appending items to a section while still ensuring order.
    public func getInitialSnapshot(with dictionary: [SectionType : [ItemType]])
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

    /// Used to capture and store any data needed for the snapshot
    /// Dictionary must include all SectionType's in order to be properly displayed
    /// Empty array may be returned for sections that dont have items.
    public func retrieveDataForSnapshot() async -> [SectionType: [ItemType]] {
        fatalError("retrieveDataForSnapshot NOT IMPLEMENTED")
    }

    public func getAllSections() -> [SectionType] {
        fatalError("getAllSections NOT IMPLEMENTED")
    }

    //MARK: CollectionViewDelegate
    // Note that any delegate methods that need to be overriden, need to be included here or they will not be called in their subclasses

    // Simple way to handle selection
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewManagerCell {
            cell.update(isSelected: true)
        }

        self.selectedItems = __selectedItems
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewManagerCell {
            cell.update(isSelected: false)
        }

        self.selectedItems = __selectedItems
    }

    public func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {}
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {}
}
