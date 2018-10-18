//
//  Item.swift
//  Todoey
//
//  Created by Tony Zhang on 2018/10/18.
//  Copyright © 2018年 SSM. All rights reserved.
//

import Foundation
import RealmSwift


class Item:Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var timeStamp = Date(timeIntervalSince1970: 1)
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
