//
//  TodoItem.swift
//  Todoey
//
//  Created by ZILU FANG on 31/8/2019.
//  Copyright © 2019 MYLES.HK. All rights reserved.
//

import Foundation
import RealmSwift


class TodoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var createdAt: Date? = Date()
    
    var category = LinkingObjects(fromType: Category.self, property: "items")
}
