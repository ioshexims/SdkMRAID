 //
 //  SKMRAIDModalViewController.swift
 //  SwiftProject
 //
 //  Created by dev on 18/04/18.
 //  Copyright © 2018 hexims. All rights reserved.
 //
 
 import UIKit
 
 protocol SKMRAIDModalViewControllerDelegate: NSObjectProtocol
 {
    func mraidModalViewControllerDidRotate(modalViewController: SKMRAIDModalViewController)
 }

public class SKMRAIDModalViewController: UIViewController
 {
    weak var delegate: SKMRAIDModalViewControllerDelegate!
    var preferredOrientation: UIInterfaceOrientation?
    weak var orientationProperties: SKMRAIDOrientationProperties!

    var isStatusBarHidden = Bool()
    var hasViewAppeared = Bool()
    var hasRotated = Bool()

    func initWithOrientationProperties(orientationProps: SKMRAIDOrientationProperties) -> Any?
    {
        self.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

        if (orientationProps == nil)
        {
            //orientationProperties = orientationProps
        }
        else
        {
            orientationProperties = orientationProps
        }
        
        var currentInterfaceOrientation: UIInterfaceOrientation
        currentInterfaceOrientation = UIApplication .shared .statusBarOrientation
        
        if (orientationProperties.forceOrientation == .MRAIDForceOrientationPortrait)
        {
            preferredOrientation = UIInterfaceOrientation.portrait
        }
        
       else if (orientationProperties.forceOrientation == SKMRAIDForceOrientation.MRAIDForceOrientationLandscape)
        {
            if (UIInterfaceOrientationIsLandscape(currentInterfaceOrientation))
            {
                preferredOrientation = currentInterfaceOrientation
            }
            else
            {
                preferredOrientation = UIInterfaceOrientation.landscapeLeft
            }
        }
        else
        {
            preferredOrientation = currentInterfaceOrientation
        }
        return self
    }
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override public func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self .debug(tag: "MRAID - ModalViewController", withMessage: String(format: "%@ %@", self.description) as NSString)
        isStatusBarHidden = UIApplication .shared .isStatusBarHidden
        if (SYSTEM_VERSION_LESS_THAN(version: "7.0"))
        {
            //UIApplication .shared .setStatusBarHidden(true, with: UIStatusBarAnimation.fade)
            UIApplication .shared .isStatusBarHidden = true
        }
    }
  
    
    override public func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        self .debug(tag: "MRAID - ModalViewController", withMessage: String(format: "%@ %@", self.description) as NSString)
        hasViewAppeared = true
        if hasRotated
        {
            self.delegate .mraidModalViewControllerDidRotate(modalViewController: self)
            hasRotated = false
        }
    }
    
    override public func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        if (SYSTEM_VERSION_LESS_THAN(version: "7.0"))
        {
            UIApplication .shared .isStatusBarHidden = isStatusBarHidden
        }
    }
    
    func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    
    func shouldAutorotate() -> Bool
    {
        var supportedOrientationsInPlist = NSArray()
        supportedOrientationsInPlist = Bundle .main .object(forInfoDictionaryKey: "UISupportedInterfaceOrientations") as! NSArray
        var isPortraitSupported = Bool()
        isPortraitSupported = supportedOrientationsInPlist .contains("UIInterfaceOrientationPortrait")
        var isPortraitUpsideDownSupported = Bool()
        isPortraitUpsideDownSupported = supportedOrientationsInPlist .contains("UIInterfaceOrientationPortraitUpsideDown")
        var isLandscapeLeftSupported = Bool()
        isLandscapeLeftSupported = supportedOrientationsInPlist .contains("UIInterfaceOrientationLandscapeLeft")
        var isLandscapeRightSupported = Bool()
        isLandscapeRightSupported = supportedOrientationsInPlist .contains("UIInterfaceOrientationLandscapeRight")
     
        var currentInterfaceOrientation: UIInterfaceOrientation

        currentInterfaceOrientation = UIApplication .shared .statusBarOrientation
        
        var retval = Bool()
        retval = false
        
        if (orientationProperties.forceOrientation == SKMRAIDForceOrientation.MRAIDForceOrientationPortrait)
        {
            retval = (isPortraitSupported && isPortraitUpsideDownSupported)
        }
        else if (orientationProperties.forceOrientation == SKMRAIDForceOrientation.MRAIDForceOrientationLandscape)
        {
           retval = (isLandscapeRightSupported && isLandscapeLeftSupported)
        }
        else
        {
            if(orientationProperties.allowOrientationChange)
            {
               retval = true
            }
            else
            {
                if (UIInterfaceOrientationIsPortrait(currentInterfaceOrientation))
                {
                    retval = (isPortraitSupported && isPortraitUpsideDownSupported)
                }
            }
        }

        self .debug(tag: "MRAID - ModalViewController", withMessage: String(format: "%@ %@ %@", self.description,NSStringFromSelector(#function),(retval ? "YES":"NO")) as NSString)
        return retval

    }
    override public func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation
    {
        self .debug(tag: "MRAID - ModalViewController", withMessage: String(format: "%@ %@ %@", self.description, NSStringFromSelector(#function), self .stringfromUIInterfaceOrientation(interfaceOrientation: preferredOrientation!)) as NSString)
        return preferredOrientation!
    }
    
  
    func supportedInterfaceOrientations() -> Int
    {
        self .debug(tag: "MRAID - ModalViewController", withMessage: String(format: "%@ %@", self.description, NSStringFromSelector(#function)) as NSString)
        
        if (orientationProperties.forceOrientation == SKMRAIDForceOrientation.MRAIDForceOrientationPortrait)
        {
            return Int(UInt8(UIInterfaceOrientationMask.portrait.rawValue) | UInt8(UIInterfaceOrientationMask.portraitUpsideDown.rawValue))
        }
        
        if (orientationProperties.forceOrientation == SKMRAIDForceOrientation.MRAIDForceOrientationLandscape)
        {
            return Int(UIInterfaceOrientationMask.landscape.rawValue)
        }
        
        if (!orientationProperties.allowOrientationChange)
        {
            if(UIInterfaceOrientationIsPortrait(preferredOrientation!))
            {
                return Int(UInt8(UIInterfaceOrientationMask.portrait.rawValue) | UInt8(UIInterfaceOrientationMask.portraitUpsideDown.rawValue))
            }
            else
            {
                return Int(UIInterfaceOrientationMask.landscape.rawValue)
            }
        }
        return Int(UIInterfaceOrientationMask.all.rawValue)
    }
    
    func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator:UIViewControllerTransitionCoordinator)
    {
        coordinator .animate(alongsideTransition: { context in
            super .viewWillTransition(to: size, with: coordinator)
            
        },completion: { context in
            if(self.hasViewAppeared)
            {
              self.delegate .mraidModalViewControllerDidRotate(modalViewController: self)
                self.hasRotated = false
            }
        })
    }
  
    func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation)
    {
        let toInterfaceOrientation: UIInterfaceOrientation = self.interfaceOrientation
        self .debug(tag: "MRAID - ModalViewController", withMessage: String(format: "%@ %@from %@ to %@", self.description, NSStringFromSelector(#function),(self .stringfromUIInterfaceOrientation(interfaceOrientation: fromInterfaceOrientation)),(interfaceOrientation: toInterfaceOrientation) as! CVarArg) as NSString)
      
        if hasViewAppeared
        {
            self.delegate .mraidModalViewControllerDidRotate(modalViewController: self)
            hasRotated = false
        }
    }
    
    func forceToOrientation(orientationProps: SKMRAIDOrientationProperties)
    {
        var orientationString = NSString()
        switch (orientationProps.forceOrientation)
        {
        case .MRAIDForceOrientationPortrait:
            orientationString = "portrait"
            break
        case .MRAIDForceOrientationLandscape:
            orientationString = "landscape"
            break
        case .MRAIDForceOrientationNone:
            orientationString = "none"
            break
        default:
            orientationString = "wtf!"
            break
        }
        
        self .debug(tag: "MRAID - ModalViewController", withMessage: String(format: "%@ %@ %@ %@", self.description, NSStringFromSelector(#function),(orientationProperties.allowOrientationChange ? "YES":"NO"),orientationString) as NSString)
        orientationProperties = orientationProps
        var currentInterfaceOrientation: UIInterfaceOrientation

        currentInterfaceOrientation = UIApplication .shared .statusBarOrientation

        if (orientationProperties.forceOrientation == SKMRAIDForceOrientation.MRAIDForceOrientationPortrait)
        {
            if (UIInterfaceOrientationIsPortrait(currentInterfaceOrientation))
            {
              preferredOrientation = currentInterfaceOrientation
            }
            else
            {
                preferredOrientation = UIInterfaceOrientation.portrait
            }
        }
        else if(orientationProperties.forceOrientation == SKMRAIDForceOrientation.MRAIDForceOrientationLandscape)
        {
            if (UIInterfaceOrientationIsLandscape(currentInterfaceOrientation))
            {
                preferredOrientation = currentInterfaceOrientation
            }
            else
            {
                preferredOrientation = UIInterfaceOrientation.landscapeLeft
            }
        }
        else
        {
            if(orientationProperties.allowOrientationChange)
            {
                var currentDeviceOrientation: UIDeviceOrientation
                currentDeviceOrientation = UIDevice .current .orientation
                
                if(currentDeviceOrientation == UIDeviceOrientation.portrait)
                {
                    preferredOrientation = UIInterfaceOrientation.portrait
                }
                else if (currentDeviceOrientation == UIDeviceOrientation.portraitUpsideDown)
                {
                    preferredOrientation = UIInterfaceOrientation.portraitUpsideDown
                }
                else if (currentDeviceOrientation == UIDeviceOrientation.landscapeRight)
                {
                    preferredOrientation = UIInterfaceOrientation.landscapeRight
                }
                else if (currentDeviceOrientation == UIDeviceOrientation.landscapeLeft)
                {
                    preferredOrientation = UIInterfaceOrientation.landscapeLeft
                }
                
               
                var preferredOrientationString = NSString()
                if(preferredOrientation == UIInterfaceOrientation.portrait)
                {
                    preferredOrientationString = "UIInterfaceOrientationPortrait";
                }
                else if (preferredOrientation == UIInterfaceOrientation.portraitUpsideDown)
                {
                    preferredOrientationString = "UIInterfaceOrientationPortraitUpsideDown";
                }
                else if (preferredOrientation == UIInterfaceOrientation.landscapeLeft)
                {
                    preferredOrientationString = "UIInterfaceOrientationLandscapeLeft";
                }
                else if (preferredOrientation == UIInterfaceOrientation.landscapeRight)
                {
                    preferredOrientationString = "UIInterfaceOrientationLandscapeRight";
                }
                
                var supportedOrientationsInPlist = NSArray()
                supportedOrientationsInPlist = Bundle .main .object(forInfoDictionaryKey: "UISupportedInterfaceOrientations") as! NSArray
                var isSupported = Bool()
                isSupported = supportedOrientationsInPlist .contains(preferredOrientationString)
                
                if (!isSupported)
                {
                    preferredOrientationString = supportedOrientationsInPlist[0] as! NSString
                    
                    if (preferredOrientationString .isEqual(to: "UIInterfaceOrientationPortrait"))
                    {
                        preferredOrientation = UIInterfaceOrientation.portrait
                    }
                    else if (preferredOrientationString .isEqual(to: "UIInterfaceOrientationPortraitUpsideDown"))
                    {
                        preferredOrientation = UIInterfaceOrientation.portraitUpsideDown
                    }
                    else if (preferredOrientationString .isEqual(to: "UIInterfaceOrientationLandscapeLeft"))
                    {
                        preferredOrientation = UIInterfaceOrientation.landscapeLeft
                    }
                    else if (preferredOrientationString .isEqual(to: "UIInterfaceOrientationLandscapeRight"))
                    {
                        preferredOrientation = UIInterfaceOrientation.landscapeRight
                    }
                }
            }
            else
            {
                preferredOrientation = currentInterfaceOrientation
            }
        }
        self .debug(tag: "MRAID - ModalViewController", withMessage:String(format: "requesting from %@ to %@",(self .stringfromUIInterfaceOrientation(interfaceOrientation: currentInterfaceOrientation)),(self .stringfromUIInterfaceOrientation(interfaceOrientation: preferredOrientation!))) as NSString)
        
        if ((orientationProperties.forceOrientation == SKMRAIDForceOrientation.MRAIDForceOrientationPortrait && UIInterfaceOrientationIsPortrait(currentInterfaceOrientation)) || (orientationProperties.forceOrientation == SKMRAIDForceOrientation.MRAIDForceOrientationLandscape && UIInterfaceOrientationIsLandscape(currentInterfaceOrientation)) || (orientationProperties.forceOrientation == SKMRAIDForceOrientation.MRAIDForceOrientationNone && preferredOrientation == currentInterfaceOrientation))
        {
            return
        }
        
        var presentingVC = UIViewController()
        
        if (self .responds(to: #selector(getter: presentingViewController)))
        {
            presentingVC = self.presentingViewController!
        }
        else
        {
            presentingVC = self.parent!
        }
  
        if (self .responds(to: #selector(present(_:animated:completion:))) && self .responds(to: #selector(dismiss(animated:completion:))))
        {
            self .dismiss(animated: false, completion: {
                presentingVC .present(self, animated: false, completion: nil)
            })
        }
        else
        {
            self .dismiss(animated: false, completion: nil)
            presentingVC .present(self, animated: false, completion: nil)
        }
        hasRotated = true
    }
   
    func stringfromUIInterfaceOrientation(interfaceOrientation: UIInterfaceOrientation) -> String
    {
        switch (interfaceOrientation)
        {
        case UIInterfaceOrientation.portrait:
            return "portrait"
        case UIInterfaceOrientation.portraitUpsideDown:
            return "portrait upside down"
        case UIInterfaceOrientation.landscapeLeft:
            return "landscape left"
        case UIInterfaceOrientation.landscapeRight:
            return "landscape right"
        default:
            return "unknown"
        }
    }
    
    func debug(tag: NSString, withMessage message: NSString)
    {
    }
    
    func SYSTEM_VERSION_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == ComparisonResult.orderedSame
    }
    
    func SYSTEM_VERSION_GREATER_THAN(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == ComparisonResult.orderedDescending
    }
    
    func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) != ComparisonResult.orderedAscending
    }
    
    func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == ComparisonResult.orderedAscending
    }
    
    func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) != ComparisonResult.orderedDescending
    }
 }
