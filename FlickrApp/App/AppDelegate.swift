//
//  AppDelegate.swift
//  FlickrApp
//
//  Created by BinaryBoy on 3/22/20.
//  Copyright © 2020 BinaryBoy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var shared: AppDelegate!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        AppDelegate.shared = self
        window = UIWindow(frame: UIScreen.main.bounds)
        EntryPoint().initSplashScreen(window: window!)

        return true
    }

}
