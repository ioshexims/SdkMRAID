//
//  SkLogger.swift
//  SwiftProject
//
//  Created by dev on 01/05/18.
//  Copyright © 2018 hexims. All rights reserved.
//

import UIKit

enum SourceKitLogLevel: Int
{
    case SourceKitLogLevelNone
    case SourceKitLogLevelError
    case SourceKitLogLevelWarning
    case SourceKitLogLevelInfo
    case SourceKitLogLevelDebug
}

var logLevel: SourceKitLogLevel?

public class SkLogger: NSObject
{
    
   class func debug(tag: NSString, withMessage message: NSString)
    {
//        if((logLevel?.rawValue)! > (SourceKitLogLevel.SourceKitLogLevelDebug.rawValue))
//        {
//            print("%@: (D) %@",tag, message)
//        }
        print("Debug")

    }
    
   class func info(tag: NSString, withMessage message: NSString)
    {
//        if((logLevel?.rawValue)! > (SourceKitLogLevel.SourceKitLogLevelInfo.rawValue))
//        {
//            print("%@: (I) %@",tag, message)
//
//        }
        print("Info")

    }
    
   class func warning(tag: NSString, withMessage message: NSString)
    {
//        if((logLevel?.rawValue)! > (SourceKitLogLevel.SourceKitLogLevelWarning.rawValue))
//        {
//            print("%@: (W) %@",tag, message)
//        }
        print("Warning")

    }
    
   class func error(tag: NSString, withMessage message: NSString)
    {
//        if((logLevel?.rawValue)! > (SourceKitLogLevel.SourceKitLogLevelError.rawValue))
//        {
//            print("%@: (E) %@",tag, message)
//        }
        print("Error")
    }
}
