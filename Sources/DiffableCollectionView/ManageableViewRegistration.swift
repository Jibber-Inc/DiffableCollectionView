//
//      
//  
//
//  Created by Benji Dodgson on 9/21/22.
//

import Foundation
import UIKit

public struct ManageableCellRegistration<Cell: UICollectionViewCell & ManageableCell> {
    let provider = UICollectionView.CellRegistration<Cell, Cell.ItemType> { (cell, indexPath, model)  in
        cell.configure(with: model)
        cell.update(isSelected: cell.isSelected)
        cell.currentItem = model
    }
}

public protocol ElementKind {
    static var kind: String { get set }
}

public struct ManageableSupplementaryViewRegistration<View: UICollectionReusableView & ElementKind> {
    let provider = UICollectionView.SupplementaryRegistration<View>(elementKind: View.kind) { view, elementKind, indexPath in }
}
