//
//  File.swift
//  
//
//  Created by Benji Dodgson on 12/11/23.
//

import Foundation
import UIKit

struct DiffableCellRegistration<ViewModel: Hashable,
                                ContentConfig: DiffableContentConfiguration<ViewModel>,
                                Cell: DiffableCollectionViewCell<ContentConfig>> {
    
    let provider = UICollectionView.CellRegistration<Cell, ContentConfig.ViewModel> { (cell, _, configuration) in
        cell.viewModel = configuration
    }
}

struct FooterRegistration<Footer: UICollectionReusableView> {
    let provider = UICollectionView.SupplementaryRegistration<Footer>(elementKind: UICollectionView.elementKindSectionFooter) { _, _, _ in }
}

struct HeaderRegistration<Header: UICollectionReusableView> {
    let provider = UICollectionView.SupplementaryRegistration<Header>(elementKind: UICollectionView.elementKindSectionHeader) { _, _, _ in }
}

protocol ElementKind {
    var kind: String { get set }
}

struct SupplementaryViewRegistration<View: UICollectionReusableView & ElementKind> {
    let provider = UICollectionView.SupplementaryRegistration<View>(elementKind: View().kind) { _, _, _ in }
}
