//
//  SKMRAIDOrientationProperties.swift
//  SwiftProject
//
//  Created by dev on 04/05/18.
//  Copyright © 2018 hexims. All rights reserved.
//

import UIKit

public enum SKMRAIDForceOrientation
{
    case MRAIDForceOrientationPortrait
    case MRAIDForceOrientationLandscape
    case MRAIDForceOrientationNone
}

public class SKMRAIDOrientationProperties: NSObject
{
    var allowOrientationChange = Bool()
//   // var forceOrientation = SKMRAIDForceOrientation.self
//    
    var forceOrientation: SKMRAIDForceOrientation!
//
//    
//    
    override init()
    {
        super .init()
        allowOrientationChange = true
       forceOrientation = SKMRAIDForceOrientation.MRAIDForceOrientationNone
    }
//
    func SKMRAIDOrientationProperties(s: NSString) -> SKMRAIDForceOrientation
    {
        var names = NSArray()
        names = ["portrait","landscape","none"]
        let i: Int = names .index(of: s)
        print(i)
        if (i != NSNotFound)
        {
            //return (SKMRAIDForceOrientation)i
        }
        
       return SKMRAIDForceOrientation.MRAIDForceOrientationNone
    }

}
