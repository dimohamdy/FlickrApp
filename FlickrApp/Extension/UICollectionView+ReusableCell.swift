//
//  UICollectionView+ReusableCell.swift
//  FlickrApp
//
//  Created by BinaryBoy on 4/22/20.
//  Copyright © 2019 BinaryBoy. All rights reserved.
//

import UIKit

extension UICollectionView {

    func dequeueReusableCell<T: CellReusable>(for indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T
    }
}
