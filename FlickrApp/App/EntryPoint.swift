//
//  EntryPoint.swift
//  FlickrApp
//
//  Created by BinaryBoy on 3/22/20.
//  Copyright © 2020 BinaryBoy. All rights reserved.
//

import UIKit

struct EntryPoint {
    
    func initSplashScreen(window: UIWindow) {
        window.rootViewController = UINavigationController(rootViewController: PhotosListBuilder.viewController())
        window.makeKeyAndVisible()
    }
    
}
