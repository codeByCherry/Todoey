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
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
