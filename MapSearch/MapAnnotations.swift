//
//  MapAnnotations.swift
//  MapSearch
//
//  Created by Paul Lozada on 2016-02-18.
//  Copyright © 2016 Paul Lozada. All rights reserved.
//

import UIKit
import MapKit

class MapAnnotations: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
