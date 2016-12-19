//
//  MoonUtils.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//  Copyright (c) 2014 Chimani, LLC. All rights reserved.
//

import Foundation

class MoonUtils {

    class func getMoonCoords(_ d: Double) -> GeocentricCoordinates {
        // geocentric ecliptic coordinates of the moon

        let L: Double = Constants.RAD() * (218.316 + 13.176396 * d) // ecliptic longitude
        let M: Double = Constants.RAD() * (134.963 + 13.064993 * d) // mean anomaly
        let F: Double = Constants.RAD() * (93.272 + 13.229350 * d) // mean distance

        let l: Double = L + Constants.RAD() * 6.289 * sin(M) // longitude
        let b: Double = Constants.RAD() * 5.128 * sin(F) // latitude
        let dt: Double = 385001 - 20905 * cos(M) // distance to the moon in km

        return GeocentricCoordinates(rightAscension: PositionUtils.getRightAscensionL(l, b: b), declination: PositionUtils.getDeclinationL(l, b: b), distance: dt)
    }
}
