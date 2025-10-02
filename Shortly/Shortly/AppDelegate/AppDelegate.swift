//
//  AppDelegate.swift
//  Shortly
//
//  Created by Zain Ali on 2/27/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var navController: UINavigationController!
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        navController = UINavigationController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainView = MainViewController(nibName: nil, bundle: nil)
        navController.viewControllers = [mainView]
        self.window!.rootViewController = navController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

