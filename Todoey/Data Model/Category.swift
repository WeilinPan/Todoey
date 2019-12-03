//
//  Category.swift
//  Todoey
//
//  Created by APAN on 2019/12/2.
//  Copyright © 2019 APAN. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()    // 類似宣告空白陣列的方式
}
