//
//  TimeUtils.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//  Copyright (c) 2014 Chimani, LLC. All rights reserved.
//

import Foundation

let J0: Double = 0.0009

class TimeUtils {

    class func getJulianCycleD(_ d: Double, lw: Double) -> Double {
        return round(d - J0 - lw / (2 * Constants.PI()))
    }

    class func getApproxTransitHt(_ Ht: Double, lw: Double, n: Double) -> Double {
        return J0 + (Ht + lw) / (2 * Constants.PI()) + n
    }

    class func getSolarTransitJDs(_ ds: Double, M: Double, L: Double) -> Double {
        return J2000 + ds + 0.0053 * sin(M) - 0.0069 * sin(2 * L)
    }

    class func getHourAngleH(_ h: Double, phi: Double, d: Double) -> Double {
        return acos((sin(h) - sin(phi) * sin(d)) / (cos(phi) * cos(d)))
    }
}
