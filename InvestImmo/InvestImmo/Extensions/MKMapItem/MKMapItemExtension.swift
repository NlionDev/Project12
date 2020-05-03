//
//  MKMapItemExtension.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 29/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import MapKit

extension MKMapItem {
    convenience init(coordinate: CLLocationCoordinate2D, name: String) {
        self.init(placemark: .init(coordinate: coordinate))
        self.name = name
    }
}
