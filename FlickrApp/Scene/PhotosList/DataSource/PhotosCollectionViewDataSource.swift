//
//  PhotosCollectionViewDataSource.swift
//  FlickrApp
//
//  Created by BinaryBoy on 3/23/20.
//  Copyright © 2020 BinaryBoy. All rights reserved.
//

import UIKit

class PhotosCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var itemsForCollection: [ItemCollectionViewCellType?] = []
    
    weak var presenterInput: PhotosListPresenterInput!
    
    private struct CellHeightConstant {
        static let heightOfPhotoCell: CGFloat = 120
        static let heightOfSearchTermCell: CGFloat = 50
        static let heightOfHistoryHeader: CGFloat = 120
    }
    
    init(presenterInput: PhotosListPresenterInput, itemsForCollection: [ItemCollectionViewCellType?]) {
        self.itemsForCollection = itemsForCollection
        self.presenterInput = presenterInput
    }
    
    // MARK: - Collection view data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !itemsForCollection.isEmpty else {
            return 1
        }
        return itemsForCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let item = itemsForCollection[indexPath.row] {
            switch item {
            case .cellItem(let photo):
                if let cell: PhotoCollectionCell = collectionView.dequeueReusableCell(for: indexPath) {
                    cell.configCell(photo: photo)
                    return cell
                }
                return UICollectionViewCell()
            case .error(let message):
                if let cell: EmptyCollectionCell = collectionView.dequeueReusableCell(for: indexPath) {
                    cell.configCell(message: message)
                    return cell
                }
                return UICollectionViewCell()
            case .empty:
                if let cell: EmptyCollectionCell = collectionView.dequeueReusableCell(for: indexPath) {
                    cell.configCell(message: "No ")
                    return cell
                }
                return UICollectionViewCell()
            case .search(let term):
                if let cell: SearchHistoryCollectionCell = collectionView.dequeueReusableCell(for: indexPath) {
                    cell.configCell(searchTerm: term)
                    return cell
                }
                return UICollectionViewCell()
            }
        } else {
            if let cell: PhotoCollectionCell = collectionView.dequeueReusableCell(for: indexPath) {
                cell.configCell(photo: nil)
                return cell
            }
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let item = itemsForCollection[indexPath.row] {
            switch item {
            case .cellItem:
                return getPhotoCellSize(collectionView: collectionView)
            case .error, .empty:
                return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
            case .search:
                return CGSize(width: collectionView.bounds.width, height: CellHeightConstant.heightOfSearchTermCell)
            }
        } else {
            return getPhotoCellSize(collectionView: collectionView)
        }
    }
    
    private func getPhotoCellSize(collectionView: UICollectionView) -> CGSize {
        let widthAndHeight = collectionView.bounds.width / 2.1
        return CGSize(width: widthAndHeight, height: widthAndHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = itemsForCollection[indexPath.row] {
            switch item {
            case .search(let term):
                presenterInput.search(for: term)
            default:
                break
            }
        }
    }
    
}

extension PhotosCollectionViewDataSource: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            requestData(forIndex: indexPath)
        }
    }
    
    func requestData(forIndex: IndexPath) {
        
        if itemsForCollection[forIndex.row] != nil {
            return
        }
        let pageToGet = Int(forIndex.row / Constant.pageSize) + 1
        presenterInput.loadMoreData(pageToGet)
        
    }
    
}
