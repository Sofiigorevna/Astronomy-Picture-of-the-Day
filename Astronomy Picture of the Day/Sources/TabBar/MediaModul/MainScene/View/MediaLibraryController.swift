//
//  MediaLibraryController.swift
//  Astronomy Picture of the Day
//
//  Created by 1234 on 05.02.2024.
//

import UIKit
protocol MainViewProtocol: AnyObject {
    func succes()
}

class MediaLibraryController: UIViewController {
    var mainPresenter: MainPresenterType?
    
    private let dependencyFactory = DependencyFactory.shared

    // MARK: - Outlets
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PictureCell.self,
                                forCellWithReuseIdentifier: PictureCell.identifier)
        collectionView.register(CustomHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomHeader.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //  MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupHierarhy()
        setupLayout()
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        mainPresenter?.fetchAll()
        succes()
    }
    
    private func setupNavBar() {
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        backButton.tintColor = .systemBackground
        self.navigationItem.backBarButtonItem = backButton
    
        title = "Astronomy Picture of the Day"
    }
    
    private func setupHierarhy() {
        view.addSubview(collectionView)
    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            let spacing: CGFloat = 10
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(
                layoutSize: itemSize
            )
            item.contentInsets = .init(
                top: 4, leading: 4, bottom: 4, trailing: 4
            )

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(160)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            let layoutSection = NSCollectionLayoutSection(group: group)
            
            layoutSection.contentInsets = .init(
                top: spacing,
                leading: spacing,
                bottom: spacing,
                trailing: spacing)
            
            layoutSection.interGroupSpacing = spacing
            
            layoutSection.orthogonalScrollingBehavior = .none
            
            // Header
            let layoutSectionHeaderSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1.0/2.1)
            )
            let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: layoutSectionHeaderSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            layoutSectionHeader.contentInsets = .init(
                top: 0, leading: 4, bottom: 0, trailing: 4
            )
            
            layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
            
            return layoutSection
            
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MediaLibraryController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let lastSection = collectionView.numberOfSections - 1
        
        let lastItem = collectionView.numberOfItems(inSection: lastSection) - 15
        
        if indexPath == IndexPath (row: lastItem, section: lastSection) {
            mainPresenter?.prepareNewData()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MediaLibraryController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return mainPresenter?.pictures.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PictureCell.identifier,
            for: indexPath) as? PictureCell
        
        if let data = mainPresenter?.pictures[indexPath.row] {
            cell?.configuration(model: data)
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CustomHeader.identifier,
            for: indexPath) as! CustomHeader
        
        if let data = mainPresenter?.pictureToDay.first {
            header.configuration(model: data)
        }
        
        header.onComletion = { [weak self] in
            guard let self else {
                return
            }
            if let data = self.mainPresenter?.pictureToDay.first {

                let detailVc = self.dependencyFactory.makeDetaillViewController(data: data)
                self.navigationController?.pushViewController(detailVc, animated: true)
            }
        }
        
        return header
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let data = mainPresenter?.pictures[indexPath.row] {
            let detailVc = self.dependencyFactory.makeDetaillViewController(data: data)
            navigationController?.pushViewController(detailVc, animated: true)
        }
    }
}


extension MediaLibraryController: MainViewProtocol {
    func succes(){
        self.collectionView.reloadData()
    }
}

