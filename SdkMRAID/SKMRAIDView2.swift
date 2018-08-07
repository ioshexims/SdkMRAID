//
//  SKMRAIDView2.swift
//  SwiftProject
//
//  Created by dev on 26/04/18.
//  Copyright © 2018 hexims. All rights reserved.
//

////// Code Fix for cAvg crash -> NSNumber,(value: true) as!

/* example
 //              SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "isViewable: %@", isViewable! as  NSNumber,(value: true) as! CVarArg) as NSString)
 
 self .injectJavaScript(js:  String(format: "mraid.setSupports('%@',%@);",aFeature as! CVarArg,currentFeatures .contains(aFeature) as NSNumber,(value: true) as! CVarArg) as NSString)
 */

import UIKit
import WebKit


 enum MRAIDState: Int
{
    case MRAIDStateLoading
    case MRAIDStateDefault
    case MRAIDStateExpanded
    case MRAIDStateResized
    case MRAIDStateHidden
}

//enum ScreenType: String {
//    case iPhone4_4S = "iPhone 4 or iPhone 4S"
//    case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
//    case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
//    case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
//    case iPhoneX = "iPhone X"
//    case unknown
//}
enum SKMRAIDCustomClosePosition
{
    case MRAIDCustomClosePositionTopLeft
    case MRAIDCustomClosePositionTopCenter
    case MRAIDCustomClosePositionTopRight
    case MRAIDCustomClosePositionCenter
    case MRAIDCustomClosePositionBottomLeft
    case MRAIDCustomClosePositionBottomCenter
    case MRAIDCustomClosePositionBottomRight
}

public protocol SKMRAIDViewDelegate: NSObjectProtocol
{
    func mraidViewAdReady(mraidView: SKMRAIDView2)
    func mraidViewAdFailed(mraidView: SKMRAIDView2)
    func mraidViewWillExpand(mraidView: SKMRAIDView2)
    func mraidViewDidClose(mraidView: SKMRAIDView2)
    func mraidViewNavigate(mraidView: SKMRAIDView2, withURL url: NSURL)
    func MRAIDForceOrientationFromString(s: NSString) -> SKMRAIDForceOrientation
    
    func mraidViewShouldResize(mraidView: SKMRAIDView2, toPosition position: CGRect, allowOffscreen: Bool) -> Bool
}




public class SKMRAIDView2: UIView,UIWebViewDelegate,SKMRAIDModalViewControllerDelegate,UIGestureRecognizerDelegate,SKMRAIDServiceDelegate, WKUIDelegate, WKNavigationDelegate
{
    
    var rootViewController = UIViewController()
    var delegate : SKMRAIDViewDelegate!
    
    private var _isViewable: Bool? = nil
   public var isViewable: Bool? {
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
    
    var wkWebView: WKWebView!
    
    var screenWebHeight = CGFloat()
    var width = Int()
    var height = Int()
    var offsetX = Int()
    var offsetY = Int()
    var allowOffscreen = Bool()
    var allowOrientationChange = Bool()
    var command2 = NSString()
    var state: MRAIDState?
    var isInterstitial = Bool()
    var useCustomClose = Bool()
    var orientationProperties = SKMRAIDOrientationProperties()
    var mraidParser:SKMRAIDView2?
    var modalVC=SKMRAIDModalViewController()
    var mraidjs = NSString()
    var mraidFeatures:NSArray?
    var supportedFeatures = NSArray()
    var webView = UIWebView()
    var webView2 = UIWebView()
    
    var webViewPart2: UIWebView?
    //var customWebView: UIWebView?
    var customWebView = UIWebView()
    
    var currentWebView = UIWebView()
    var checkUrlString = NSString()
    var closeEventRegion=UIButton()
    var resizeView: UIView?
    var resizeCloseRegion:UIButton?
    
    var tapGestureRecognizer: UITapGestureRecognizer?
    var bonafideTapObserved = Bool()
    var SK_ENABLE_JS_LOG = Bool()
    var SK_SUPPRESS_JS_ALERT = Bool()
    var SK_SUPPRESS_BANNER_AUTO_REDIRECT = Bool()
    var previousMaxSize:CGSize
    var previousScreenSize:CGSize
    var customClosePosition:SKMRAIDCustomClosePosition
    var baseURL: NSURL
    var resizeProperties:SKMRAIDView2?
    var serviceDelegate: SKMRAIDServiceDelegate?
    var skbrow: SKBrowser2?
    var absUrlString: NSString?
    var checkStr = NSString()
    var defoultStr = NSString()
    
    var heightView:CGFloat?
    
    
    public override init(frame: CGRect)
    {
        
        previousMaxSize = CGSize.zero
        previousScreenSize = CGSize.zero
        customClosePosition = SKMRAIDCustomClosePosition.MRAIDCustomClosePositionTopRight
        baseURL =  NSURL(string: "")!
        resizeProperties = nil
        serviceDelegate = nil
        absUrlString = nil
        SK_ENABLE_JS_LOG = false
        SK_SUPPRESS_JS_ALERT = true
        SK_SUPPRESS_BANNER_AUTO_REDIRECT = true
        
        width = 0
        height = 0
        offsetX = 0
        offsetY = 0
        
        allowOffscreen = true
        
        
        
        
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(didRotateFromInterfaceOrientation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
   public func initWithFrame(frame: CGRect, withHtmlData htmlData: NSString, withBaseURL bsURL: NSURL, supportedFeatures features: NSArray, delegate: SKMRAIDViewDelegate, serviceDelegate: SKMRAIDServiceDelegate, rootViewController: UIViewController) -> Any
    {
        return initWithFrame(frame: frame, withHtmlData: htmlData, withBaseURL: bsURL, supportedFeatures: features, asInterstitial: false, delegat: delegate, serviceDelegat: serviceDelegate, rootViewController: rootViewController)
    }
    
    func initWithFrame(frame: CGRect, withHtmlData htmlData: NSString, withBaseURL bsURL: NSURL, supportedFeatures currentFeatures: NSArray, asInterstitial isInter: Bool, delegat: SKMRAIDViewDelegate, serviceDelegat serviceDelegat: SKMRAIDServiceDelegate, rootViewController: UIViewController) -> Any
    {
        self .setUpTapGestureRecognizer()
        isInterstitial = isInter
        delegate = delegat
        serviceDelegate = serviceDelegat
        let rootViewController = rootViewController
        print(htmlData)
        state = MRAIDState.MRAIDStateLoading
        isViewable = false;
        useCustomClose = false
        
        mraidFeatures = [
            Constants.MRAIDSupportsSMS,
            Constants.MRAIDSupportsStorePicture,
            Constants.MRAIDSupportsInlineVideo,
        ]
        if (self .isValidFeatureSet(features: currentFeatures))
        {
            supportedFeatures = currentFeatures
        }
        
        webView.frame = CGRect(x: 0, y: 20, width: self.bounds.size.width, height: self.bounds.size.height)
        webView2.frame = CGRect(x: 0, y: 20, width: self.bounds.size.width, height: self.bounds.size.height)
        
        
        screenWebHeight = self.bounds.size.height
        print("webView Frame Loading Time====\(webView.frame)")
        print("webView Frame screenWebHeight====\(screenWebHeight)")
        
        self .initWebView(wv: webView)
        currentWebView = webView
        self.addSubview(currentWebView)
        
        previousMaxSize = CGSize.zero
        previousScreenSize = CGSize.zero
        let url: NSURL = NSURL(string: "http://hexims.it/work/inspire/mraid.js")!
        var mraiddatajs = Data()
        
        do {
            mraiddatajs = try NSData(contentsOf: url as URL) as Data
            print(mraiddatajs as Any)
        } catch
        {
            print(error)
        }
        
        mraidjs = NSString(data: mraiddatajs, encoding: String.Encoding.utf8.rawValue)!
        baseURL = bsURL
        print(baseURL)
        var ssss = NSString()
        ssss = mraidjs
        
        state = MRAIDState.MRAIDStateLoading
        
        if (ssss != "")
        {
            self .injectJavaScript(js: ssss)
        }
        
        currentWebView .loadHTMLString("", baseURL: baseURL as URL)
        var htmlData1 = NSString()
        
        htmlData1 = self .processRawHtml(rawHtml: htmlData)
        print(baseURL)
        let urlll: URL = baseURL as URL
        print(urlll)
        
        if (htmlData1 != "")
        {
            currentWebView .loadHTMLString(htmlData1 as String, baseURL: urlll)
        }
        else
        {
            SkLogger .error(tag: "MRAID - View", withMessage: "Ad HTML is invalid, cannot load")
            
            if(self.delegate .responds(to: #selector(mraidViewAdFailed(mraidView:))))
            {
                self .delegate .mraidViewAdFailed(mraidView: self)
            }
        }
        if (isInter)
        {
            bonafideTapObserved = true
        }
        return self
    }
    func checkCallFunct()
    {
        wkWebView = WKWebView(frame: webView.bounds, configuration: WKWebViewConfiguration())
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
        self.addSubview(wkWebView!)
        let url = URL(string: "https://www.w3schools.com/jsref/tryit.asp?filename=tryjsref_alert")!
        wkWebView.load(URLRequest(url: url))
    }
    
    func setUpTapGestureRecognizer()
    {
        if (!SK_SUPPRESS_BANNER_AUTO_REDIRECT)
        {
            return
        }
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(oneFingerOneTap(_:)))
        tapGestureRecognizer? .numberOfTapsRequired = 1
        tapGestureRecognizer? .numberOfTouchesRequired = 1
        tapGestureRecognizer? .delegate = self
        self .addGestureRecognizer(tapGestureRecognizer!)
    }
    
    func cancel()
    {
        SkLogger .debug(tag: "MRAID - View", withMessage: "cancel")
        currentWebView .stopLoading()
        UIDevice .current .endGeneratingDeviceOrientationNotifications()
    }
    
    deinit
    {
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "%@ %@", self.description,NSStringFromSelector(#function)) as NSString)
        
        NotificationCenter.default.removeObserver(self)
        UIDevice .current .endGeneratingDeviceOrientationNotifications()
        
        webViewPart2 = nil
        mraidParser = nil
        mraidFeatures = nil
        resizeView = nil
        resizeCloseRegion = nil
    }
    
    func isValidFeatureSet(features: NSArray) -> Bool
    {
        var kFeatures = NSArray()
        kFeatures = [Constants.MRAIDSupportsSMS,
                     Constants.MRAIDSupportsStorePicture,
                     Constants.MRAIDSupportsInlineVideo,
        ]
        
        let feature = (Any).self
        print(feature)
        for feature in features
        {
            if(!(kFeatures .contains(feature)))
            {
                SkLogger .warning(tag: "MRAID - View", withMessage: String(format: "feature %@ is unknown, no supports set",feature as! CVarArg) as NSString)
                return false
            }
        }
        print(feature)
        
        return true
    }
    
    func setIsViewable(newIsViewable: Bool)
    {
        if (newIsViewable != isViewable)
        {
            isViewable = newIsViewable
            self .fireViewableChangeEvent()
        }
        //  SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "isViewable: %@", isViewable! as  NSNumber,(value: true) as! CVarArg) as NSString)
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "isViewable: %@", isViewable! as CVarArg) as NSString)
        
    }
    
    func isViewable1() -> Bool
    {
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "%@ %@", self.description,NSStringFromSelector(#function)) as NSString)
        return _isViewable!
    }
    
    func setRootViewController(newRootViewController: UIViewController)
    {
        if newRootViewController != newRootViewController
        {
            rootViewController = newRootViewController
        }
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "%@ %@", self.description,NSStringFromSelector(#function)) as NSString)
    }
    
    @objc func deviceOrientationDidChange(notification: NSNotification)
    {
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "%@ %@", self.description,NSStringFromSelector(#function)) as NSString)
        
        self .setScreenSize()
        self .setMaxSize()
        self .setDefaultPosition()
    }
    
    func observeValueForKeyPath(keyPath: NSString, ofObject object: Any, change: NSDictionary, context: CGFunction)
    {
        if (!(keyPath .isEqual(to: "self.frame")))
        {
            return
        }
        SkLogger .debug(tag: "MRAID - View", withMessage: "self.frame has changed")
        
        var oldFrame = CGRect()
        var newFrame = CGRect()
        oldFrame = CGRect.null
        newFrame = CGRect.null
        
        if change["old"] != nil
        {
            oldFrame = change .value(forKey: "old") as! CGRect
        }
        if (((object as AnyObject).value(forKeyPath: keyPath as String)) != nil)
        {
            newFrame = ((object as AnyObject) .value(forKeyPath: keyPath as String) as! CGRect)
        }
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "old %@",NSStringFromCGRect(oldFrame)) as NSString)
        
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "new %@",NSStringFromCGRect(newFrame)) as NSString)
        
        if (state == MRAIDState.MRAIDStateResized)
        {
            self .setResizeViewPosition()
        }
        self .setDefaultPosition()
        self .setMaxSize()
        self .fireViewableChangeEvent()
    }
    
    func setBackgroundColor(backgroundColor: UIColor)
    {
        self .setBackgroundColor(backgroundColor: backgroundColor)
        currentWebView.backgroundColor = backgroundColor
    }
    
    @objc func showAsInterstitial()
    {
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "%@", self.description,NSStringFromSelector(#function)) as NSString)
        self .expand(urlString: "")
    }
    
    @objc func close()
    {
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "JS callback %@",NSStringFromSelector(#function)) as NSString)
        
        //        if (state == MRAIDState.MRAIDStateLoading || (state == MRAIDState.MRAIDStateDefault && !isInterstitial) || state == MRAIDState.MRAIDStateHidden)
        //        {
        //            return
        //        }
        if (state == MRAIDState.MRAIDStateResized)
        {
            self .closeFromResize()
            return
        }
        
        if ((modalVC) != nil)
        {
            closeEventRegion .removeFromSuperview()
            //closeEventRegion = nil
            currentWebView .removeFromSuperview()
            
            if(modalVC .responds(to: #selector(modalVC .dismiss(animated:completion:))))
            {
                DispatchQueue.main.async {
                    self.modalVC .dismiss(animated: false, completion: nil)
                    //self.webView.frame = frame
                    //self.webView .removeFromSuperview()
                }
            }
            else
            {
                self.modalVC .dismiss(animated: false, completion: nil)
            }
        }
        
        if ((webViewPart2) != nil)
        {
            webViewPart2?.delegate = self
            currentWebView = webView
            webViewPart2 = nil
            //webViewPart2? .removeFromSuperview()
        }
        else
        {
            webView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: screenWebHeight+20)
        }
        self .addSubview(webView)
        
        if (!isInterstitial)
        {
            self .fireSizeChangeEvent()
        }
        else
        {
            self.isViewable = false
            self .fireViewableChangeEvent()
        }
        
        if (state == MRAIDState.MRAIDStateDefault && isInterstitial)
        {
            state = MRAIDState.MRAIDStateHidden
        }
        else if (state == MRAIDState.MRAIDStateExpanded || state == MRAIDState.MRAIDStateResized)
        {
            state = MRAIDState.MRAIDStateDefault
        }
        self .fireViewableChangeEvent()
        self .delegate .mraidViewDidClose(mraidView: self)
    }
    
    @objc func closeFromResize()
    {
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "JS callback helper %@",NSStringFromSelector(#function)) as NSString)
        
        self .removeResizeCloseRegion()
        state = MRAIDState.MRAIDStateDefault
        self .fireStateChangeEvent()
        webView .removeFromSuperview()
        webView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        self .addSubview(webView)
        resizeView? .removeFromSuperview()
        resizeView = nil
        self .fireSizeChangeEvent()
        
        if (self.delegate .responds(to: #selector(mraidViewDidClose(mraidView:))))
        {
            self.delegate .mraidViewDidClose(mraidView: self)
        }
    }
    
    func createCalendarEvent( eventJSON: NSString)
    {
        if (!bonafideTapObserved && SK_SUPPRESS_BANNER_AUTO_REDIRECT)
        {
            SkLogger .info(tag: "MRAID - View", withMessage: "Suppressing an attempt to programmatically call mraid.createCalendarEvent() when no UI touch event exists.")
            return
        }
        
        let eventJSON = eventJSON.addingPercentEscapes(using: String.Encoding.utf8.rawValue)
        
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "JS callback %@ %@",NSStringFromSelector(#function),eventJSON!) as NSString)
    }
    
    @objc func didRotateFromInterfaceOrientation(fromInterfaceOrientation: NSNotification)
    {
        print("ratval  m\(checkStr)")
        
        if (checkStr == "")
        {
            if UIDevice().userInterfaceIdiom == .pad
            {
                let interfaceOrientation: UIInterfaceOrientation = UIApplication .shared .statusBarOrientation
                let isLandscape: Bool = UIInterfaceOrientationIsLandscape(interfaceOrientation)
                heightView = nil
                self .deviceFramingCentre()
            }
            else
            {
                let interfaceOrientation: UIInterfaceOrientation = UIApplication .shared .statusBarOrientation
                let isLandscape: Bool = UIInterfaceOrientationIsLandscape(interfaceOrientation)
                if(isLandscape)
                {
                    if UIDevice().userInterfaceIdiom == .phone
                    {
                        switch UIScreen.main.bounds.size.width
                        {
                        case 480:
                            print("iPhone 4S")
                            self.frame = CGRect(x: 0, y: 0, width: 480, height: screenWebHeight)
                            webView.frame = CGRect(x: 0, y: 0, width: 480, height: screenWebHeight)
                        case 568:
                            print("iPhone 5")
                            self.frame = CGRect(x: 0, y: 0, width: 568, height: screenWebHeight)
                            webView.frame = CGRect(x: 0, y: 0, width: 568, height: screenWebHeight)
                        case 667:
                            print("iPhone 6")
                            self.frame = CGRect(x: 0, y: 0, width: 667, height: screenWebHeight)
                            webView.frame = CGRect(x: 0, y: 0, width: 667, height: screenWebHeight)
                        case 736:
                            print("iPhone 6 plus")
                            self.frame = CGRect(x: 0, y: 0, width: 736, height: screenWebHeight)
                            webView.frame = CGRect(x: 0, y: 0, width: 736, height: screenWebHeight)
                        case 812:
                            print("iPhone x")
                            //                            self.frame = CGRect(x: 0, y: 0, width: 812, height: self.bounds.size.height)
                            //                            webView.frame = CGRect(x: 0, y: 0, width: 812, height: self.bounds.size.height)
                            self.frame = CGRect(x: 0, y: 20, width: 812, height: screenWebHeight)
                            webView.frame = CGRect(x: 0, y: 20, width: 812, height: screenWebHeight)
                        default:
                            print("other models")
                        }
                    }
                }
                else
                {
                    if UIDevice().userInterfaceIdiom == .phone
                    {
                        switch UIScreen.main.bounds.size.height
                        {
                        case 480:
                            print("iPhone 4S")
                            self.frame = CGRect(x: 0, y: 0, width: 320, height: screenWebHeight)
                            webView.frame = CGRect(x: 0, y: 0, width: 320, height: screenWebHeight)
                        case 568:
                            print("iPhone 5")
                            self.frame = CGRect(x: 0, y: 0, width: 320, height: screenWebHeight)
                            webView.frame = CGRect(x: 0, y: 0, width: 320, height: screenWebHeight)
                        case 667:
                            print("iPhone 6")
                            self.frame = CGRect(x: 0, y: 0, width: 375, height: screenWebHeight)
                            webView.frame = CGRect(x: 0, y: 0, width: 375, height: screenWebHeight)
                        case 736:
                            print("iPhone 6 plus")
                            self.frame = CGRect(x: 0, y: 0, width: 414, height: screenWebHeight)
                            webView.frame = CGRect(x: 0, y: 0, width: 414, height: screenWebHeight)
                        case 812:
                            print("iPhone x")
                            self.frame = CGRect(x: 0, y: 20, width: 375, height: screenWebHeight)
                            webView.frame = CGRect(x: 0, y: 20, width: 375, height: screenWebHeight)
                        default:
                            print("other models")
                        }
                    }
                }
            }
        }
        else
        {
            print("no found url")
            
            let interfaceOrientation: UIInterfaceOrientation = UIApplication .shared .statusBarOrientation
            let isLandscape: Bool = UIInterfaceOrientationIsLandscape(interfaceOrientation)
            
            if UIDevice().userInterfaceIdiom == .pad
            {
                self .i_PAD_deviceFraming()
            }
            else
            {
                if(isLandscape)
                {
                    if UIDevice().userInterfaceIdiom == .phone
                    {
                        switch UIScreen.main.bounds.size.width
                        {
                        case 480:
                            print("iPhone 4S")
                            self.frame = CGRect(x: 0, y: 0, width: 480, height: 320)
                            webView.frame = CGRect(x: 0, y: 0, width: 480, height: 320)
                        case 568:
                            print("iPhone 5")
                            self.frame = CGRect(x: 0, y: 0, width: 568, height: 320)
                            webView.frame = CGRect(x: 0, y: 0, width: 568, height: 320)
                        case 667:
                            print("iPhone 6")
                            self.frame = CGRect(x: 0, y: 0, width: 667, height: 375)
                            webView.frame = CGRect(x: 0, y: 0, width: 667, height: 375)
                        case 736:
                            print("iPhone 6 plus")
                            self.frame = CGRect(x: 0, y: 0, width: 736, height: 414)
                            webView.frame = CGRect(x: 0, y: 0, width: 736, height: 414)
                        case 812:
                            print("iPhone x")
                            self.frame = CGRect(x: 0, y: 0, width: 812, height: 375)
                            webView.frame = CGRect(x: 0, y: 0, width: 812, height: 375)
                        default:
                            print("other models")
                        }
                    }
                }
                else
                {
                    if UIDevice().userInterfaceIdiom == .phone
                    {
                        switch UIScreen.main.bounds.size.height
                        {
                        case 480:
                            print("iPhone 4S")
                            self.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
                            webView.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
                        case 568:
                            print("iPhone 5")
                            self.frame = CGRect(x: 0, y: 0, width: 320, height: 568)
                            webView.frame = CGRect(x: 0, y: 0, width: 320, height: 568)
                        case 667:
                            print("iPhone 6")
                            self.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
                            webView.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
                        case 736:
                            print("iPhone 6 plus")
                            self.frame = CGRect(x: 0, y: 0, width: 414, height: 736)
                            webView.frame = CGRect(x: 0, y: 0, width: 414, height: 736)
                        case 812:
                            print("iPhone x")
                            self.frame = CGRect(x: 0, y: 0, width: 375, height: 812)
                            webView.frame = CGRect(x: 0, y: 0, width: 375, height: 812)
                        default:
                            print("other models")
                        }
                    }
                }
            }
            webView.scalesPageToFit = true
            webView.scrollView.isScrollEnabled = true
            webView .delegate = self
        }
    }
    
    func i_PAD_deviceFraming()
    {
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft
        {
            if DeviceType.IS_IPAD
            {
                self.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
                webView.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
            }
            else if DeviceType.IS_IPAD_PRO_10_5
            {
                self.frame = CGRect(x: 0, y: 0, width: 1112, height: 834)
                webView.frame = CGRect(x: 0, y: 0, width: 1112, height: 834)
            }
            else if DeviceType.IS_IPAD_PRO_12_9
            {
                self.frame = CGRect(x: 0, y: 0, width: 1366, height: 1024)
                webView.frame = CGRect(x: 0, y: 0, width: 1366, height: 1024)
            }
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight
        {
            if DeviceType.IS_IPAD
            {
                self.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
                webView.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
            }
            else if DeviceType.IS_IPAD_PRO_10_5
            {
                self.frame = CGRect(x: 0, y: 0, width: 1112, height: 834)
                webView.frame = CGRect(x: 0, y: 0, width: 1112, height: 834)
            }
            else if DeviceType.IS_IPAD_PRO_12_9
            {
                self.frame = CGRect(x: 0, y: 0, width: 1366, height: 1024)
                webView.frame = CGRect(x: 0, y: 0, width: 1366, height: 1024)
            }
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.portrait
        {
            if DeviceType.IS_IPAD
            {
                self.frame = CGRect(x: 0, y: 0, width: 768, height: 1024)
                webView.frame = CGRect(x: 0, y: 0, width: 768, height: 1024)
            }
            else if DeviceType.IS_IPAD_PRO_10_5
            {
                self.frame = CGRect(x: 0, y: 0, width: 834, height: 1112)
                webView.frame = CGRect(x: 0, y: 0, width: 834, height: 1112)
            }
            else if DeviceType.IS_IPAD_PRO_12_9
            {
                self.frame = CGRect(x: 0, y: 0, width: 1024, height: 1366)
                webView.frame = CGRect(x: 0, y: 0, width: 1024, height: 1366)
            }
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown
        {
            if DeviceType.IS_IPAD
            {
                self.frame = CGRect(x: 0, y: 0, width: 768, height: 1024)
                webView.frame = CGRect(x: 0, y: 0, width: 768, height: 1024)
            }
            else if DeviceType.IS_IPAD_PRO_10_5
            {
                self.frame = CGRect(x: 0, y: 0, width: 834, height: 1112)
                webView.frame = CGRect(x: 0, y: 0, width: 834, height: 1112)
            }
            else if DeviceType.IS_IPAD_PRO_12_9
            {
                self.frame = CGRect(x: 0, y: 0, width: 1024, height: 1366)
                webView.frame = CGRect(x: 0, y: 0, width: 1024, height: 1366)
            }
        }
    }
    
    
    func deviceFramingCentre()
    {
        print("ritation Time Web Framing == \(webView.frame)")
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft
        {
            if DeviceType.IS_IPAD
            {
                self.frame = CGRect(x: 0, y: 50, width: 1024, height: screenWebHeight)
                webView.frame = CGRect(x: 0, y: 0, width: 1024, height: screenWebHeight)
            }
            else if DeviceType.IS_IPAD_PRO_10_5
            {
                self.frame = CGRect(x: 0, y: 50, width: 1112, height: screenWebHeight)
                webView.frame = CGRect(x: 0, y: 0, width: 1112, height: screenWebHeight)
            }
            else if DeviceType.IS_IPAD_PRO_12_9
            {
                self.frame = CGRect(x: 0, y: 50, width: 1366, height: screenWebHeight)
                webView.frame = CGRect(x: 0, y: 0, width: 1366, height: screenWebHeight)
            }
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight
        {
            if DeviceType.IS_IPAD
            {
                self.frame = CGRect(x: 0, y: 50, width: 1024, height: screenWebHeight)
                webView.frame = CGRect(x: 0, y: 0, width: 1024, height: screenWebHeight)
            }
            else if DeviceType.IS_IPAD_PRO_10_5
            {
                self.frame = CGRect(x: 0, y: 50, width: 1112, height: screenWebHeight)
                webView.frame = CGRect(x: 0, y: 0, width: 1112, height: screenWebHeight)
            }
            else if DeviceType.IS_IPAD_PRO_12_9
            {
                self.frame = CGRect(x: 0, y: 50, width: 1366, height: screenWebHeight)
                webView.frame = CGRect(x: 0, y: 0, width: 1366, height: screenWebHeight)
            }
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.portrait
        {
            if DeviceType.IS_IPAD
            {
                self.frame = CGRect(x: 0, y: 50, width: 768, height: screenWebHeight)
                webView.frame = CGRect(x: 0, y: 0, width: 768, height: screenWebHeight)
            }
            else if DeviceType.IS_IPAD_PRO_10_5
            {
                self.frame = CGRect(x: 0, y: 50, width: 834, height: screenWebHeight)
                webView.frame = CGRect(x: 0, y: 0, width: 834, height: screenWebHeight)
            }
            else if DeviceType.IS_IPAD_PRO_12_9
            {
                self.frame = CGRect(x: 0, y: 50, width: 1024, height: screenWebHeight)
                webView.frame = CGRect(x: 0, y: 0, width: 1024, height: screenWebHeight)
            }
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown
        {
            if DeviceType.IS_IPAD
            {
                self.frame = CGRect(x: 0, y: 50, width: 768, height: screenWebHeight)
                webView.frame = CGRect(x: 0, y: 0, width: 768, height: screenWebHeight)
            }
            else if DeviceType.IS_IPAD_PRO_10_5
            {
                self.frame = CGRect(x: 0, y: 50, width: 834, height: screenWebHeight)
                webView.frame = CGRect(x: 0, y: 0, width: 834, height: screenWebHeight)
            }
            else if DeviceType.IS_IPAD_PRO_12_9
            {
                self.frame = CGRect(x: 0, y: 50, width: 1024, height: screenWebHeight)
                webView.frame = CGRect(x: 0, y: 0, width: 1024, height: screenWebHeight)
            }
        }
    }
    //screenWebHeight == self.bounds.size.height
    func expand(urlString: NSString)
        
    {
        if (!bonafideTapObserved && SK_SUPPRESS_BANNER_AUTO_REDIRECT)
        {
            SkLogger .info(tag: "MRAID - View", withMessage: "Suppressing an attempt to programmatically call mraid.expand() when no UI touch event exists.")
            return
        }
        
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "JS callback %@ %@",NSStringFromSelector(#function),urlString) as NSString)
        
        if (state != MRAIDState.MRAIDStateDefault && state != MRAIDState.MRAIDStateResized)
        {
            return
        }
        modalVC = modalVC .initWithOrientationProperties(orientationProps: orientationProperties) as! SKMRAIDModalViewController
        
        let frame: CGRect = UIScreen .main .bounds
        modalVC.view.frame = frame
        modalVC.delegate = self
        
        if !(urlString).boolValue
        {
            webView.frame = frame
            webView .removeFromSuperview()
        }
        else
        {
            webViewPart2?.frame = frame
            self .initWebView(wv: webViewPart2!)
            currentWebView = webViewPart2!
            bonafideTapObserved = true
            
            if(mraidjs).boolValue
            {
                self .injectJavaScript(js: mraidjs)
            }
            let urlString1 = urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)
            var urlString2 = NSString()
            
            if ((NSURL(string:urlString1 as! String)? .scheme) != nil)
            {
                var str1 = NSString()
                str1 =  baseURL .absoluteString! as NSString
                
                var strrr = NSString()
                strrr = str1.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                
                var str2 = NSString()
                str2 = strrr.appending(urlString as String) as NSString
                
                urlString2 = str2
            }
            let urlString3 = urlString2.addingPercentEscapes(using: String.Encoding.utf8.rawValue)
            
            var content = NSString()
            do {
                content = (try String(contentsOf: NSURL(string:urlString3 as! String)! as URL) as NSString)
                webViewPart2? .loadHTMLString(content as String, baseURL: baseURL as URL)
                
            } catch {
                print(error)
                SkLogger .error(tag: "MRAID - View", withMessage: String(format: "Could not load part 2 expanded content for URL: %@",urlString3!) as NSString)
                
                currentWebView = webView
                webViewPart2?.delegate = nil
                webViewPart2 = nil
                return
            }
        }
        self.delegate .mraidViewWillExpand(mraidView: self)
        
        modalVC.view .addSubview(currentWebView)
        
        self .addCloseEventRegion()
        
        if (self.rootViewController .responds(to: #selector(self.rootViewController .present(_:animated:completion:))))
        {
            if(IOSVersion.SYSTEM_VERSION_LESS_THAN(version: "8.0"))
            {
                self.rootViewController .navigationController? .modalPresentationStyle = UIModalPresentationStyle.currentContext
            }
            else
            {
                modalVC .modalPresentationStyle = UIModalPresentationStyle.fullScreen
            }
            let topController = UIApplication.shared.keyWindow?.rootViewController
            topController? .present(modalVC, animated: true, completion: nil)
        }
        else
        {
            let topController = UIApplication.shared.keyWindow?.rootViewController
            topController? .present(modalVC, animated: true, completion: nil)
        }
        
        if (!isInterstitial)
        {
            state = MRAIDState.MRAIDStateExpanded
            self .fireStateChangeEvent()
            webView.scalesPageToFit = true
            webView.scrollView.isScrollEnabled = true
            webView .delegate = self
            let scrollPoint = CGPoint(x: 0, y: webView.scrollView.contentSize.height - webView.frame.size.height)
            webView.scrollView.setContentOffset(scrollPoint, animated: true)
        }
        self .fireSizeChangeEvent()
        self.isViewable = true
    }
    
    func open()
    {
        
        if (!bonafideTapObserved && SK_SUPPRESS_BANNER_AUTO_REDIRECT)
        {
            SkLogger .info(tag: "MRAID - View", withMessage: "Suppressing an attempt to programmatically call mraid.open() when no UI touch event exists.")
            return
        }
        
        let urlString = command2 .replacingPercentEscapes(using: String.Encoding.utf8.rawValue)
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "JS callback %@ %@",NSStringFromSelector(#function),urlString!) as NSString)
        
        self.serviceDelegate? .mraidServiceOpenBrowserWithUrlString(urlString: urlString! as NSString)
    }
    
    @objc public func mraidServiceOpenBrowserWithUrlString(urlString: NSString)
    {
    }
    
    open  func playVideo(urlString: NSString)
    {
        if (!bonafideTapObserved && SK_SUPPRESS_BANNER_AUTO_REDIRECT) {
            SkLogger .info(tag: "MRAID - View", withMessage: "Suppressing an attempt to programmatically call mraid.playVideo() when no UI touch event exists.")
            return
        }
        let urlString = urlString .replacingPercentEscapes(using: String.Encoding.utf8.rawValue)
        
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "JS callback %@ %@", NSStringFromSelector(#function),urlString!) as NSString)
        
    }
    
    
    @objc func mraidViewShouldResize(mraidView: SKMRAIDView2, toPosition position: CGRect, allowOffscreen: Bool) -> Bool
    {
        return true
    }
    
    func resize()
    {
        if (!bonafideTapObserved && SK_SUPPRESS_BANNER_AUTO_REDIRECT)
        {
            SkLogger .info(tag: "MRAID - View", withMessage: "Suppressing an attempt to programmatically call mraid.resize when no UI touch event exists.")
        }
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "JS callback %@", NSStringFromSelector(#function)) as NSString)
        
        
        if(self.delegate .responds(to: #selector(self .mraidViewShouldResize(mraidView:toPosition:allowOffscreen:))))
        {
            return
        }
        
        var resizeFrame: CGRect = CGRect(x: (resizeProperties!.offsetX), y: (resizeProperties!.offsetY), width: (resizeProperties!.width), height: (resizeProperties!.height))
        let bannerOriginInRootView: CGPoint = self.rootViewController.view .convert(CGPoint.zero, from: self)
        resizeFrame.origin.x += bannerOriginInRootView.x
        resizeFrame.origin.y += bannerOriginInRootView.y
        
        if !(self .delegate .mraidViewShouldResize(mraidView: self, toPosition: resizeFrame, allowOffscreen: (resizeProperties?.allowOffscreen)!))
        {
            return
        }
        
        state = MRAIDState.MRAIDStateResized
        self .fireStateChangeEvent()
        
        if (!(resizeView != nil))
        {
            resizeView = UIView.init(frame: resizeFrame)
            webView .removeFromSuperview()
            resizeView? .addSubview(webView)
            self.rootViewController.view .addSubview(resizeView!)
        }
        resizeView?.frame = resizeFrame
        webView.frame = (resizeView?.bounds)!
        self .showResizeCloseRegion()
        self .fireSizeChangeEvent()
    }
    
    func setOrientationProperties(properties: NSDictionary)
    {
        let allowOrientationChange: Bool = (properties .value(forKey: "allowOrientationChange") != nil)
        let forceOrientation: NSString = properties .value(forKey: "forceOrientation") as! NSString
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "JS callback %@ %@ %@", NSStringFromSelector(#function), allowOrientationChange as CVarArg, forceOrientation) as NSString)
        
        orientationProperties.allowOrientationChange = allowOrientationChange
        orientationProperties .forceOrientation = MRAIDForceOrientationFromString(s: forceOrientation)
    }
    
    func setResizeProperties(properties: NSDictionary)
    {
        let width: Int = properties .value(forKey: "width") as! Int
        let height: Int = properties .value(forKey: "height") as! Int
        let offsetX: Int = properties .value(forKey: "offsetX") as! Int
        let offsetY: Int = properties .value(forKey: "offsetY") as! Int
        let customClosePosition: NSString = properties .value(forKey: "customClosePosition") as! NSString
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "JS callback %@ %d %d %d %d %@ %@", NSStringFromSelector(#function), width, height, offsetX, offsetY, customClosePosition as CVarArg, allowOffscreen as CVarArg) as NSString)
        
        resizeProperties?.width = width
        resizeProperties?.height = height
        resizeProperties?.offsetX = offsetX
        resizeProperties?.offsetY = offsetY
        resizeProperties?.customClosePosition = (resizeProperties? .MRAIDCustomClosePositionFromString(s: customClosePosition))!
        resizeProperties?.allowOffscreen = allowOffscreen
    }
    
    func MRAIDForceOrientationFromString(s: NSString) -> SKMRAIDForceOrientation
    {
        return SKMRAIDForceOrientation.MRAIDForceOrientationPortrait
    }
    
    func storePicture(urlString: NSString)
    {
        if (!bonafideTapObserved && SK_SUPPRESS_BANNER_AUTO_REDIRECT)
        {
            SkLogger .info(tag: "MRAID - View", withMessage: "Suppressing an attempt to programmatically call mraid.storePicture when no UI touch event exists.")
            return
        }
        let urlString = urlString .replacingPercentEscapes(using: String.Encoding.utf8.rawValue)
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "JS callback %@ %@", NSStringFromSelector(#function), urlString!) as NSString)
        
        if (supportedFeatures .contains(Constants.MRAIDSupportsStorePicture))
        {
            if(self.serviceDelegate? .responds(to: #selector(self .mraidServiceStorePictureWithUrlString(urlString:))))!
            {
                self .serviceDelegate? .mraidServiceStorePictureWithUrlString(urlString: urlString! as NSString)
            }
        }
        else
        {
            SkLogger .warning(tag: "MRAID - View", withMessage: String(format: "No MRAIDSupportsStorePicture feature has been included") as NSString)
        }
    }
    
    func useCustomClose(isCustomCloseString: NSString)
    {
        let isCustomClose: Bool = isCustomCloseString .boolValue
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "JS callback %@ %@", NSStringFromSelector(#function), isCustomClose as CVarArg) as NSString)
        useCustomClose = isCustomClose
    }
    
    func addCloseEventRegion()
    {
        closeEventRegion   = UIButton(type: UIButtonType.custom) as UIButton
        closeEventRegion.backgroundColor = UIColor .clear
        closeEventRegion.addTarget(self, action: #selector(close), for:.touchUpInside)
        
        if (!useCustomClose)
        {
            if isInterstitial
            {
                let image3 = UIImage(named: "close.png", in: Bundle(for: SKMRAIDView2.self), compatibleWith: nil)

                var closeButtonImage = UIImage()
                closeButtonImage = UIImage(named: "close.png")!
                //closeEventRegion.setBackgroundImage(closeButtonImage, for: .normal)
                closeEventRegion.setBackgroundImage(image3, for: .normal)

            }
        }
        closeEventRegion.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        var frame: CGRect = (closeEventRegion.frame)
        
        let width1: CGFloat = modalVC.view.frame.width
        let width2: CGFloat = frame.width
        
        var x = Int()
        x = Int(width1 - width2)
        
        frame.origin = CGPoint(x: x, y: 20)
        closeEventRegion.frame = frame
        closeEventRegion.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleLeftMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleBottomMargin.rawValue)))
        modalVC.view.addSubview(closeEventRegion)
    }
    
    func synchronized<T>(_ lock: AnyObject, _ body: () throws -> T) rethrows -> T {
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        return try body()
    }
    
    func showResizeCloseRegion()
    {
        if (resizeCloseRegion != nil)
        {
            resizeCloseRegion? = UIButton(type: UIButtonType.custom) as UIButton
            resizeCloseRegion?.backgroundColor = UIColor .clear
            resizeCloseRegion?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            resizeCloseRegion?.addTarget(self, action: #selector(closeFromResize), for:.touchUpInside)
            resizeView? .addSubview((resizeCloseRegion)!)
        }
        var x = Int()
        var y = Int()
        
        var autoresizingMask = UIViewAutoresizing()
        
        switch resizeProperties! .customClosePosition
        {
        case SKMRAIDCustomClosePosition.MRAIDCustomClosePositionTopLeft:
            print("Left")
        case SKMRAIDCustomClosePosition.MRAIDCustomClosePositionBottomLeft:
            x = 0
            break
        case SKMRAIDCustomClosePosition.MRAIDCustomClosePositionTopCenter: break
        case SKMRAIDCustomClosePosition.MRAIDCustomClosePositionCenter: break
        case SKMRAIDCustomClosePosition.MRAIDCustomClosePositionBottomCenter:
            
            let resizeViewWidth1: CGFloat = (resizeView?.frame.width)!
            let resizeCloseRegionWidth1: CGFloat = (resizeCloseRegion?.frame.width)!
            x = Int(resizeViewWidth1 - resizeCloseRegionWidth1) / 2
            
            autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleLeftMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleRightMargin.rawValue)))
            break
        case SKMRAIDCustomClosePosition.MRAIDCustomClosePositionTopRight: break
        case SKMRAIDCustomClosePosition.MRAIDCustomClosePositionBottomRight:
            
            let resizeViewWidth: CGFloat = (resizeView?.frame.width)!
            let resizeCloseRegionWidth: CGFloat = (resizeCloseRegion?.frame.width)!
            x = Int(resizeViewWidth - resizeCloseRegionWidth)
            autoresizingMask = UIViewAutoresizing.flexibleLeftMargin
            
            break
        }
        
        switch resizeProperties! .customClosePosition
        {
        case SKMRAIDCustomClosePosition.MRAIDCustomClosePositionTopLeft: break
        case SKMRAIDCustomClosePosition.MRAIDCustomClosePositionTopCenter: break
        case SKMRAIDCustomClosePosition.MRAIDCustomClosePositionTopRight:
            y = 0
            break
        case SKMRAIDCustomClosePosition.MRAIDCustomClosePositionCenter:
            
            let resizeViewHeight1: CGFloat = (resizeView?.frame.height)!
            let resizeCloseRegionHeight1: CGFloat = (resizeCloseRegion?.frame.height)!
            y = Int(resizeViewHeight1 - resizeCloseRegionHeight1) / 2
            autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(autoresizingMask.rawValue) | (UInt8(UIViewAutoresizing.flexibleTopMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleBottomMargin.rawValue))))
            break
            
        case SKMRAIDCustomClosePosition.MRAIDCustomClosePositionBottomLeft: break
        case SKMRAIDCustomClosePosition.MRAIDCustomClosePositionBottomCenter: break
        case SKMRAIDCustomClosePosition.MRAIDCustomClosePositionBottomRight:
            
            let resizeViewHeight: CGFloat = (resizeView?.frame.height)!
            let resizeCloseRegionHeight: CGFloat = (resizeCloseRegion?.frame.height)!
            y = Int(resizeViewHeight - resizeCloseRegionHeight)
            autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(autoresizingMask.rawValue) | UInt8(UIViewAutoresizing.flexibleTopMargin.rawValue)))
            
            break
        }
        var resizeCloseRegionFrame: CGRect = resizeCloseRegion!.frame
        resizeCloseRegionFrame.origin = CGPoint(x: x, y: y)
        resizeCloseRegion?.frame = resizeCloseRegionFrame
        resizeCloseRegion?.autoresizingMask = autoresizingMask
    }
    
    func removeResizeCloseRegion()
    {
        if ((resizeCloseRegion) != nil)
        {
            resizeCloseRegion? .removeFromSuperview()
            resizeCloseRegion = nil
        }
    }
    
    func setResizeViewPosition()
    {
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "%@",NSStringFromSelector(#function)) as NSString)
        
        let oldResizeFrame: CGRect = resizeView!.frame
        var newResizeFrame: CGRect = CGRect(x: resizeProperties!.offsetX, y: resizeProperties!.offsetY, width: resizeProperties!.width, height: resizeProperties!.height)
        
        let bannerOriginInRootView: CGPoint = self.rootViewController.view .convert(CGPoint.zero, from: self)
        newResizeFrame.origin.x += bannerOriginInRootView.x
        newResizeFrame.origin.y += bannerOriginInRootView.y
        
        if !(oldResizeFrame .equalTo(newResizeFrame))
        {
            resizeView?.frame = newResizeFrame
        }
    }
    
    func injectJavaScript(js: NSString)
    {
        currentWebView .stringByEvaluatingJavaScript(from: js as String)
    }
    
    func fireErrorEventWithAction(action: NSString, message: NSString)
    {
        self .injectJavaScript(js: String(format: "mraid.fireErrorEvent('%@','%@');", message, action) as NSString)
    }
    
    func fireReadyEvent()
    {
        self .injectJavaScript(js: "mraid.fireReadyEvent()")
    }
    
    func fireSizeChangeEvent()
    {
        var x = Int()
        var y = Int()
        var width = Int()
        var height = Int()
        
        if (state == MRAIDState.MRAIDStateExpanded || isInterstitial)
        {
            x = Int(currentWebView.frame.origin.x)
            y = Int(currentWebView.frame.origin.y)
            width = Int(currentWebView.frame.size.width)
            height = Int(currentWebView.frame.size.height)
        }
        else if (state == MRAIDState.MRAIDStateResized)
        {
            x = Int((resizeView?.frame.origin.x)!)
            y = Int((resizeView?.frame.origin.y)!)
            width = Int((resizeView?.frame.size.width)!)
            height = Int((resizeView?.frame.size.height)!)
        }
        else
        {
            let originInRootView: CGPoint = self.rootViewController.view .convert(CGPoint.zero, from: self)
            x = Int(originInRootView.x)
            y = Int(originInRootView.y)
            width = Int(self.frame.size.width)
            height = Int(self.frame.size.height)
        }
        
        let interfaceOrientation: UIInterfaceOrientation = UIApplication .shared .statusBarOrientation
        let isLandscape: Bool = UIInterfaceOrientationIsLandscape(interfaceOrientation)
        let adjustOrientationForIOS8: Bool = isInterstitial && isLandscape && !IOSVersion.SYSTEM_VERSION_LESS_THAN(version: "8.0")
        self .injectJavaScript(js: String(format: "mraid.setCurrentPosition(%d,%d,%d,%d);", x, y, (adjustOrientationForIOS8 ? height:width) as CVarArg, (adjustOrientationForIOS8 ?  width:height) as CVarArg) as NSString)
    }
    
    func fireStateChangeEvent()
    {
        var stateNames = NSArray()
        stateNames = ["loading","default","expanded","resized","hidden"]
        let stateName = stateNames[state!.rawValue]
        
        self .injectJavaScript(js: String(format: "mraid.fireStateChangeEvent('%@');",stateName as! CVarArg) as NSString)
    }
    
    func fireViewableChangeEvent()
    {
        self .injectJavaScript(js:String(format: "mraid.fireViewableChangeEvent(%@);",self.isViewable! ? "true":"false") as NSString)
    }
    
    func setDefaultPosition()
    {
        if (isInterstitial)
        {
            return
        }
        
        if (self.superview != self.rootViewController.view)
        {
            self .injectJavaScript(js:String(format: "mraid.setDefaultPosition(%f,%f,%f,%f);",(self.superview?.frame.origin.x)!,(self.superview?.frame.origin.y)!,(self.superview?.frame.size.width)!,(self.superview?.frame.size.height)!) as NSString)
        }
        else
        {
            self .injectJavaScript(js: String(format: "mraid.setDefaultPosition(%f,%f,%f,%f);",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height) as NSString)
        }
    }
    
    func getMaxSize()
    {
        let maxSize: CGSize = self.rootViewController.view.bounds.size
        //        self .injectJavaScript(js: String(format: "mraid.setMaxSize(%d,%d);",maxSize.width,maxSize.height) as NSString)
        //        previousMaxSize = CGSize(width: maxSize.width, height: maxSize.height)
        
        //  let maxSize = CGSize()
        //   self .injectJavaScript(js: String(format: "mraid.getMaxSize()") as NSString)
        
        // webView .stringByEvaluatingJavaScript(from: "mraid.getMaxSize()")
        let result = webView.stringByEvaluatingJavaScript(from: "mraid.getMaxSize();")
        
        // webView.evaluateJavaScript("alert('printing max size: ' + v.width + ' x ' + v.height);") { (result, error) in
        //            if error != nil
        //            {
        print(result as Any)
        //            }
        //  }
    }
    
    
    func setMaxSize()
    {
        if (isInterstitial)
        {
            return
        }
        let maxSize: CGSize = self.rootViewController.view.bounds.size
        if (!__CGSizeEqualToSize(maxSize, previousMaxSize))
        {
            self .injectJavaScript(js: String(format: "mraid.setMaxSize(%d,%d);",maxSize.width,maxSize.height) as NSString)
            previousMaxSize = CGSize(width: maxSize.width, height: maxSize.height)
        }
    }
    
    func setScreenSize()
    {
        var screenSize: CGSize = UIScreen .main .bounds .size
        let interfaceOrientation: UIInterfaceOrientation = UIApplication .shared .statusBarOrientation
        let isLandscape: Bool = UIInterfaceOrientationIsLandscape(interfaceOrientation)
        
        if (IOSVersion.SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: "8.0"))
        {
            screenSize = CGSize(width: screenSize.width, height: screenSize.height)
        }
        else
        {
            if(isLandscape)
            {
                screenSize = CGSize(width: screenSize.height, height: screenSize.width)
            }
        }
        
        if (!__CGSizeEqualToSize(screenSize, previousScreenSize))
        {
            self .injectJavaScript(js: String(format: "mraid.setScreenSize(%d,%d);",screenSize.width,screenSize.height) as NSString)
            previousScreenSize = CGSize(width: screenSize.width, height: screenSize.height)
            
            if(isInterstitial)
            {
                self .injectJavaScript(js: String(format: "mraid.setMaxSize(%d,%d);",screenSize.width,screenSize.height) as NSString)
                self .injectJavaScript(js: String(format: "mraid.setDefaultPosition(0,0,%d,%d);",screenSize.width,screenSize.height) as NSString)
            }
        }
    }
    
    func setSupports(_ currentFeatures: NSArray)
    {
        for aFeature in mraidFeatures!
        {
            
            //              SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "isViewable: %@", isViewable! as  NSNumber,(value: true) as! CVarArg) as NSString)
            
            // self .injectJavaScript(js:  String(format: "mraid.setSupports('%@',%@);",aFeature as! CVarArg,currentFeatures .contains(aFeature) as NSNumber,(value: true) as! CVarArg) as NSString)
            self .injectJavaScript(js:  String(format: "mraid.setSupports('%@',%@);",aFeature as! CVarArg,currentFeatures .contains(aFeature) as CVarArg) as NSString)
            
        }
    }
    
    private func webViewDidStartLoad(wv: UIWebView)
    {
        print("Webview started Loading")
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "JS callback %@",NSStringFromSelector(#function)) as NSString)
    }
    
    public func webViewDidFinishLoad(_ wv: UIWebView)
    {
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "JS callback %@",NSStringFromSelector(#function)) as NSString)
        
        if SK_ENABLE_JS_LOG {
            wv .stringByEvaluatingJavaScript(from: "var enableLog = true")
        }
        if SK_SUPPRESS_JS_ALERT
        {
            wv .stringByEvaluatingJavaScript(from: "function alert(){}; function prompt(){}; function confirm(){}")
        }
        
        if defoultStr .isEqual(to: "hero")
        {
            checkStr = "hjh"
            //  self .expand(urlString: "")
            self .addDeviceCode()
        }
        
        if (state == MRAIDState.MRAIDStateLoading)
        {
            state = MRAIDState.MRAIDStateDefault
            //self .injectJavaScript(js:  String(format: "mraid.setPlacementType('%@');",isInterstitial as NSNumber,(value: true) as! CVarArg) as NSString)
            self .injectJavaScript(js:  String(format: "mraid.setPlacementType('%@');",isInterstitial as CVarArg) as NSString)
            
            self .setSupports(supportedFeatures)
            self .setDefaultPosition()
            self .setMaxSize()
            self .setScreenSize()
            self .fireSizeChangeEvent()
            self .fireStateChangeEvent()
            self .fireReadyEvent()
            self.delegate .mraidViewAdReady(mraidView: self)
            
            UIDevice .current .beginGeneratingDeviceOrientationNotifications()
            NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        }
    }
    
    public func webView(_ wv: UIWebView, didFailLoadWithError error: Error)
    {
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "JS callback %@",NSStringFromSelector(#function)) as NSString)
    }
    
    public func webView(_ wv: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        let url: NSURL = request .url! as NSURL
        let scheme: NSString = url .scheme! as NSString
        //  let absUrlString: NSString = url .absoluteString! as NSString
        absUrlString = url .absoluteString! as NSString
        print(absUrlString as Any)
        
        checkUrlString = url .absoluteString! as NSString
        var check1 = NSString()
        check1 = checkUrlString
        
        if check1.range(of: "https://ad.doubleclick.net/").location != NSNotFound
        {
            
            print("Yes it contains 'Hello'")
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
        else
        {
            if (scheme .isEqual(to: "mraid"))
            {
                checkStr = ""
                self .parseCommandUrl(commandUrlString: absUrlString!)
            }
            else if (scheme .isEqual(to: "console-log"))
            {
                var aaa = NSString()
                aaa = absUrlString? .substring(from: 14) as! NSString
                SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "JS console: %@",(aaa.replacingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue).rawValue)!)) as NSString)
            }
            else
            {
                if(navigationType == UIWebViewNavigationType.linkClicked)
                {
                    if(self.delegate .responds(to: #selector(mraidViewNavigate(mraidView:withURL:))))
                    {
                        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "JS webview load: %@",(absUrlString?.replacingPercentEscapes(using: String.Encoding.utf8.rawValue)!)!) as NSString)
                        self.delegate .mraidViewNavigate(mraidView: self, withURL: url)
                    }
                }
                else
                {
                    return true
                }
            }
        }
        return false;
    }
    
    
    func mraidModalViewControllerDidRotate(modalViewController: SKMRAIDModalViewController)
    {
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "%@",NSStringFromSelector(#function)) as NSString)
        self .setScreenSize()
        self .fireSizeChangeEvent()
    }
    
    func initWebView(wv: UIWebView)
    {
        wv .delegate = self
        wv .isOpaque = false
        wv .autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleBottomMargin]
        wv .autoresizesSubviews = true
        
        if (supportedFeatures .contains(Constants.MRAIDSupportsInlineVideo))
        {
            wv .allowsInlineMediaPlayback = true
            wv .mediaPlaybackRequiresUserAction = false
        }
        else
        {
            wv .allowsInlineMediaPlayback = false
            wv .mediaPlaybackRequiresUserAction = true
            SkLogger .warning(tag: "MRAID - View", withMessage: "No inline video support has been included, videos will play full screen without autoplay.")
        }
        
        var scrollView1 = UIScrollView()
        
        if (wv .responds(to: #selector(getter: wv .scrollView)))
        {
            scrollView1 = wv .scrollView
        }
        else
        {
            for subview in self .subviews
            {
                if(subview .isKind(of: UIScrollView.self))
                {
                    scrollView1 = subview as! UIScrollView
                    break
                }
            }
        }
        scrollView1 .isScrollEnabled = false
        
        let js: NSString = "window.getSelection().removeAllRanges();"
        wv .stringByEvaluatingJavaScript(from: js as String)
        
        if (SK_SUPPRESS_JS_ALERT)
        {
            wv .stringByEvaluatingJavaScript(from: "function alert(){}; function prompt(){}; function confirm(){}")
        }
    }
    
    func parseCommandUrl(commandUrlString: NSString)
    {
        skbrow?.removeFromParentViewController()
        skbrow?.dismiss(animated: false, completion: nil)
        
        checkStr = ""
        let commandDict: NSDictionary = self .parseCommandUrll(commandUrl: commandUrlString)
        if(commandDict == nil)
        {
            SkLogger .warning(tag: "MRAID - Parser", withMessage: String(format: "invalid command URL: %@",commandUrlString) as NSString)
            return
        }
        
        checkStr = commandDict .value(forKey: "command") as! NSString
        
        if checkStr .isEqual("close")
        {
            self .close()
            defoultStr = "hero"
            checkStr = ""
        }
        else if checkStr .isEqual("storePicture:")
        {
            command2 = commandDict .value(forKey: "paramObj") as! NSString
            self .storeImage()
        }
        else if checkStr .isEqual("open:")
        {
            command2 = commandDict .value(forKey: "paramObj") as! NSString
            var paramObj = NSObject()
            paramObj = command2
            self .open()
        }
        else
        {
            print(checkStr)
            //self .expand(urlString: "")
            self .addDeviceCode()
            //defoultStr = "herofd"
            checkStr = "hghg"
            closeEventRegion .isHidden = true
        }
        //}
    }
    
    func storeImage()
    {
        let strr = command2.removingPercentEncoding
        print(strr as Any)
        let url = URL(string: strr!)
        print(command2)
        let data = try? Data(contentsOf: url!)
        
        if let imageData = data {
            let image = UIImage(data: imageData)
            
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer)
    {
        if error != nil
        {
            let alertView = UIAlertController(title: "", message: "Image Not saved successfully", preferredStyle: .alert)
            
            alertView.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
        }
        else
        {
            let alertView = UIAlertController(title: "", message: "Image saved successfully", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
        }
    }
    func addDeviceCode()
    {
        
        let interfaceOrientation: UIInterfaceOrientation = UIApplication .shared .statusBarOrientation
        let isLandscape: Bool = UIInterfaceOrientationIsLandscape(interfaceOrientation)
        
        if(isLandscape)
        {
            if UIDevice().userInterfaceIdiom == .phone
            {
                switch UIScreen.main.bounds.size.width{
                case 480:
                    print("iPhone 4S")
                    self.frame = CGRect(x: 0, y: 0, width: 480, height: 320)
                    webView.frame = CGRect(x: 0, y: 0, width: 480, height: 320)
                case 568:
                    print("iPhone 5")
                    self.frame = CGRect(x: 0, y: 0, width: 568, height: 320)
                    webView.frame = CGRect(x: 0, y: 0, width: 568, height: 320)
                case 667:
                    print("iPhone 6")
                    self.frame = CGRect(x: 0, y: 0, width: 667, height: 375)
                    webView.frame = CGRect(x: 0, y: 0, width: 667, height: 375)
                case 736:
                    print("iPhone 6 plus")
                    self.frame = CGRect(x: 0, y: 0, width: 736, height: 414)
                    webView.frame = CGRect(x: 0, y: 0, width: 736, height: 414)
                case 812:
                    print("iPhone x")
                    self.frame = CGRect(x: 0, y: 0, width: 812, height: 375)
                    webView.frame = CGRect(x: 0, y: 0, width: 812, height: 375)
                default:
                    print("other models")
                }
            }
            else if UIDevice().userInterfaceIdiom == .pad
            {
                print("IPAD ======= ")
                if DeviceType.IS_IPAD
                {
                    self.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
                    webView.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
                }
                else if DeviceType.IS_IPAD_PRO_10_5
                {
                    self.frame = CGRect(x: 0, y: 0, width: 1112, height: 834)
                    webView.frame = CGRect(x: 0, y: 0, width: 1112, height: 834)
                }
                else if DeviceType.IS_IPAD_PRO_12_9
                {
                    self.frame = CGRect(x: 0, y: 0, width: 1366, height: 1024)
                    webView.frame = CGRect(x: 0, y: 0, width: 1366, height: 1024)
                }
            }
        }
        else
        {
            if UIDevice().userInterfaceIdiom == .phone
            {
                switch UIScreen.main.bounds.size.height{
                case 480:
                    print("iPhone 4S")
                    self.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 480)
                    webView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 480)
                case 568:
                    print("iPhone 5")
                    self.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 568)
                    webView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 568)
                case 667:
                    print("iPhone 6")
                    self.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 667)
                    webView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 667)
                case 736:
                    print("iPhone 6 plus")
                    self.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 736)
                    webView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 736)
                case 812:
                    print("iPhone x")
                    self.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 812)
                    webView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 812)
                default:
                    print("other models")
                }
            }
            else if UIDevice().userInterfaceIdiom == .pad
            {
                print("IPAD")
                if DeviceType.IS_IPAD
                {
                    self.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 1024)
                    webView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 1024)
                }
                else if DeviceType.IS_IPAD_PRO_10_5
                {
                    self.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 1112)
                    webView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 1112)
                }
                else if DeviceType.IS_IPAD_PRO_12_9
                {
                    self.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 1366)
                    webView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 1366)
                }
            }
        }
        webView.scalesPageToFit = true
        webView.scrollView.isScrollEnabled = true
        webView .delegate = self
        //        let scrollPoint = CGPoint(x: 0, y: webView.scrollView.contentSize.height - webView.frame.size.height)
        //        webView.scrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    func parseCommandUrll(commandUrl: NSString) -> NSDictionary
    {
        SkLogger .debug(tag: "MRAID - View", withMessage: String(format: "%@ %@",NSStringFromSelector(#function),commandUrl) as NSString)
        
        let s: NSString = commandUrl .substring(from: 8) as NSString
        
        var command = NSString()
        var params = NSMutableDictionary()
        
        var range: NSRange = s .range(of: "?")
        if (range.location != NSNotFound) {
            command = s .substring(to: range.location) as NSString
            let paramStr = s .substring(from: range.location + 1)
            
            var paramArray = NSArray()
            paramArray = paramStr .components(separatedBy: "&") as NSArray
            params = NSMutableDictionary(capacity: 5)
            
            for param in paramArray
            {
                range = (param as AnyObject) .range(of: "=")
                let key: NSString = (param as AnyObject) .substring(to: range.location) as NSString
                let val: NSString = (param as AnyObject) .substring(from: range.location + 1) as NSString as NSString
                params .setValue(val, forKey: key as String)
            }
        }
        else
        {
            command = s
        }
        
        if !(self .isValidCommand(command: command))
        {
            SkLogger .warning(tag: "MRAID - Parser", withMessage: String(format: "command %@ is unknown", command) as NSString)
        }
        
        if !(self .checkParamsForCommand(command: command, params: params))
        {
            SkLogger .warning(tag: "MRAID - Parser", withMessage: String(format: "command URL %@ is missing parameters", commandUrl) as NSString)
        }
        
        var paramObj = NSObject()
        
        if (command .isEqual(to: "createCalendarEvent") ||
            command .isEqual(to: "expand") ||
            command .isEqual(to: "open") ||
            command .isEqual(to: "playVideo") ||
            command .isEqual(to: "setOrientationProperties") ||
            command .isEqual(to: "setResizeProperties") ||
            command .isEqual(to: "storePicture") ||
            command .isEqual(to: "useCustomClose")
            )
        {
            if(command .isEqual(to: "createCalendarEvent"))
            {
                paramObj = params .value(forKey: "eventJSON") as! NSObject
            }
            else if ( command .isEqual(to: "expand") ||
                command .isEqual(to: "open") ||
                command .isEqual(to: "playVideo") ||
                command .isEqual(to: "storePicture")
                )
            {
                paramObj = params .value(forKey: "url") as! NSObject
            }
            else if (command .isEqual(to: "setOrientationProperties") ||
                command .isEqual(to: "setResizeProperties")
                )
            {
                paramObj = params
            }
            else if (command .isEqual(to: "useCustomClose"))
                
            {
                paramObj = params .value(forKey: "useCustomClose") as! NSObject
            }
            command = command.appending(":") as NSString // hello world
        }
        
        let commandDic: NSMutableDictionary = ["command":command]
        let commandDict: NSMutableDictionary = NSMutableDictionary(dictionary: commandDic) .mutableCopy() as! NSMutableDictionary
        
        if (paramObj != nil)
            
        {
            commandDict["paramObj"] = paramObj
        }
        
        return commandDict
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
    
    @objc func oneFingerOneTap(_ sender: UITapGestureRecognizer)
    {
        bonafideTapObserved = true
        tapGestureRecognizer?.delegate = nil
        tapGestureRecognizer = nil
        SkLogger .debug(tag: "MRAID - View", withMessage: "tapGesture oneFingerTap observed")
        self .getMaxSize()
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view == resizeCloseRegion || touch.view == closeEventRegion)
        {
            SkLogger .debug(tag: "MRAID - View", withMessage: "tapGesture 'shouldReceiveTouch'=NO")
            print("shouldReceiveTouch'=NO")
            return false
        }
        SkLogger .debug(tag: "MRAID - View", withMessage: "tapGesture 'shouldReceiveTouch'=YES")
        print("shouldReceiveTouch'=YES")
        return true
    }
    
    func processRawHtml(rawHtml: NSString) -> NSString
    {
        var processedHtml: NSString = rawHtml
        var range: NSRange
        var pattern: NSString = "<script\\s+[^>]*\\bsrc\\s*=\\s*([\\\"\\\'])mraid\\.js\\1[^>]*>\\s*</script>\\n*"
        
        var regex = NSRegularExpression()
        do {
            regex = try NSRegularExpression(pattern: pattern as String, options: .caseInsensitive)
        } catch {
            print(error)
        }
        
        processedHtml = regex .stringByReplacingMatches(in: processedHtml as String, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, processedHtml .length), withTemplate: "") as NSString
        
        range = rawHtml .range(of: "<html")
        let hasHtmlTag: Bool = range.location != NSNotFound
        range = rawHtml .range(of: "<head")
        let hasHeadTag: Bool = range.location != NSNotFound
        range = rawHtml .range(of: "<body")
        let hasBodyTag: Bool = range.location != NSNotFound
        print(hasBodyTag)
        
        if ((!hasHtmlTag && (hasHeadTag || hasBodyTag)) || (hasHeadTag && !hasBodyTag))
        {
            
        }
        
        if(!hasHtmlTag)
        {
            processedHtml =  String(format: "<html>\n<head>\n</head>\n<body>\n<div align='center'>\n%@</div>\n</body>\n</html>", processedHtml) as NSString
        }
        else if (!hasHeadTag)
        {
            pattern = "<html[^>]*>"
            regex = try! NSRegularExpression(pattern: pattern as String,options: [.caseInsensitive])
            
            processedHtml = regex .stringByReplacingMatches(in: processedHtml as String, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, processedHtml .length), withTemplate: "$0\n<head>\n</head>") as NSString
        }
        
        let metaTag: NSString = "<meta name='viewport' content='width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no' />"
        let styleTag: NSString = "<style>\nbody { margin:0; padding:0; }\n *:not(input) { -webkit-touch-callout:none; -webkit-user-select:none; -webkit-text-size-adjust:none; }\n </style>"
        
        pattern = "<head[^>]*>"
        
        regex = try! NSRegularExpression(pattern: pattern as String,options: [.caseInsensitive])
        processedHtml = regex .stringByReplacingMatches(in: processedHtml as String, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, processedHtml .length), withTemplate: (String(format: "$0\n%@\n%@",metaTag,styleTag) as NSString) as String) as NSString
        
        return processedHtml
    }
    
    
    func isValidCommand(command: NSString) -> Bool
    {
        var kCommands = NSArray()
        kCommands = [
            "createCalendarEvent",
            "close",
            "expand",
            "open",
            "playVideo",
            "resize",
            "setOrientationProperties",
            "setResizeProperties",
            "storePicture",
            "useCustomClose"
        ]
        return kCommands .contains(command)
    }
    
    func checkParamsForCommand(command: NSString, params:NSDictionary) -> Bool
    {
        if (command .isEqual(to: "createCalendarEvent"))
        {
            return (params .value(forKey: "eventJSON") != nil)
        }
        else if (command .isEqual(to: "open") || command .isEqual(to: "playVideo") || command .isEqual(to: "storePicture"))
        {
            return (params .value(forKey: "url") != nil)
        }
        else if (command .isEqual(to: "setOrientationProperties"))
        {
            return (params .value(forKey: "allowOrientationChange") != nil && params .value(forKey: "forceOrientation") != nil)
        }
        else if (command .isEqual(to: "setResizeProperties"))
        {
            return (params .value(forKey: "width") != nil &&
                params .value(forKey: "height") != nil &&
                params .value(forKey: "offsetX") != nil &&
                params .value(forKey: "offsetY") != nil &&
                params .value(forKey: "customClosePosition") != nil &&
                params .value(forKey: "allowOffscreen") != nil
            )
        }
        else if (command .isEqual(to: "useCustomClose"))
        {
            return (params .value(forKey: "useCustomClose") != nil)
        }
        return true
    }
    
    func setLogLevel(level: SourceKitLogLevel)
    {
        var levelNames = NSArray()
        levelNames = [
            "none",
            "error",
            "warning",
            "info",
            "debug"
        ]
        let levelName: NSString = levelNames[level.rawValue] as! NSString
        print(levelName)
        logLevel = level
    }
    
    @objc func mraidViewDidClose(mraidView: SKMRAIDView2)
    {
        print("")
    }
    
    @objc func mraidViewAdReady(mraidView: SKMRAIDView2)
    {
        print("")
    }
    
    @objc func mraidViewNavigate(mraidView: SKMRAIDView2, withURL url: NSURL)
    {
        print("")
    }
    
    @objc func mraidViewAdFailed(mraidView: SKMRAIDView2)
    {
        print("")
    }
    
    @objc func mraidViewWillExpand(mraidView: SKMRAIDView2)
    {
        print("")
    }
    
    @objc public func mraidServiceStorePictureWithUrlString(urlString: NSString)
    {
        print("")
    }
    
    public func webView(_ webView: WKWebView,
                        runJavaScriptAlertPanelWithMessage message: String,
                        initiatedByFrame frame: WKFrameInfo,
                        completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let title = NSLocalizedString("OK", comment: "OK Button")
        let ok = UIAlertAction(title: title, style: .default) { (action: UIAlertAction) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        //present(alert, animated: true)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
        completionHandler()
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //wkWebView.evaluateJavaScript("alert('Hello from evaluateJavascript()')", completionHandler: nil)
        wkWebView.evaluateJavaScript("alert('Hello from evaluateJavascript()')") { (result, error) in
            if error != nil {
                print(result as Any)
            }
        }
    }
}


