//
//  PhotosListViewController.swift
//  FlickrApp
//
//  Created by BinaryBoy on 3/22/20.
//  Copyright (c) 2020 BinaryBoy. All rights reserved.
//

import UIKit

class PhotosListViewController: UIViewController {
    var collectionDataSource: PhotosCollectionViewDataSource!
    
    // MARK: Outlets
    private let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 90, height: 90)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: PhotoCollectionCell.identifier)
        collectionView.register(EmptyCollectionCell.self, forCellWithReuseIdentifier: EmptyCollectionCell.identifier)
        collectionView.register(SearchHistoryCollectionCell.self, forCellWithReuseIdentifier: SearchHistoryCollectionCell.identifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.backgroundImage = UIImage()
        searchBar.barStyle = .black
        searchBar.barTintColor = .black
        searchBar.isTranslucent = true
        searchBar.placeholder = "search for photos ..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    // MARK: Injections
    var presenter: PhotosListPresenterInput!
    
    // MARK: View lifeCycle
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        defaultPlaceHolder()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        [searchBar, photosCollectionView].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.heightAnchor.constraint(lessThanOrEqualToConstant: 36),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
 
}

// MARK: UISearch Delegates

extension PhotosListViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearCollection()
        searchBar.text = nil
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        clearCollection()
        defaultPlaceHolder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text, !text.isEmpty, text.count >= 3 {
            presenter.search(for: text)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            clearCollection()
            defaultPlaceHolder()
        }
    }
    
    func clearCollection() {
        photosCollectionView.isHidden = true
        photosCollectionView.dataSource = nil
        photosCollectionView.dataSource = nil
        photosCollectionView.reloadData()
    }
    
    func defaultPlaceHolder() {
        presenter.getSearchHistory()
    }
}

// MARK: - PhotosListPresenterOutput
extension PhotosListViewController: PhotosListPresenterOutput {
    func updateData(itemsForCollection: [ItemCollectionViewCellType?], rows: [IndexPath]?, reloadCollection: Bool) {
        guard !itemsForCollection.isEmpty else {
            return
        }
        
        if collectionDataSource == nil {
            collectionDataSource = PhotosCollectionViewDataSource(presenterInput: presenter, itemsForCollection: itemsForCollection)
        } else {
            collectionDataSource.itemsForCollection = itemsForCollection
        }
        
        DispatchQueue.main.async {
            self.photosCollectionView.isHidden = false
            self.photosCollectionView.dataSource = self.collectionDataSource
            self.photosCollectionView.delegate = self.collectionDataSource
            self.photosCollectionView.prefetchDataSource = self.collectionDataSource
            
            guard let rows = rows, reloadCollection == false else {
                self.photosCollectionView.reloadData()
                return
            }
            //avoid reload CollectionView only reload changed cells

            let  insertedIndexes = Array(rows.dropFirst(Constant.pageSize))
            let  reloadIndexes = Array(rows.dropLast(Constant.pageSize))

            self.photosCollectionView.performBatchUpdates({
                self.photosCollectionView.reloadItems(at: reloadIndexes)
                self.photosCollectionView.insertItems(at: insertedIndexes)
            }, completion: nil)

        }
        
    }
    
    func beginSearching(for term: String) {
        searchBar.text = term
    }
}
