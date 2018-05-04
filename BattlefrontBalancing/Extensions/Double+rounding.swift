//
//  Double+rounding.swift
//  BattlefrontBalancing
//
//  Created by Christian Riboldi on 5/3/18.
//  Copyright © 2018 Christian Riboldi. All rights reserved.
//

import Foundation

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
