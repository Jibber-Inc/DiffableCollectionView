//
//
//
//  Created by Benji Dodgson on 9/21/22.
//

import Foundation
import UIKit

class ExampleDataSource: CollectionViewDataSource<ExampleDataSource.SectionType, ExampleDataSource.ItemType> {
    
    enum SectionType: Int, CaseIterable {
        case exampleSection
    }

    enum ItemType: Hashable {
        case example(ExampleViewModel)
    }
    
    private let cellConfig = ManageableCellRegistration<ExampleCell>().provider
    
    // MARK: - Cell Dequeueing

    override func dequeueCell(with collectionView: UICollectionView,
                              indexPath: IndexPath,
                              section: SectionType,
                              item: ItemType) -> UICollectionViewCell? {

        switch item {
        case .example(let item):
            return collectionView.dequeueConfiguredReusableCell(using: self.cellConfig,
                                                                for: indexPath,
                                                                item: item)
        }
    }
}
