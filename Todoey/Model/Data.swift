//
//  Data.swift
//  Todoey
//
//  Created by Tony Zhang on 2018/10/18.
//  Copyright © 2018年 SSM. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int  = 0
    
    override var description: String {
        return " name:\(name) \n age:\(age)"
    }
}
