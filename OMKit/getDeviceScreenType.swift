//
//  getDeviceScreenType.swift
//  OMKit
//
//  Created by Jonathan Kizer on 12/18/17.
//  Copyright © 2017 Kizer Co. All rights reserved.
//

import Foundation
import UIKit

func getDeviceScreenType() -> String {
    // Screen width.
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Screen height.
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    print ("Width", screenWidth)
    print("Height", screenHeight)
    if screenWidth == 375.000000 && screenHeight == 812.000000 {
        print ("iPhone X size")
        return "iPhone5.8"
    } else if screenWidth == 375.000000 && screenHeight == 667.000000 {
        print("iPhone 6 size")
        return "iPhone4.7"
    } else if screenWidth == 414.000000 && screenHeight == 736.000000 {
        print("iPhone 6+ size")
        return "iPhone5.5"
    } else if screenWidth == 320.000000 && screenHeight == 568.000000 {
        print("iPhone5S size")
        return "iPhone4.0"
    } else if screenWidth == 834.000000 && screenHeight == 1112.000000 {
        print("iPad10.5 size")
        return "iPad10.5"
    } else if screenWidth == 1024.000000 && screenHeight == 1366.000000 {
        print ("iPad12.9 size")
        return "iPad12.9"
    } else if screenWidth == 768.000000 && screenHeight == 1024.000000 {
        print("iPad9.7 size")
        return "iPad9.7"
    }
    return "Unknown"
}
