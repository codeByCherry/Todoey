//
//  AppDelegate.swift
//  Todoey
//
//  Created by Tony Zhang on 2018/10/16.
//  Copyright © 2018年 SSM. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // setup Realm
        print("Realm config:")
        print(Realm.Configuration.defaultConfiguration)
        
        let d1 = Data()
        d1.age = 110
        d1.name = "tony"
        
        var realm:Realm?
        do {
            realm = try Realm()
    
        } catch {
            print("setup realm error:\(error)")
        }
        
        if let r = realm {
            do {
               try r.write {
                    r.add(d1)
                }
            } catch {
                
            }
        }

        
        
        
        print("Local File Path:\(filePath)")
        return true
    }
    
    // 系统自动生成的代码,使用coredata模板
    func applicationWillTerminate(_ application: UIApplication) {

        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "DataModels")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

