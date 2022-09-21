//
//  
//
//  Created by Benji Dodgson on 9/21/22.
//

import Foundation

extension Array {

    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
