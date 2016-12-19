//
//  PositionUtils.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//  Copyright (c) 2014 Chimani, LLC. All rights reserved.
//

import Foundation

class PositionUtils {

    class func getRightAscensionL(_ l: Double, b: Double) -> Double {
        return atan2(sin(l) * cos(Constants.E()) - tan(b) * sin(Constants.E()), cos(l))
    }

    class func getDeclinationL(_ l: Double, b: Double) -> Double {
        return asin(sin(b) * cos(Constants.E()) + cos(b) * sin(Constants.E()) * sin(l))
    }

    class func getAzimuthH(_ H: Double, phi: Double, dec: Double) -> Double {
        return atan2(sin(H), cos(H) * sin(phi) - tan(dec) * cos(phi))
    }

    class func getAltitudeH(_ H: Double, phi: Double, dec: Double) -> Double {
        return asin(sin(phi) * sin(dec) + cos(phi) * cos(dec) * cos(H))
    }

    class func getSiderealTimeD(_ d: Double, lw: Double) -> Double {
        return Constants.RAD() * (280.16 + 360.9856235 * d) - lw
    }
}
