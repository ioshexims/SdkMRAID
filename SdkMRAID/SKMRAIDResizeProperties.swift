//
//  SKMRAIDResizeProperties.swift
//  SwiftProject
//
//  Created by dev on 01/05/18.
//  Copyright © 2018 hexims. All rights reserved.
//

import UIKit

//enum SKMRAIDCustomClosePosition
//{
//    case MRAIDCustomClosePositionTopLeft
//    case MRAIDCustomClosePositionTopCenter
//    case MRAIDCustomClosePositionTopRight
//    case MRAIDCustomClosePositionCenter
//    case MRAIDCustomClosePositionBottomLeft
//    case MRAIDCustomClosePositionBottomCenter
//    case MRAIDCustomClosePositionBottomRight
//}

public class SKMRAIDResizeProperties: NSObject
{
    var width = Int()
    var height = Int()
    var offsetX = Int()
    var offsetY = Int()
    var allowOffscreen = Bool()
  // var customClosePosition: SKMRAIDCustomClosePosition?

    override init()
    {
        super .init()

        width = 0
        height = 0
        offsetX = 0
        offsetY = 0
        allowOffscreen = true
    }
    
    
  //  var customClosePosition: SKMRAIDCustomClosePosition!
  
    func MRAIDCustomClosePositionFromString(s: NSString) -> SKMRAIDCustomClosePosition
    {
        var names = NSArray()
        print(names)
        names = ["top-left","top-center","top-right","center","bottom-left","bottom-center","bottom-right"]
        
        var i: Int
        i = names .index(of: s)
        if (i != NSNotFound)
        {
            //return (SKMRAIDCustomClosePosition)i
        }
        
        return SKMRAIDCustomClosePosition.MRAIDCustomClosePositionTopRight
    }

}
