//
//  PhotosListPresenter.swift
//  FlickrApp
//
//  Created by BinaryBoy on 3/22/20.
//  Copyright (c) 2020 BinaryBoy. All rights reserved.
//

import Foundation

protocol PhotosListPresenterInput: BasePresenterInput {
    var router: PhotosListRoutable { get }
    func search(for text: String)
    func loadMoreData(_ index: IndexPath)
}

protocol PhotosListPresenterOutput: BasePresenterOutput {
    func updateData(itemsForCollection: [ItemCollectionViewCellType], rows: [IndexPath]?, reloadTable: Bool)
}

class PhotosListPresenter {
    
    //MARK: Injections
    private weak var output: PhotosListPresenterOutput?
    var router: PhotosListRoutable
    lazy var photosRepository: WebPhotosRepository = WebPhotosRepository()
    var query: String!
    
    fileprivate var page: Int = 1
    fileprivate var canLoadMore = true
    // internal
    var itemsForCollection: [ItemCollectionViewCellType] = [ItemCollectionViewCellType]()
    
    
    //MARK: LifeCycle 
    init(output: PhotosListPresenterOutput,
         router: PhotosListRoutable) {
        
        self.output = output
        self.router = router
    }
    
}

// MARK: - PhotosListPresenterInput
extension PhotosListPresenter: PhotosListPresenterInput {
    func search(for text: String) {
        getData(for: text)
    }
    
    
    func viewDidLoad() {
        
    }
    
    func loadMoreData(_ index: IndexPath) {
        if canLoadMore == true {
            getData(for: self.query)
        }
        
    }
    
}


// MARK: Setup

extension PhotosListPresenter {
    
    private func getData(for query: String) {
        self.query = query
        
        guard (photosRepository is WebPhotosRepository && Reachability.isConnectedToNetwork() == true) else {
            self.itemsForCollection = [.error(message: FlickrAppError.noInternetConnection.localizedDescription)]
            self.output?.updateData(itemsForCollection: itemsForCollection, rows: nil, reloadTable: true)
            return
        }
        output?.showLoading()
        canLoadMore = false
        
        photosRepository.photos(for: query, page: page) { [weak self] result in
            
            guard let self =  self else {
                return
            }
            DispatchQueue.main.async {
                self.output?.hideLoading()
                self.canLoadMore = true
                
                switch result {
                case .success(let searchResult):
                    
                    guard let photos = searchResult.photos  else {
                        self.handleNoPhotos()
                        return
                    }
                    self.handleNewPhotos(photos: photos)
                    
                case .failure(let error):
                    self.itemsForCollection = [.error(message: error.localizedDescription)]
                    self.output?.updateData(itemsForCollection: self.itemsForCollection, rows: nil, reloadTable: true)
                }
            }
        }
    }
    
    private func handleNewPhotos(photos: Photos) {
        let photosArray = photos.photos
        let nextPage = Int(photos.page) + 1
        self.page = nextPage
        
        //reload table prevent me to reload all table when each page I use insertRows Insted
        var reloadTable: Bool = false
        if itemsForCollection.isEmpty {
            reloadTable = true
        }
        
        
        let newItems: [ItemCollectionViewCellType] = createItemsForTable(photosArray: photosArray)
        let indexes = indexesForNewPhotos(from: itemsForCollection.count, to: itemsForCollection.count + newItems.count)
        
        itemsForCollection.append(contentsOf: newItems)
        
        output?.updateData(itemsForCollection: itemsForCollection, rows: indexes, reloadTable: reloadTable)
    }
    
    private func handleNoPhotos() {
        
        if  itemsForCollection.isEmpty {
            itemsForCollection.append(.empty)
            output?.updateData(itemsForCollection: itemsForCollection, rows: nil, reloadTable: true)
        }
    }
    
    private func indexesForNewPhotos(from: Int, to: Int) -> [IndexPath] {
        
        let indexesArray = (from ..< to).map { index -> IndexPath in
            return IndexPath(row: index, section: 0)
        }
        
        return indexesArray
    }
    
    private func createItemsForTable(photosArray: [Photo]) -> [ItemCollectionViewCellType] {
        var itemsForCollection: [ItemCollectionViewCellType] = []
        
        for photo in photosArray {
            itemsForCollection.append(.cellItem(photo: photo))
        }
        
        return itemsForCollection
    }
}
