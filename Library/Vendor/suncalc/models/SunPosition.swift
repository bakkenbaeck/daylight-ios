//
//  SunPosition.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//  Copyright (c) 2014 Chimani, LLC. All rights reserved.
//

import Foundation

class SunPosition {
    var azimuth: Double
    var altitude: Double

    init(azimuth: Double, altitude: Double) {
        self.azimuth = azimuth
        self.altitude = altitude
    }
}
