//
//  ChecklistGeneral.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 31/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import RealmSwift

class ChecklistGeneral: Object {
    
    @objc dynamic var name: String?
    @objc dynamic var visitDate: String?
    @objc dynamic var estateType: String?
    @objc dynamic var surfaceArea: String?
    
}
