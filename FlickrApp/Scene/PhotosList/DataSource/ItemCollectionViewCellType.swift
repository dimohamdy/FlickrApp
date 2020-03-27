//
//  ItemCollectionViewCellType.swift
//  FlickrApp
//
//  Created by BinaryBoy on 3/22/20.
//  Copyright © 2020 BinaryBoy. All rights reserved.
//

import Foundation

enum ItemCollectionViewCellType {
    case cellItem(photo: Photo)
    case search(term: String)
    case error(message: String)
    case empty
    
}
