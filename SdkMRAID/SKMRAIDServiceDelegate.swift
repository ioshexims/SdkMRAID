//
//  SKMRAIDServiceDelegate.swift
//  SwiftProject
//
//  Created by dev on 18/04/18.
//  Copyright © 2018 hexims. All rights reserved.
//

import UIKit


public struct Constants
{
   public static let MRAIDSupportsSMS = "TEST"
    //static let MRAIDSupportsCalendar = "calendar"
   public static let MRAIDSupportsStorePicture = "storePicture"
   public static let MRAIDSupportsInlineVideo = "inlineVideo"

}
 public protocol SKMRAIDServiceDelegate: NSObjectProtocol
{
    func mraidServiceOpenBrowserWithUrlString(urlString: NSString)
    func mraidServiceStorePictureWithUrlString(urlString: NSString)
}
