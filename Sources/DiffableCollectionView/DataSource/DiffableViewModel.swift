//
//  File.swift
//  
//
//  Created by Benji Dodgson on 12/11/23.
//

import Foundation

protocol DiffableViewModel: Hashable {
    var identifier: String { get set }
}

extension DiffableViewModel {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
