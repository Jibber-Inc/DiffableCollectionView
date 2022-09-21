//
//
//
//  Created by Benji Dodgson on 9/21/22.
//

import Foundation
import UIKit

class ExampleCollectionView: UICollectionView {
    
    init() {
        super.init(frame: .zero, collectionViewLayout: ExampleCollectionViewLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
