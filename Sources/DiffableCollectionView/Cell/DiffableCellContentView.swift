//
//  File.swift
//  
//
//  Created by Benji Dodgson on 12/11/23.
//

import Foundation
import UIKit

class DiffableCellContentView<ViewModel: Hashable>: UIView, UIContentView {
    
    typealias ConfigurationType = DiffableContentConfiguration<ViewModel>
    
    var viewModel: ConfigurationType.ViewModel? {
        return self.diffableConfiguration?.viewModel
    }
    
    var diffableConfiguration: ConfigurationType? {
        return self.configuration as? ConfigurationType
    }

    var configuration: UIContentConfiguration {
        didSet {
            guard let new = self.configuration as? ConfigurationType else { return }
            self.apply(configuration: new)
        }
    }
    
    required init(configuration: ConfigurationType) {
        self.configuration = configuration
        super.init(frame: .zero)
        self.initializeViews()
        self.apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
        
    private func apply(configuration: ConfigurationType) {
        self.updateLayout(with: configuration.viewModel)
    }
    
    // Overrides
    
    // Used to setup or add any UI elements to the view
    func initializeViews() {}
    
    // Update the UI based on a new item
    @MainActor
    func updateLayout(with model: ViewModel?) {}
}

class EmptyDiffableContent: DiffableCellContentView<UUID> {}

class EmptyDiffableContentConfiguration: DiffableContentConfiguration<UUID> {
    
    override func initializeContentView() -> DiffableCellContentView<UUID> {
        return EmptyDiffableContent(configuration: self)
    }
}
