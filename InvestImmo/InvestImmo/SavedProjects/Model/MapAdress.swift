//
//  MapAdress.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 24/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

class MapAdress: Object {
    
    @objc dynamic var name: String?
    @objc dynamic var adress: String?
    @objc dynamic var latitude: String?
    @objc dynamic var longitude: String?
}
