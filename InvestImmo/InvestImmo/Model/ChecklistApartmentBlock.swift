//
//  ChecklistAppartmentBlock.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 31/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import RealmSwift

class ChecklistApartmentBlock: Object {
    
    @objc dynamic var name: String?
    @objc dynamic var yearOfConstruction: String?
    @objc dynamic var numberOfLots: String?
    @objc dynamic var internet: String?
    @objc dynamic var syndicate: String?
    @objc dynamic var facade: String?
    @objc dynamic var roof: String?
    @objc dynamic var communalAreas: String?
}
