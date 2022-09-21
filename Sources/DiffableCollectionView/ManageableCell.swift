//
//      
//  
//
//  Created by Benji Dodgson on 9/21/22.
//

import Foundation

public protocol ManageableCell: AnyObject {
    /// The type that will be used to configure this object.
    associatedtype ItemType: Hashable

    /// Conforming types should take in the item type and set up the cell's visual state.
    func configure(with item: ItemType)

    /// Called with a managing objects selectedIndexPaths is set
    func update(isSelected: Bool)

    var currentItem: Self.ItemType? { get set }
}
