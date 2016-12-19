//
//  SunUtils.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//  Copyright (c) 2014 Chimani, LLC. All rights reserved.
//

import Foundation

class SunUtils {

    class func getSolarMeanAnomaly(_ d: Double) -> Double {
        return Constants.RAD() * (357.5291 + 0.98560028 * d)
    }

    class func getEquationOfCenter(_ M: Double) -> Double {
        return Constants.RAD() * (1.9148 * sin(M) + 0.02 * sin(2 * M) + 0.0003 * sin(3 * M))
    }

    class func getEclipticLongitudeM(_ M: Double) -> Double {
        let C: Double = SunUtils.getEquationOfCenter(M)
        let P: Double = Constants.RAD() * 102.9372 // perihelion of the Earth
        return M + C + P + Constants.PI()
    }

    class func getSunCoords(_ d: Double) -> EquatorialCoordinates {
        let M: Double = SunUtils.getSolarMeanAnomaly(d)
        let L: Double = SunUtils.getEclipticLongitudeM(M)

        return EquatorialCoordinates(rightAscension: PositionUtils.getRightAscensionL(L, b: 0), declination: PositionUtils.getDeclinationL(L, b: 0))
    }
}
