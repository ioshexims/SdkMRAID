//
//  IOSVersion.swift
//  SwiftProject
//
//  Created by dev on 01/05/18.
//  Copyright © 2018 hexims. All rights reserved.
//

import UIKit

public class IOSVersion: NSObject {

    class func SYSTEM_VERSION_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == ComparisonResult.orderedSame
    }
    
    class func SYSTEM_VERSION_GREATER_THAN(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == ComparisonResult.orderedDescending
    }

    
    class func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) != ComparisonResult.orderedAscending
    }

    
    class func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) == ComparisonResult.orderedAscending
    }
    
    class func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) != ComparisonResult.orderedDescending
    }
}
