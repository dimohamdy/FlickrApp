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
    private var collectionView: UICollectionView = {
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
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.backgroundImage = UIImage()
        searchBar.barStyle = .black
        searchBar.barTintColor = .black
        searchBar.backgroundColor = .clear
        //        searchBar.textField?.textColor = theme.textColor
        //        searchBar.textField?.font = theme.taglineLabelFont(size: 17)
        //        searchBar.textField?.backgroundColor = UIColor(red: 142 / 255, green: 142 / 255, blue: 147 / 255, alpha: 0.12)
        searchBar.isTranslucent = true
        searchBar.placeholder = "search for photos ..."
        //        let attributes: [NSAttributedString.Key: Any] = [
        //            NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 0.985, blue: 0.118, alpha: 1),
        //            NSAttributedString.Key.font: UIFont.basierFont(ofSize: 13, weight: .regular)
        //        ]
        //        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    
    // MARK: Injections
    var presenter: PhotosListPresenterInput!
    
    
    // MARK: View lifeCycle
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .green
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        searchBar.delegate = self

    }
    
    
    // MARK: - Setup UI
    
    func setupUI() {
        [searchBar, collectionView].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.heightAnchor.constraint(lessThanOrEqualToConstant: 36),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text,!text.isEmpty{
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
        self.collectionView.isHidden = true
        self.collectionView.dataSource = nil
        self.collectionView.dataSource = nil
        self.collectionView.reloadData()
    }
    
    func defaultPlaceHolder() {
    }
}

// MARK: - PhotosListPresenterOutput
extension PhotosListViewController: PhotosListPresenterOutput {
    func updateData(itemsForCollection: [ItemCollectionViewCellType], rows: [IndexPath]?, reloadTable: Bool) {
            
            if collectionDataSource == nil {
                collectionDataSource = PhotosCollectionViewDataSource(presenterInput: presenter, itemsForCollection: itemsForCollection)
            } else {
                collectionDataSource.itemsForCollection = itemsForCollection
            }
            
            DispatchQueue.main.async {
                self.collectionView.dataSource = self.collectionDataSource
                self.collectionView.delegate = self.collectionDataSource
                
                guard let rows = rows, reloadTable == false else {
                    self.collectionView.reloadData()
                    return
                }
                
                self.collectionView.insertItems(at: rows)
                
            }
        
    }
    
    
}


