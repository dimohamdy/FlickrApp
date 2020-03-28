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
    func loadMoreData(_ page: Int)
    func getSearchHistory()

}

protocol PhotosListPresenterOutput: BasePresenterOutput {
    func updateData(itemsForCollection: [ItemCollectionViewCellType?], rows: [IndexPath]?, reloadCollection: Bool)
    func beginSearching(for term: String)
}

class PhotosListPresenter {
    
    // MARK: Injections
    private weak var output: PhotosListPresenterOutput?
    var router: PhotosListRoutable
    lazy var photosRepository: WebPhotosRepository = WebPhotosRepository()
    var query: String!
    
    fileprivate var page: Int = 1
    fileprivate var canLoadMore = true
    // internal
    var itemsForCollection: [ItemCollectionViewCellType?] = [ItemCollectionViewCellType?]()
    
    // MARK: LifeCycle 
    init(output: PhotosListPresenterOutput,
         router: PhotosListRoutable) {
        
        self.output = output
        self.router = router
    }
    
}

// MARK: - PhotosListPresenterInput
extension PhotosListPresenter: PhotosListPresenterInput {

    func search(for text: String) {
        let userDefaultSearchHistoryRepository = UserDefaultSearchHistoryRepository()
        userDefaultSearchHistoryRepository.saveSearchKeyword(searchKeyword: text)
        getData(for: text)
        output?.beginSearching(for: text)
    }
    
    func loadMoreData(_ page: Int) {
        if self.page <= page && canLoadMore == true {
            print("🚀 Page number \(page)")
            getData(for: self.query)
        }
    }
    
    func getSearchHistory() {
        let userDefaultSearchHistoryRepository = UserDefaultSearchHistoryRepository()
        let searchTerms = userDefaultSearchHistoryRepository.getSearchHistory
        let itemsForCollection = createItemsForCollection(searchTerms: searchTerms())
        output?.updateData(itemsForCollection: itemsForCollection, rows: nil, reloadCollection: true)

    }
}

// MARK: Setup

extension PhotosListPresenter {
    
    private func getData(for query: String) {
        self.query = query
        
        guard Reachability.isConnectedToNetwork() else {
            self.itemsForCollection = [.error(message: FlickrAppError.noInternetConnection.localizedDescription)]
            self.output?.updateData(itemsForCollection: itemsForCollection, rows: nil, reloadCollection: true)
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
                    self.output?.updateData(itemsForCollection: self.itemsForCollection, rows: nil, reloadCollection: true)
                }
            }
        }
    }
    
    private func handleNewPhotos(photos: Photos) {
        let photosArray = photos.photos
        let nextPage = Int(photos.page) + 1
        self.page = nextPage
        
        var reloadCollection: Bool = false
        if itemsForCollection.isEmpty {
            reloadCollection = true
        }
        
        let newItems: [ItemCollectionViewCellType?] = createItemsForCollection(photosArray: photosArray)
        if (itemsForCollection.count / 10) > 1 {
            itemsForCollection.removeLast(10)
        }
        let indexes = indexesForNewPhotos(from: itemsForCollection.count, to: itemsForCollection.count + newItems.count)
        itemsForCollection.append(contentsOf: newItems)
        output?.updateData(itemsForCollection: itemsForCollection, rows: indexes, reloadCollection: reloadCollection)
    }
    
    private func handleNoPhotos() {
        
        if  itemsForCollection.isEmpty {
            itemsForCollection.append(.empty)
            output?.updateData(itemsForCollection: itemsForCollection, rows: nil, reloadCollection: true)
        }
    }
    
    private func indexesForNewPhotos(from: Int, to: Int) -> [IndexPath] {
        
        let indexesArray = (from ..< to).map { index -> IndexPath in
            return IndexPath(row: index, section: 0)
        }
        
        return indexesArray
    }
    
    private func createItemsForCollection(photosArray: [Photo]) -> [ItemCollectionViewCellType?] {
        var itemsForCollection: [ItemCollectionViewCellType] = []
        
        for photo in photosArray {
            itemsForCollection.append(.cellItem(photo: photo))
        }
        
        return itemsForCollection + [ItemCollectionViewCellType?](repeating: nil, count: 10)
    }
    
    private func createItemsForCollection(searchTerms: [String]) -> [ItemCollectionViewCellType?] {
        var itemsForCollection: [ItemCollectionViewCellType] = []
        
        for searchTerm in searchTerms {
            itemsForCollection.append(.search(term: searchTerm))
        }
        
        return itemsForCollection
    }
}
