//
//  Category.swift
//  Todoey
//
//  Created by ZILU FANG on 31/8/2019.
//  Copyright © 2019 MYLES.HK. All rights reserved.
//

import Foundation
import RealmSwift



class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colorHex: String = ""
    let items = List<TodoItem>()
}
