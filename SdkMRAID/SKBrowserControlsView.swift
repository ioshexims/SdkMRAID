//
//  SKBrowserControlsView.swift
//  SwiftProject
//
//  Created by dev on 18/04/18.
//  Copyright © 2018 hexims. All rights reserved.
//

import UIKit

protocol SourceKitBrowserControlsViewDelegate: NSObjectProtocol
{
    func back()
    func forward()
    func refresh()
    func launchSafari()
    func dismiss()
}

public class SKBrowserControlsView: UIView {
 
         var backButton = UIBarButtonItem()
         var forwardButton = UIBarButtonItem()
         var loadingIndicator = UIBarButtonItem()
         var controlsToolbar = UIToolbar()
         var flexBack: UIBarButtonItem!
         var flexForward: UIBarButtonItem!
         var flexLoading: UIBarButtonItem!
         var refreshButton: UIBarButtonItem!
         var flexRefresh: UIBarButtonItem!
         var launchSafariButton: UIBarButtonItem!
         var flexLaunch: UIBarButtonItem!
         var stopButton: UIBarButtonItem!
         var skBrowser: SKBrowser2!
    

    func initWithSourceKitBrowser(p_skBrowser: SKBrowser2) -> Any?
    {
         let customView = SKBrowserControlsView()
        if UIDevice().userInterfaceIdiom == .pad
        {
            self .deviceSettingToolBarFrame()
           // self .aaaaaaaaa()
        }
        else
        {
            customView.frame = CGRect(x: 0, y: 0, width: p_skBrowser.view.bounds.size.width, height:44.0)
            controlsToolbar.frame = CGRect(x: 0, y: 0, width: p_skBrowser.view.bounds.size.width, height:44.0)
        }
        
            print("REXCT =========== %@",NSStringFromCGRect(controlsToolbar.frame));

            skBrowser = p_skBrowser
            var backButtonImage = UIImage()
           // backButtonImage = UIImage(named: "BackButton.png")
        let image = UIImage(named: "BackButton.png", in: Bundle(for: SKBrowserControlsView.self), compatibleWith: nil)
//UIImage(named: "BackButton.png")
            backButton = UIBarButtonItem(image: image,
                                          style: .bordered,
                                          target: self,
                                          action: #selector(back))
            backButton .isEnabled = false
            flexBack = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)

            var forwardButtonImage = UIImage()
            //forwardButtonImage = UIImage(named: "ForwardButton.png")!
        let image2 = UIImage(named: "ForwardButton.png", in: Bundle(for: SKBrowserControlsView.self), compatibleWith: nil)

            forwardButton = UIBarButtonItem(image: image2, style: .bordered, target: self, action: #selector(forward))
        //UIImage(named: "ForwardButton.png")
            forwardButton .isEnabled = false
            flexForward = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            
            let placeHolder = UIView()
            placeHolder.frame = CGRect(x: 0, y: 0, width: 30.0, height:44.0)
            loadingIndicator = UIBarButtonItem.init(customView: placeHolder)
            flexLoading = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            refreshButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(refresh))
            flexRefresh = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            launchSafariButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(launchSafari))
            flexLaunch = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            stopButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(dismiss))
            var toolbarButtons = NSArray()
            toolbarButtons = [backButton,flexBack,forwardButton,flexForward,loadingIndicator,flexLoading,refreshButton,flexRefresh,launchSafariButton,flexLaunch,stopButton]
            controlsToolbar .setItems(toolbarButtons as? [UIBarButtonItem], animated: false)
          //  controlsToolbar .autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
            self .addSubview(controlsToolbar)

       // }
        return self
    }
    func aaaaaaaaa()
    {
        let customView = SKBrowserControlsView()

        let orientation = UIApplication.shared.statusBarOrientation
      
        if orientation == .portrait || orientation ==
            .portraitUpsideDown
        {
            if DeviceType.IS_IPAD
            {
                customView.frame = CGRect(x: 0, y: 0, width: 768, height:44.0)
                controlsToolbar.frame = CGRect(x: 0, y: 0, width: 768, height:44.0)
            }
            else if DeviceType.IS_IPAD_PRO_10_5
            {
                customView.frame = CGRect(x: 0, y: 0, width: 834, height:44.0)
                controlsToolbar.frame = CGRect(x: 0, y: 0, width: 834, height:44.0)
            }
            else if DeviceType.IS_IPAD_PRO_12_9
            {
                customView.frame = CGRect(x: 0, y: 0, width: 1024, height:44.0)
                controlsToolbar.frame = CGRect(x: 0, y: 0, width: 1024, height:44.0)
            }
        }
            
        else if orientation == .landscapeRight || orientation ==
            .landscapeLeft
        {
            if DeviceType.IS_IPAD
            {
                customView.frame = CGRect(x: 0, y: 0, width: 1024, height:44.0)
                controlsToolbar.frame = CGRect(x: 0, y: 0, width: 1024, height:44.0)
            }
            else if DeviceType.IS_IPAD_PRO_10_5
            {
                customView.frame = CGRect(x: 0, y: 0, width: 1112, height:44.0)
                controlsToolbar.frame = CGRect(x: 0, y: 0, width: 1112, height:44.0)
            }
            else if DeviceType.IS_IPAD_PRO_12_9
            {
                customView.frame = CGRect(x: 0, y: 0, width: 1366, height:44.0)
                controlsToolbar.frame = CGRect(x: 0, y: 0, width: 1366, height:44.0)
            }
        }
    }
    func deviceSettingToolBarFrame()
    {
          let customView = SKBrowserControlsView()
    
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft
        {
            if DeviceType.IS_IPAD
            {
                customView.frame = CGRect(x: 0, y: 0, width: 1024, height:44.0)
                controlsToolbar.frame = CGRect(x: 0, y: 0, width: 1024, height:44.0)
            }
            else if DeviceType.IS_IPAD_PRO_10_5
            {
                customView.frame = CGRect(x: 0, y: 0, width: 1112, height:44.0)
                controlsToolbar.frame = CGRect(x: 0, y: 0, width: 1112, height:44.0)
            }
            else if DeviceType.IS_IPAD_PRO_12_9
            {
                customView.frame = CGRect(x: 0, y: 0, width: 1366, height:44.0)
                controlsToolbar.frame = CGRect(x: 0, y: 0, width: 1366, height:44.0)
            }
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight
        {
            if DeviceType.IS_IPAD
            {
                customView.frame = CGRect(x: 0, y: 0, width: 1024, height:44.0)
                controlsToolbar.frame = CGRect(x: 0, y: 0, width:1024, height:44.0)
            }
            else if DeviceType.IS_IPAD_PRO_10_5
            {
                customView.frame = CGRect(x: 0, y: 0, width: 1112, height:44.0)
                controlsToolbar.frame = CGRect(x: 0, y: 0, width: 1112, height:44.0)
            }
            else if DeviceType.IS_IPAD_PRO_12_9
            {
                customView.frame = CGRect(x: 0, y: 0, width: 1366, height:44.0)
                controlsToolbar.frame = CGRect(x: 0, y: 0, width: 1366, height:44.0)
            }
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.portrait
        {
            if DeviceType.IS_IPAD
            {
                customView.frame = CGRect(x: 0, y: 0, width: 768, height:44.0)
                controlsToolbar.frame = CGRect(x: 0, y: 0, width: 768, height:44.0)
            }
            else if DeviceType.IS_IPAD_PRO_10_5
            {
                customView.frame = CGRect(x: 0, y: 0, width: 834, height:44.0)
                controlsToolbar.frame = CGRect(x: 0, y: 0, width: 834, height:44.0)
            }
            else if DeviceType.IS_IPAD_PRO_12_9
            {
                customView.frame = CGRect(x: 0, y: 0, width: 1024, height:44.0)
                controlsToolbar.frame = CGRect(x: 0, y: 0, width: 1024, height:44.0)
            }
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown
        {
            if DeviceType.IS_IPAD
            {
                customView.frame = CGRect(x: 0, y: 0, width: 768, height:44.0)
                controlsToolbar.frame = CGRect(x: 0, y: 0, width: 768, height:44.0)
            }
            else if DeviceType.IS_IPAD_PRO_10_5
            {
                customView.frame = CGRect(x: 0, y: 0, width: 834, height:44.0)
                controlsToolbar.frame = CGRect(x: 0, y: 0, width: 834, height:44.0)
            }
            else if DeviceType.IS_IPAD_PRO_12_9
            {
                customView.frame = CGRect(x: 0, y: 0, width: 1024, height:44.0)
                controlsToolbar.frame = CGRect(x: 0, y: 0, width: 1024, height:44.0)
            }
        }
    }
    
    deinit
    {
        flexBack = nil
        flexForward = nil
        flexLaunch = nil
        flexLoading = nil
        refreshButton = nil
        flexRefresh = nil
        launchSafariButton = nil
        stopButton = nil
    }
    
    @objc func back(sender: Any)
    {
        skBrowser .back()
    }
    @objc func dismiss(sender: Any)
    {
        skBrowser .dismiss()
    }
    @objc func forward(sender: Any)
    {
        skBrowser .forward()
    }
    @objc func launchSafari(sender: Any)
    {
        skBrowser .launchSafari()
    }
    @objc func refresh(sender: Any)
    {
        skBrowser .refresh()
    }
}
struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO_9_7      = IS_IPAD
    static let IS_IPAD_PRO_10_5      = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1112.0
    static let IS_IPAD_PRO_12_9     = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

