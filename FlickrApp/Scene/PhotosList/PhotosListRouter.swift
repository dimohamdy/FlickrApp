//
//  PhotosListRouter.swift
//  FlickrApp
//
//  Created by BinaryBoy on 3/22/20.
//  Copyright (c) 2020 BinaryBoy. All rights reserved.
//

import UIKit

protocol PhotosListRoutable: ViewRoutable {
    
}

class PhotosListRouter {
    
    // MARK: Injections
    weak var viewController: UIViewController?
    
    // MARK: LifeCycle
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
}

// MARK: - PhotosListRoutable
extension PhotosListRouter: PhotosListRoutable {
    
}
