//
//  SoftAlert.swift
//  SoftAlert
//
//  Created by 황견주 on 2020/06/29.
//  Copyright © 2020 dvkyun. All rights reserved.
//

import UIKit

public enum SoftAlertType {
    case positive
    case negative
}

public enum SoftAlertDuration {
    case tiny
    case short
    case long
}

struct SoftAlertStatic {
    static let colorPositive = UIColor(red: 109/255, green: 200/255, blue: 87/255, alpha: 1.0)
    static let colorNegative = UIColor.red
    
    static let tiny: Double = 1
    static let short: Double = 2
    static let long: Double = 3.5
}

struct SoftAlertUtil {
    
    static func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.windows.filter({$0.isKeyWindow}).first
    }
    
    static func hasNotch() -> Bool {
        if getKeyWindow()?.safeAreaInsets.bottom ?? 0 > 0 {
            return true
        } else {
            return false
        }
    }
    
    static func genType(_ type: SoftAlertType) -> UIColor {
        switch type {
        case .positive:
            return SoftAlertStatic.colorPositive
        case .negative:
            return SoftAlertStatic.colorNegative
        }
    }
    
    static func genDuration(_ duration: SoftAlertDuration) -> Double {
        switch duration {
        case .tiny:
            return SoftAlertStatic.tiny
        case .short:
            return SoftAlertStatic.short
        case .long:
            return SoftAlertStatic.long
        }
    }
    
}
