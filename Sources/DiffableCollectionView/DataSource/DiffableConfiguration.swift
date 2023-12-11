//
//  File.swift
//  
//
//  Created by Benji Dodgson on 12/11/23.
//

import Foundation
import UIKit

protocol DiffableConfiguration: UIContentConfiguration {
    
    associatedtype ViewModel: Hashable
    associatedtype ContentViewType: DiffableCellContentView<ViewModel>
    
    var viewModel: Self.ViewModel? { get set }
    
    init(viewModel: Self.ViewModel?)
    func initializeContentView() -> ContentViewType
}

extension DiffableConfiguration {
    
    func makeContentView() -> UIView & UIContentView {
        return self.initializeContentView()
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}
