//
//  ProjectMapAnnotation.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 24/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import MapKit

/// Class for ProjectMapAnnotation
class ProjectMapAnnotation: NSObject, MKAnnotation {
    
    //MARK: - Properties
    
    /// Title of map annotation
    var title: String?
    
    /// Info of map annotation
    var info: String
    
    /// Coordinate of map annotation
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
