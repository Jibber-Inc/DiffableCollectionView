//
//
//
//  Created by Benji Dodgson on 9/21/22.
//

import Foundation
import UIKit

struct ExampleViewModel: Hashable {
    var title: String
    var description: String
}

class ExampleCell: CollectionViewManagerCell, ManageableCell {

    typealias ItemType = ExampleViewModel
    var currentItem: ExampleViewModel?
    
    func configure(with item: ExampleViewModel) {
        
    }
}
