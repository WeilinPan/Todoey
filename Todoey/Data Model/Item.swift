//
//  Item.swift
//  Todoey
//
//  Created by APAN on 2019/12/2.
//  Copyright © 2019 APAN. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreate: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
