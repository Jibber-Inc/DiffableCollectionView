//
//
//  
//
//  Created by Benji Dodgson on 9/21/22.
//

import Foundation
import Combine
import UIKit

/// A base class that other cells managed by a CollectionViewManager can inherit from.
public class CollectionViewManagerCell: UICollectionViewListCell {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeSubviews()
    }

    public func initializeSubviews() {}

    public func update(isSelected: Bool) {
        guard isSelected != self.isSelected else { return }
    }

    public override func updateConfiguration(using state: UICellConfigurationState) {
        // Get the system default background configuration for a plain style list cell in the current state.
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell().updated(for: state)

        // Customize the background color to be clear, no matter the state.
        backgroundConfig.backgroundColor = .clear
        
        // Apply the background configuration to the cell.
        self.backgroundConfiguration = backgroundConfig
    }
}
