//
//
//
//  Created by Benji Dodgson on 9/21/22.
//

import Foundation
import UIKit

struct ExampleViewModel: DiffableViewModel {
    var identifier: String
    var title: String
    var description: String
}

class ExampleDataSource: CollectionViewDataSource<ExampleDataSource.Section, ExampleDataSource.Model> {
    
    enum Section: Int, CaseIterable {
        case exampleSection
    }

    enum Model: Hashable {
        case example(ExampleViewModel)
    }
    
    private let cellConfig = DiffableCellRegistration<ExampleViewModel, ExampleContentConfiguration, DiffableCollectionViewCell>().provider
    
    // MARK: - Cell Dequeueing
    
    override func dequeueCell(with collectionView: UICollectionView, 
                              indexPath: IndexPath,
                              section: Section,
                              type: Model) -> UICollectionViewCell? {
        switch type {
        case .example(let exampleViewModel):
            return collectionView.dequeueConfiguredReusableCell(using: self.cellConfig, for: indexPath, item: exampleViewModel)
        }
    }
}
