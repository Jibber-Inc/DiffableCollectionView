//
//  File.swift
//  
//
//  Created by Benji Dodgson on 12/11/23.
//

import Foundation
import UIKit

class DiffableContentConfiguration<ViewModel: Hashable>: DiffableConfiguration {
    
    typealias ViewModel = ViewModel
    typealias ContentViewType = DiffableCellContentView<ViewModel>
    
    var viewModel: ViewModel?
    
    required init(viewModel: ViewModel?) {
        self.viewModel = viewModel
    }
    
    func initializeContentView() -> ContentViewType {
        fatalError("Must override initializeContentView()")
    }
}
