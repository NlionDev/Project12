//
//  Checklist.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 09/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import RealmSwift

class Checklist: Object {
    
    @objc dynamic var name: String?
    let checklistGeneral = List<ChecklistGeneral>()
    
//    convenience init(name: String, checklistGeneral: ChecklistGeneral) {
//        self.init()
//        self.name = name
//        self.checklistGeneral.append(checklistGeneral)
//    }
    
    
}

class ChecklistGeneral: Object {
    
    @objc dynamic var key: String?
    @objc dynamic var value: String?
    
}
