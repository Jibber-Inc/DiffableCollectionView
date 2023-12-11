//
//
//
//  Created by Benji Dodgson on 9/21/22.
//

import Foundation
import UIKit
import Combine

class DiffableCollectionViewController<SectionType: Hashable,
                                       ConfigurationType: Hashable,
                                       DataSource: CollectionViewDataSource<SectionType, ConfigurationType>>:
                                        UIViewController, UICollectionViewDelegate {
    
    public lazy var dataSource = DataSource(collectionView: self.collectionView)

    @Published var selectedItems: [ConfigurationType] = []

    private var selectionImapact = UIImpactFeedbackGenerator(style: .light)

    private var __selectedItems: [ConfigurationType] {
        return self.collectionView.indexPathsForSelectedItems?.compactMap({ ip in
            return self.dataSource.itemIdentifier(for: ip)
        }) ?? []
    }
        
    var cancellables = Set<AnyCancellable>()

    let collectionView: UICollectionView

    init(with collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init(nibName: nil, bundle: nil)
        self.initializeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }

    func initializeViews() {
        self.view.addSubview(self.collectionView)
        self.collectionView.delegate = self
        
        self.dataSource.didApplyChanges = { [unowned self] in
            self.didApplyChanges()
        }
        
        self.dataSource.didApplySnapshot = { [unowned self] in
            self.didApplySnapshot()
        }
    }
    
    func didApplyChanges() {}
    func didApplySnapshot() {}
    
    func loadInitialData() {
        Task {
            await self.loadData()
        }
    }

    func collectionViewDataWasLoaded() {}

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.layoutCollectionView(self.collectionView)
    }

    /// Subclasses should override this function if they don't want the collection view to be full screen.
    func layoutCollectionView(_ collectionView: UICollectionView) {
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }

    @MainActor
    func loadData() async {
        self.collectionView.setNeedsLayout()
        self.collectionView.layoutIfNeeded()

        let dataDictionary = await self.retrieveDataForSnapshot()

        guard !Task.isCancelled else { return }

        let snapshot = self.getInitialSnapshot(with: dataDictionary)

        await self.dataSource.apply(snapshot)

        guard !Task.isCancelled else { return }

        self.collectionViewDataWasLoaded()
    }

    func getInitialSnapshot(with dictionary: [SectionType: [ConfigurationType]]) -> NSDiffableDataSourceSnapshot<SectionType, ConfigurationType> {
        
        var snapshot = self.dataSource.snapshot()
        snapshot.deleteAllItems()

        let allSections: [SectionType] = self.getAllSections()

        snapshot.appendSections(allSections)

        allSections.forEach { section in
            if let items = dictionary[section] {
                snapshot.appendItems(items, toSection: section)
            }
        }

        return snapshot
    }

    // MARK: Overrides

    /// Used to capture and store any data needed for the snapshot
    /// Dictionary must include all SectionType's in order to be properly displayed
    /// Empty array may be returned for sections that dont have items.
    func retrieveDataForSnapshot() async -> [SectionType: [ConfigurationType]] {
        fatalError("retrieveDataForSnapshot NOT IMPLEMENTED")
    }

    func getAllSections() -> [SectionType] {
        fatalError("getAllSections NOT IMPLEMENTED")
    }

    // MARK: CollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedItems = __selectedItems
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.selectionImapact.impactOccurred()
        self.selectedItems = __selectedItems
    }

    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {}
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {}
}
