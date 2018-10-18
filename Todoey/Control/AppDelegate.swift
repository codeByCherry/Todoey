//
//  AppDelegate.swift
//  Todoey
//
//  Created by Tony Zhang on 2018/10/16.
//  Copyright © 2018年 SSM. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("Realm config:")
        print(Realm.Configuration.defaultConfiguration)
        
        UINavigationBar.appearance().tintColor = UIColor.white
    
        // Realm config


        return true
    }
    
    
}

