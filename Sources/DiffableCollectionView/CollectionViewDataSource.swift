//
//  
//
//  Created by Benji Dodgson on 9/21/22.
//

import Foundation
import UIKit

public class DiffableDataSource<SectionType: Hashable, ItemType: Hashable>: UICollectionViewDiffableDataSource<SectionType, ItemType> {}

/// A base class for types that can act as a data source for a UICollectionview.
/// Subclasses should override functions related to dequeuing cells and supplementary views.
/// This class works the same as UICollectionViewDiffableDataSource but it allows you to subclass it more easily and hold additional state.
public class CollectionViewDataSource<SectionType: Hashable, ItemType: Hashable> {
    
    public typealias SnapshotType = NSDiffableDataSourceSnapshot<SectionType, ItemType>
    
    public var diffableDataSource: DiffableDataSource<SectionType, ItemType>!
        
    required init(collectionView: UICollectionView) {
        self.diffableDataSource = DiffableDataSource<SectionType, ItemType>(collectionView: collectionView,
                                                                            cellProvider: {
            [unowned self] (collectionView, indexPath, itemIdentifier) in
            guard let section = self.sectionIdentifier(for: indexPath.section) else { return nil }
            
            return self.dequeueCell(with: collectionView,
                                    indexPath: indexPath,
                                    section: section,
                                    item: itemIdentifier)
        })
                
        self.diffableDataSource.supplementaryViewProvider = {
            [unowned self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let section = self.sectionIdentifier(for: indexPath.section) else { return nil }
            
            return self.dequeueSupplementaryView(with: collectionView,
                                                 kind: kind,
                                                 section: section,
                                                 indexPath: indexPath)
        }
    }
    
    /// Returns a configured UICollectionViewCell dequeued from the passed in collection view.
    public func dequeueCell(with collectionView: UICollectionView,
                     indexPath: IndexPath,
                     section: SectionType,
                     item: ItemType) -> UICollectionViewCell? {
        fatalError()
    }
    
    /// Returns a configured supplemental view dequeued from the passed in collection view.
    public func dequeueSupplementaryView(with collectionView: UICollectionView,
                                  kind: String,
                                  section: SectionType,
                                  indexPath: IndexPath) -> UICollectionReusableView? {
        return nil
    }
}
