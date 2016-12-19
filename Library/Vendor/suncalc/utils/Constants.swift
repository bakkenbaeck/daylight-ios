//
//  Constants.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//  Copyright (c) 2014 Chimani, LLC. All rights reserved.
//

import Foundation

let π = 3.14159265358979

class Constants {

    class func RAD() -> Double {
        return π / 180.0
    }

    class func E() -> Double {
        return Constants.RAD() * 23.4397 // obliquity of the earth
    }

    class func PI() -> Double {
        return π
    }
}
