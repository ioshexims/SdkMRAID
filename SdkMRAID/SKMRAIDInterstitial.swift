//
//  SKMRAIDInterstitial.swift
//  SwiftProject
//
//  Created by dev on 14/05/18.
//  Copyright © 2018 hexims. All rights reserved.
//

import UIKit
protocol SKMRAIDInterstitialDelegate: NSObjectProtocol
{
    func mraidInterstitialAdReady(mraidInterstitial: SKMRAIDInterstitial)
    func mraidInterstitialAdFailed(mraidInterstitial: SKMRAIDInterstitial)
    func mraidInterstitialWillShow(mraidInterstitial: SKMRAIDInterstitial)
    func mraidInterstitialDidHide(mraidInterstitial: SKMRAIDInterstitial)
    func mraidInterstitialNavigate(mraidInterstitial: SKMRAIDInterstitial, withURL url: NSURL)
}

public class SKMRAIDInterstitial: NSObject, SKMRAIDViewDelegate, SKMRAIDServiceDelegate
{
    var isReady = Bool()
    var mraidView = SKMRAIDView2()
    var supportedFeatures: NSArray?
    var rootViewController = UIViewController()
    var delegate : SKMRAIDInterstitialDelegate?
    var serviceDelegate : SKMRAIDServiceDelegate!
    
    private var _isViewable: Bool? = nil
    var isViewable: Bool? {
        get
        {
            return self .isViewable1()
        }
        set
        {
            _isViewable = newValue
            self .setIsViewable(newIsViewable: true)
        }
    }
  
    deinit {
      //  mraidView = nil
        supportedFeatures = nil
        // perform the deinitialization
    }
    
    func initWithSupportedFeatures(features: NSArray, withHtmlData htmlData: NSString, withBaseURL bsURL: NSURL, delegat: SKMRAIDInterstitialDelegate, serviceDelegat: SKMRAIDServiceDelegate, rootViewControllerr: UIViewController) -> Any
    {
        supportedFeatures = features
        delegate = delegat
        serviceDelegate = serviceDelegat
        rootViewController = rootViewControllerr
        
        let screenRect: CGRect = UIScreen .main .bounds
        mraidView = mraidView .initWithFrame(frame: screenRect, withHtmlData: htmlData, withBaseURL: bsURL, supportedFeatures: supportedFeatures!, asInterstitial: true, delegat: self, serviceDelegat: self, rootViewController: self.rootViewController) as! SKMRAIDView2
        mraidView .delegate = self
        _isViewable = false
        isReady = false
        
        return self
    }
    
    func isAdReady() -> Bool
    {
        return isReady
    }
    
    func show()
    {
        if !isReady
        {
            SkLogger .warning(tag: "MRAID - Interstitial", withMessage: "interstitial is not ready to show")
            return
        }
        mraidView .perform(#selector(mraidView .showAsInterstitial))
    }
    
    func setIsViewable(newIsViewable: Bool)
    {
        SkLogger .debug(tag: "MRAID - Interstitial", withMessage: String(format: "%@ %@", self.description,NSStringFromSelector(#function)) as NSString)
        mraidView.isViewable = newIsViewable
    }
    
    func isViewable1() -> Bool
    {
        SkLogger .debug(tag: "MRAID - Interstitial", withMessage: String(format: "%@ %@", self.description,NSStringFromSelector(#function)) as NSString)
        return _isViewable!
    }
    
    func setRootViewController(newRootViewController: UIViewController)
    {
        mraidView.rootViewController = newRootViewController
        SkLogger .debug(tag: "MRAID - Interstitial", withMessage: String(format: "setRootViewController: %@", newRootViewController) as NSString)
    }
    
    func setBackgroundColor(backgroundColor: UIColor)
    {
        mraidView .backgroundColor = backgroundColor
    }
    
    public func mraidViewAdReady(mraidView: SKMRAIDView2)
    {
        isReady = true
        self .delegate? .mraidInterstitialAdReady(mraidInterstitial: self)
    }
    
    public func mraidViewAdFailed(mraidView: SKMRAIDView2)
    {
        isReady = true
        
        if (self .delegate? .responds(to: #selector(self .mraidInterstitialAdFailed(mraidInterstitial:))))!
        {
            self .delegate? .mraidInterstitialAdFailed(mraidInterstitial: self)
        }
    }
    
    public func mraidViewWillExpand(mraidView: SKMRAIDView2)
    {
            self .delegate? .mraidInterstitialWillShow(mraidInterstitial: self)
    }
    
    public func mraidViewDidClose(mraidView: SKMRAIDView2)
    {
        self .delegate? .mraidInterstitialDidHide(mraidInterstitial: self)
      
        mraidView .delegate = nil
      //  mraidView .rootViewController = nil
//        mraidView .rootViewController = nil
      //  mraidView = nil
        isReady = false
    }
    
    @objc public func mraidViewNavigate(mraidView: SKMRAIDView2, withURL url: NSURL)
    {
        print("LOG")
        if (self .delegate? .responds(to: #selector(mraidViewNavigate(mraidView:withURL:))))!
        {
            self .delegate? .mraidInterstitialNavigate(mraidInterstitial: self, withURL: url)
        }
    }
    
   public func MRAIDForceOrientationFromString(s: NSString) -> SKMRAIDForceOrientation
    {
        return SKMRAIDForceOrientation.MRAIDForceOrientationPortrait
    }
    
   public func mraidViewShouldResize(mraidView: SKMRAIDView2, toPosition position: CGRect, allowOffscreen: Bool) -> Bool
    {
        return true
    }
    
   
    @objc public func mraidServiceOpenBrowserWithUrlString(urlString: NSString)
    {
        self .serviceDelegate .mraidServiceOpenBrowserWithUrlString(urlString: urlString)
    }
    
    @objc public func mraidServiceStorePictureWithUrlString(urlString: NSString)
    {
        self .serviceDelegate .mraidServiceStorePictureWithUrlString(urlString: urlString)
    }
    
    @objc func mraidInterstitialDidClose(mraidInterstitial: SKMRAIDInterstitial)
    {
        print("")
    }
    
    @objc func mraidInterstitialAdReady(mraidInterstitial: SKMRAIDInterstitial)
    {
        print("")
    }
    
    @objc func mraidInterstitialWillShow(mraidInterstitial: SKMRAIDInterstitial)
    {
        print("")
    }
    
    @objc func mraidInterstitialDidHide(mraidInterstitial: SKMRAIDInterstitial)
    {
        print("")
    }
   
    @objc func mraidInterstitialAdFailed(mraidInterstitial: SKMRAIDInterstitial)
    {
        print("")
    }
    
    @objc func mraidInterstitialWillExpand(mraidInterstitial: SKMRAIDInterstitial)
    {
        print("")
    }

}
