//
//  BattleTeam.swift
//  BattlefrontBalancing
//
//  Created by Christian Riboldi on 5/3/18.
//  Copyright © 2018 Christian Riboldi. All rights reserved.
//

import UIKit

enum BattleTeam {
    case one, two, three, four, five, six, seven, eight, nine, ten, none
    init(teamNumber: Int?) {
        switch teamNumber {
        case 1:
            self = .one
        case 2:
            self = .two
        case 3:
            self = .three
        case 4:
            self = .four
        case 5:
            self = .five
        case 6:
            self = .six
        case 7:
            self = .seven
        case 8:
            self = .eight
        case 9:
            self = .nine
        case 10:
            self = .ten
        default:
            self = .none
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .one:
            return UIColor(rgb: 0xFFB5B2)
        case .two:
            return UIColor(rgb: 0xFFE6AD)
        case .three:
            return UIColor(rgb: 0xFFFEB6)
        case .four:
            return UIColor(rgb: 0xE6FCB0)
        case .five:
            return UIColor(rgb: 0xBDFBC0)
        case .six:
            return UIColor(rgb: 0xB2FFFF)
        case .seven:
            return UIColor(rgb: 0xB3E8FF)
        case .eight:
            return UIColor(rgb: 0xB4B8FF)
        case .nine:
            return UIColor(rgb: 0xE8B4FF)
        case .ten:
            return UIColor(rgb: 0xFF9DCC)
        default:
            return UIColor.white
        }
    }
}
