//
//  AnnotationView.swift
//  Pokemon Go
//
//  Created by Rethink on 18/03/22.
//

import UIKit
import MapKit

class AnnotationPokemon: NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(coordinate: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordinate
        self.pokemon = pokemon
    }
}
