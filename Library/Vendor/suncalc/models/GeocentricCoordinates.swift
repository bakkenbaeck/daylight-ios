//
//  GeocentricCoordinates.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//  Copyright (c) 2014 Chimani, LLC. All rights reserved.
//

import Foundation

class GeocentricCoordinates {
    var rightAscension: Double
    var declination: Double
    var distance: Double

    init(rightAscension: Double, declination: Double, distance: Double) {
        self.rightAscension = rightAscension
        self.declination = declination
        self.distance = distance
    }
}
