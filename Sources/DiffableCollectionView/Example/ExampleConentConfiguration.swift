//
//  File.swift
//  
//
//  Created by Benji Dodgson on 12/11/23.
//

import Foundation

class ExampleContentView: DiffableCellContentView<ExampleViewModel> {
    
}

class ExampleContentConfiguration: DiffableContentConfiguration<ExampleViewModel> {
    
    override func initializeContentView() -> ExampleContentView {
        return ExampleContentView(configuration: self)
    }
}
