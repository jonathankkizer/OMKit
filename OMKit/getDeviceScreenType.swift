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
    }
    
    return "Unknown"
}
