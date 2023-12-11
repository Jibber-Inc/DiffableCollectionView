//
//      
//  
//
//  Created by Benji Dodgson on 9/21/22.
//

import Foundation

// This is the simplest example of a view controller conneting the data source to a collection view
class ExampleViewController: DiffableCollectionViewController<ExampleDataSource.Section,
                                                                ExampleDataSource.Model,
                                                                ExampleDataSource> {
    
    init() {
        super.init(with: ExampleCollectionView())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            // Call loadData whenever you want
            await self.loadData()
        }
    }
    
    // These two overrides are the only 2 required functions 
    override func getAllSections() -> [ExampleDataSource.Section] {
        return ExampleDataSource.Section.allCases
    }
    
    override func retrieveDataForSnapshot() async -> [ExampleDataSource.Section : [ExampleDataSource.Model]] {
        
        var data: [ExampleDataSource.Section : [ExampleDataSource.Model]] = [:]
        
        let item1 = ExampleViewModel(identifier: UUID().uuidString, title: "Foo1", description: "Description1")
        let item2 = ExampleViewModel(identifier: UUID().uuidString, title: "Foo2", description: "Description2")
        let item3 = ExampleViewModel(identifier: UUID().uuidString, title: "Foo3", description: "Description3")
        let item4 = ExampleViewModel(identifier: UUID().uuidString, title: "Foo4", description: "Description4")
        let item5 = ExampleViewModel(identifier: UUID().uuidString, title: "Foo5", description: "Description5")
        let item6 = ExampleViewModel(identifier: UUID().uuidString, title: "Foo6", description: "Description6")

        data[.exampleSection] = [.example(item1),
                                 .example(item2),
                                 .example(item3),
                                 .example(item4),
                                 .example(item5),
                                 .example(item6)]
        return data
    }
}
