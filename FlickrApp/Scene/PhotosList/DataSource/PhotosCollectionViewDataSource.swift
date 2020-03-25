//
//  PhotosCollectionViewDataSource.swift
//  FlickrApp
//
//  Created by BinaryBoy on 3/23/20.
//  Copyright © 2020 BinaryBoy. All rights reserved.
//

import UIKit

class PhotosCollectionViewDataSource: NSObject,  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    var itemsForCollection: [ItemCollectionViewCellType?] = [ItemCollectionViewCellType?](repeating: nil, count: 10)

    weak var presenterInput: PhotosListPresenterInput!
    
    struct Constant {
        static let heightOfPhotoCell: CGFloat = 120
        static let heightOfHeaderCell: CGFloat = 100
        static let heightOfSkeltonCell: CGFloat = 120
        
    }
    
    init(presenterInput: PhotosListPresenterInput, itemsForCollection: [ItemCollectionViewCellType]) {
        self.itemsForCollection = itemsForCollection
        self.presenterInput = presenterInput
    }
    
    // MARK: - Table view data source
    
    
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
        let item = itemsForCollection[indexPath.row]
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
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard !itemsForCollection.isEmpty else {
            return Constant.heightOfSkeltonCell
        }
        let item = itemsForCollection[indexPath.row]
        switch item {
        case .cellItem:
            return Constant.heightOfPhotoCell
        case .error, .empty:
            return tableView.frame.size.height
            
        }
        
    }
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//            presenterInput.loadMoreData(indexPath)
//        
//    }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let widthAndHeight = collectionView.bounds.width / 2.1
            return CGSize(width: widthAndHeight, height: widthAndHeight)
        }

}



extension PhotosCollectionViewDataSource: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths{
            requestImage(forIndex: indexPath)
        }
        requestImage(forIndex: <#T##IndexPath#>)
    }
    
    
    func requestImage(forIndex: IndexPath) {
        
        if itemsForCollection[forIndex.row] != nil {
            return
        }
       let pageToGet = forIndex.row % 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }

}
