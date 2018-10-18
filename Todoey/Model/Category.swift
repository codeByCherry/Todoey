//
//  Category.swift
//  Todoey
//
//  Created by Tony Zhang on 2018/10/18.
//  Copyright © 2018年 SSM. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name: String = ""
    
    // bulid relationship between Category and Item
    // 在realm中使用 list 替换 array
    let items = List<Item>()
}
