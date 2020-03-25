//
//  PhotosListConfigurator.swift
//  FlickrApp
//
//  Created by BinaryBoy on 3/22/20.
//  Copyright (c) 2020 BinaryBoy. All rights reserved.
//

import UIKit

protocol PhotosListConfigurable {
    func configure(viewController: PhotosListViewController)
}

class PhotosListConfigurator: PhotosListConfigurable {

    //MARK: PhotosListConfigurable
    func configure(viewController: PhotosListViewController) {
    
        let router = PhotosListRouter(viewController: viewController)
        
        let presenter = PhotosListPresenter(
            output: viewController,
            router: router
        )
        
        viewController.presenter = presenter

    }
}
