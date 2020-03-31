//
//  ChecklistNeighborhood.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 31/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import RealmSwift

class ChecklistNeighborhood: Object {
    
    @objc dynamic var name: String?
    @objc dynamic var problem: String?
    @objc dynamic var advantage: String?
    @objc dynamic var transports: String?
    @objc dynamic var easyPark: String?
}
