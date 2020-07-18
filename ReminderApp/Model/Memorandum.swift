//
//  Memorandum.swift
//  ReminderApp
//
//  Created by 彭海明 on 2020/7/17.
//  Copyright © 2020 Jacky Peng. All rights reserved.
//

import Foundation
import RealmSwift

class Memorandum: Object {
    
    
    @objc dynamic var dateReminder = Date()
    @objc dynamic var title: String = ""
    @objc dynamic var depiction: String = ""
    @objc dynamic var color: String = "000000"
    @objc dynamic var category: String = ""
//    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
