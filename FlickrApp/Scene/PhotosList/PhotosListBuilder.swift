//
//  PhotosListBuilder.swift
//  FlickrApp
//
//  Created by BinaryBoy on 3/22/20.
//  Copyright (c) 2020 BinaryBoy. All rights reserved.
//

import UIKit

struct PhotosListBuilder {
    
    static func viewController() -> PhotosListViewController {
        
        let viewController: PhotosListViewController = PhotosListViewController()
        let configurator = PhotosListConfigurator()
        configurator.configure(viewController: viewController)

        return viewController
    }
}
