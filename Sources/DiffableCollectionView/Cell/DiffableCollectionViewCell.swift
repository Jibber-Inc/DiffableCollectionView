//
//  File.swift
//  
//
//  Created by Benji Dodgson on 12/11/23.
//

import Foundation
import UIKit

class DiffableCollectionViewCell<ContentConfig: DiffableConfiguration>: UICollectionViewListCell {
    
    var viewModel: ContentConfig.ViewModel? {
        didSet {
            self.setNeedsUpdateConfiguration()
        }
    }
    
    private let selectionImpact = UIImpactFeedbackGenerator()
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        // Get the system default background configuration for a plain style list cell in the current state.
        var backgroundConfig = self.initializeBackgroundConfiguration().updated(for: state)

        // Customize the background color to be clear, no matter the state.
        backgroundConfig.backgroundColor = UIColor.clear
        
        if state.isHighlighted || state.isSelected {
            // Set nil to use the inherited tint color of the cell when highlighted or selected
           // backgroundConfig.backgroundColor = nil
            
            if state.isHighlighted {
                // Reduce the alpha of the tint color to 30% when highlighted
                backgroundConfig.backgroundColorTransformer = .init { $0.withAlphaComponent(0.3) }
            }
        }
        
        // Apply the background configuration to the cell.
        self.backgroundConfiguration = backgroundConfig
                
        // Set content configuration in order to update custom content view
        self.contentConfiguration = self.initializeContentConfiguration().updated(for: state)
    }
    
    // MARK: OVERRIDES
    
    func initializeContentConfiguration() -> ContentConfig {
        return ContentConfig(viewModel: self.viewModel)
    }
    
    func initializeBackgroundConfiguration() -> UIBackgroundConfiguration {
        return .listPlainCell()
    }
}
