//
//  SoftAlert.swift
//  SoftAlert
//
//  Created by 황견주 on 2020/06/29.
//  Copyright © 2020 dvkyun. All rights reserved.
//

import UIKit

public enum SoftType {
    case positive
    case negative
}

public enum SoftDuration {
    case tiny
    case short
    case long
}

struct SoftStatic {
    static let colorPositive = UIColor(red: 109/255, green: 200/255, blue: 87/255, alpha: 1.0)
    static let colorNegative = UIColor.red
    
    static let tiny: Double = 1
    static let short: Double = 2
    static let long: Double = 3.5
}

struct SoftUtil {
    
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
    
    static func genType(_ type: SoftType) -> UIColor {
        switch type {
        case .positive:
            return SoftStatic.colorPositive
        case .negative:
            return SoftStatic.colorNegative
        }
    }
    
    static func genDuration(_ duration: SoftDuration) -> Double {
        switch duration {
        case .tiny:
            return SoftStatic.tiny
        case .short:
            return SoftStatic.short
        case .long:
            return SoftStatic.long
        }
    }
    
    static func isDarkMode(_ keyWindow: UIWindow) -> Bool {
        if #available(iOS 12.0, *) {
            if keyWindow.rootViewController?.traitCollection.userInterfaceStyle == .dark {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
}
