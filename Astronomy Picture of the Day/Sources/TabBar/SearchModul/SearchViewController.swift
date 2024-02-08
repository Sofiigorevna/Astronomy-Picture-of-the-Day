//
//  SearchViewController.swift
//  Astronomy Picture of the Day
//
//  Created by 1234 on 05.02.2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    var presenter: SearchPresenter?
    private let dependencyFactory = DependencyFactory.shared
    var filtered = [PictureData]()
    
    // MARK: - Outlets
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PictureCell.self,
                                forCellWithReuseIdentifier: PictureCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var searchController: UISearchController = {
        var search = UISearchController(searchResultsController: nil)
        return search
    }()
    
    //  MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupHierarhy()
        setupLayout()
        setupView()
        setupSearchController()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        presenter?.fetchAll()
        
        let pictures = presenter?.pictures
        guard let data = pictures else {
            return
        }
        filtered = data
        
        succes()
    }
    
    private func setupSearchController() {
        navigationController?.navigationBar.tintColor = .systemGray3
        
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupNavBar() {
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        backButton.tintColor = .systemBackground
        self.navigationItem.backBarButtonItem = backButton
        
        navigationItem.title = "Astronomy Picture of the Day"
    }
    
    private func setupHierarhy() {
        view.addSubview(collectionView)
    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(
            top: 4, leading: 4, bottom: 4, trailing: 4
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(144))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let lastSection = collectionView.numberOfSections - 1
        
        let lastItem = collectionView.numberOfItems(inSection: lastSection) - 15
        
        if indexPath == IndexPath (row: lastItem, section: lastSection) {
            presenter?.prepareNewData()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return filtered.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PictureCell.identifier,
            for: indexPath) as? PictureCell
        
        cell?.configuration(model: filtered[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(at: indexPath, animated: true)
            let detailVc = self.dependencyFactory.makeDetaillViewController(data: filtered[indexPath.row])
            navigationController?.pushViewController(detailVc, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        smSearch(
            text: searchText,
            action: #selector(goSearch(with:)),
            afterDelay: 0.9
        )
    }
    
    @objc func goSearch(with text: String) {
        let pictures = presenter?.pictures
        
        guard let data = pictures else {
            return
        }
        filtered = data
        
        if  !text.isEmpty {
            filtered = data.filter {
                $0.title.lowercased().contains(text.lowercased()) }
        } else {
            filtered = data
        }
        collectionView.reloadData()
    }
}

extension SearchViewController: MainViewProtocol {
    func succes(){
        self.collectionView.reloadData()
    }
}

