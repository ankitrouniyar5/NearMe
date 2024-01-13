//
//  Annotations.swift
//  NearMe
//
//  Created by Ankit Rouniyar on 13/01/24.
//

import Foundation
import MapKit

final class PlaceAnnotation: MKPointAnnotation {
    
    let mapItem: MKMapItem
    let id = UUID()
    var isSelected: Bool = false
    
    var name: String {
        mapItem.name ?? String()
    }
    
    var phone: String {
        mapItem.phoneNumber ?? String()
    }
    
    var location: CLLocation {
        mapItem.placemark.location ?? CLLocation.default
    }
    
    var address: String {
        "\(mapItem.placemark.subThoroughfare ?? "") \(mapItem.placemark.thoroughfare ?? "") \(mapItem.placemark.locality ?? "") \(mapItem.placemark.locality ?? "")"
    }
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
        super.init()
        self.coordinate = mapItem.placemark.coordinate
    }
    
}
