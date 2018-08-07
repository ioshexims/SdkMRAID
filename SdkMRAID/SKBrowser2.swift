//
//  SKBrowser2.swift
//  SwiftProject
//
//  Created by dev on 18/04/18.
//  Copyright © 2018 hexims. All rights reserved.
//

import UIKit

public struct Constant
{
   public static let kSourceKitBrowserFeatureDisableStatusBar: String = "disableStatusBar"
   public static let kSourceKitBrowserFeatureScalePagesToFit: String = "scalePagesToFit"
   public static let kSourceKitBrowserFeatureSupportInlineMediaPlayback: String = "supportInlineMediaPlayback"
}
public
protocol SKBrowserDelegate: NSObjectProtocol
{
    func sourceKitBrowserClosed(sourceKitBrowser: SKBrowser2);
    func sourceKitBrowserWillExitApp(sourceKitBrowser: SKBrowser2);
}

public class SKBrowser2: UIViewController,SourceKitBrowserControlsViewDelegate,UIWebViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate
{
        var delegatee: SKBrowserDelegate?
        var browserControlsView = SKBrowserControlsView()
        var currrentRequest: NSURLRequest?
        var currentViewController = UIViewController()
        var sourceKitBrowserFeatures: NSArray?
        var browserWebView = UIWebView()
        var loadingIndicator: UIActivityIndicatorView?
        var disableStatusBar = Bool()
        var scalePagesToFit = Bool()
        var statusBarHidden = Bool()
        var supportInlineMediaPlayback = Bool()
        var url1111 = NSURL()
    
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()

        browserWebView.delegate = nil
        self.view .autoresizesSubviews = true
        self.view .autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleBottomMargin]
    }
    
    
   public func loadRequest(request: NSURLRequest)
    {
        currentViewController = (UIApplication.shared .keyWindow! .rootViewController)!
        
        while (currentViewController.presentedViewController != nil)
        {
            currentViewController = currentViewController.presentedViewController!
        }
        self.view.frame = currentViewController.view.bounds
        
        url1111 = request .url! as NSURL
        print(url1111)
        var strrr = NSString()
        strrr = url1111.absoluteString! as NSString
        print(strrr)
        
        if !strrr .isEqual("true")
        {
            
        var scheme = NSString()
        scheme = url1111 .scheme! as NSString
        var host = NSString()
        host = url1111 .host! as NSString
        print(host)

        var absUrlString = NSString()
        absUrlString = url1111 .absoluteString! as NSString
        print(absUrlString)

        var openSystemBrowserDirectly = Bool()
        openSystemBrowserDirectly = false
       
         if (host .isEqual(to: "itunes.apple.com") || host .isEqual(to: "phobos.apple.com") || host .isEqual(to: "maps.google.com"))
        {
            openSystemBrowserDirectly = true
        }
        else if(scheme != "http" && scheme != "https")
        {
            openSystemBrowserDirectly = true
        }
        if openSystemBrowserDirectly
        {
            if (UIApplication.shared .canOpenURL(url1111 as URL))
            {
                if (self.delegatee? .responds(to: #selector(sourceKitBrowserWillExitApp)))!
                {
                    self.delegatee? .sourceKitBrowserWillExitApp(sourceKitBrowser: self)
                }
                if let url = URL(string: "\(url1111)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        else
        {
            currrentRequest = request
            SkLogger .debug(tag: "SKBrowser", withMessage:  String(format: "presenting browser from viewController: %@", currentViewController) as NSString)
            if(currentViewController .responds(to: #selector(present(_:animated:completion:))))
           {
                self.currentViewController .present(self, animated: true, completion: nil)
            }
            else
            {
              
            }
        }
        }
       else if !strrr .isEqual("false")
        {
            var scheme = NSString()
            scheme = url1111 .scheme! as NSString
            var host = NSString()
            host = url1111 .host! as NSString
            print(host)
            var absUrlString = NSString()
            absUrlString = url1111 .absoluteString! as NSString
            print(absUrlString)

            var openSystemBrowserDirectly = Bool()
            openSystemBrowserDirectly = false
            if (host .isEqual(to: "itunes.apple.com") || host .isEqual(to: "phobos.apple.com") || host .isEqual(to: "maps.google.com"))
            {
                openSystemBrowserDirectly = true
            }
            else if(scheme != "http" && scheme != "https")
            {
                openSystemBrowserDirectly = true
            }
            if openSystemBrowserDirectly
            {
                if (UIApplication.shared .canOpenURL(url1111 as URL))
                {
                    if (self.delegatee? .responds(to: #selector(sourceKitBrowserWillExitApp)))!
                    {
                        self.delegatee? .sourceKitBrowserWillExitApp(sourceKitBrowser: self)
                    }
                    if let url = URL(string: "\(url1111)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
            else
            {
                currrentRequest = request
                SkLogger .debug(tag: "SKBrowser", withMessage:  String(format: "presenting browser from viewController: %@", currentViewController) as NSString)
                if(currentViewController .responds(to: #selector(present(_:animated:completion:))))
                {
                    self.currentViewController .present(self, animated: true, completion: nil)
                }
                else
                {

                }
            }
        }
    }
   
    override public func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if ((browserWebView) != nil)
        {
            browserWebView.frame = self.view.bounds
            browserWebView.delegate = self
            browserWebView.scalesPageToFit = scalePagesToFit
            browserWebView.allowsInlineMediaPlayback = supportInlineMediaPlayback
            browserWebView.mediaPlaybackRequiresUserAction = false
            browserWebView.autoresizesSubviews = true
            let interfaceOrientation: UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
            var isLandscape = Bool()
            isLandscape = UIInterfaceOrientationIsLandscape(interfaceOrientation)
            
            browserWebView .autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]

            self.view .addSubview(browserWebView)
            
            browserControlsView = (browserControlsView .initWithSourceKitBrowser(p_skBrowser: self) as? SKBrowserControlsView)!
            browserControlsView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleBottomMargin]
            
          
            
            if (IOSVersion .SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: "8.0"))
            {
                print("browserControlsView FRAME%@", NSStringFromCGRect(browserControlsView.frame));
            }
          
            if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft
            {
                print("1")
            } else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight
            {
                print("2")

            } else if UIDevice.current.orientation == UIDeviceOrientation.portrait
            {
                print("3")

            } else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown
            {
                print("4")

            }
            
//
//            if (UIDevice().userInterfaceIdiom == .pad)
//                {
//            print("ipad====================")
//                    if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft
//                    {
//                        browserControlsView.frame = CGRect(x: 0, y: 834 - 44, width: self.view.frame.size.width, height: 44)
//                    }
//                   else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight
//                    {
//                        browserControlsView.frame = CGRect(x: 0, y: 834 - 44, width: self.view.frame.size.width, height: 44)
//                    }
//                    else if UIDevice.current.orientation == UIDeviceOrientation.portrait
//                    {
//                        browserControlsView.frame = CGRect(x: 0, y: 834 - 44, width: self.view.frame.size.width, height: 44)
//                    }
//                    else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown
//                    {
//                        browserControlsView.frame = CGRect(x: 0, y: 834 - 44, width: self.view.frame.size.width, height: 44)
//                    }
//                }
//            else
//            {
                if (isLandscape)
                {
                    browserControlsView.frame = CGRect(x: 0, y: self.view.frame.size.height - 44, width: self.view.frame.size.width, height: 44)
                    print("toolbar container view frame \(browserControlsView.frame)")
                }
                else
                {
                    browserControlsView.frame = CGRect(x: 0, y: self.view.frame.size.height - 44, width: self.view.frame.size.width, height: 44)
                    print("toolbar container view frame \(browserControlsView.frame)")
                }
          //  }
            
          
            loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            loadingIndicator?.frame = CGRect(x: 0, y: 0, width: 30, height:30)
            loadingIndicator?.hidesWhenStopped = true
            browserControlsView.loadingIndicator.customView? .addSubview(loadingIndicator!)
            
            self.view .addSubview(browserControlsView)
            browserWebView .loadRequest(currrentRequest! as URLRequest)
        }
    }
  
 
    override public func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)

         browserWebView.delegate = nil
        statusBarHidden = UIApplication .shared .isStatusBarHidden
        if (disableStatusBar && IOSVersion .SYSTEM_VERSION_LESS_THAN(version: "7.0"))
        {
            UIApplication.shared.isStatusBarHidden = true
        }
    }
    
    override public func viewWillDisappear(_ animated: Bool)
    {
        browserWebView .stopLoading()
        
        super.viewWillDisappear(animated)
        self .removeFromParentViewController()
        self .dismiss(animated: true, completion: nil)
        
        
        if (disableStatusBar && IOSVersion .SYSTEM_VERSION_LESS_THAN(version: "7.0"))
        {
            UIApplication.shared.isStatusBarHidden = statusBarHidden
       }
    }
    
    func prefersStatusBarHidden() -> Bool
    {
        return disableStatusBar
    }
    @objc func didRotateFromInterfaceOrientation(fromInterfaceOrientation: NSNotification)
    {
        if ((browserWebView) != nil)
        {
            browserWebView.frame = self.view.bounds
            print(browserWebView.frame)
            browserWebView.delegate = self
            browserWebView.scalesPageToFit = scalePagesToFit
            browserWebView.allowsInlineMediaPlayback = supportInlineMediaPlayback
            browserWebView.mediaPlaybackRequiresUserAction = false
            browserWebView.autoresizesSubviews = true
            
            browserWebView .autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
            
            self.view .addSubview(browserWebView)
            
            let interfaceOrientation: UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
            var isLandscape = Bool()
            isLandscape = UIInterfaceOrientationIsLandscape(interfaceOrientation)
            
            if (IOSVersion .SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: "8.0"))
            {
                print("browserControlsView FRAME%@", NSStringFromCGRect(browserControlsView.frame));
            }
            
            if UIDevice().userInterfaceIdiom == .pad
            {
             self .deviceFraming()
            }
            else
            {
                if (isLandscape)
                {
                    browserControlsView.frame = CGRect(x: 0, y: self.view.frame.size.height - 44, width: self.view.frame.size.width, height: 44)
                }
                else
                {
                    browserControlsView.frame = CGRect(x: 0, y: self.view.frame.size.height - 44, width: self.view.frame.size.width, height: 44)
                }
            }
            
            browserControlsView = (browserControlsView .initWithSourceKitBrowser(p_skBrowser: self) as? SKBrowserControlsView)!
            browserControlsView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleBottomMargin]
            
            print("toolbar browserControlsView rotate view frame \(browserControlsView.frame)")

            loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            loadingIndicator?.frame = CGRect(x: 0, y: 0, width: 30, height:30)
            loadingIndicator?.hidesWhenStopped = true
            browserControlsView.loadingIndicator.customView? .addSubview(loadingIndicator!)
            
            self.view .addSubview(browserControlsView)
        }
    }
    
    func deviceFraming()
    {
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft
        {
            if DeviceType.IS_IPAD
            {
                browserControlsView.frame = CGRect(x: 0, y: self.view.frame.size.height - 44, width: 1024, height: 44)
            }
            else if DeviceType.IS_IPAD_PRO_10_5
            {
                browserControlsView.frame = CGRect(x: 0, y: self.view.frame.size.height - 44, width: 1112, height: 44)
            }
            else if DeviceType.IS_IPAD_PRO_12_9
            {
                browserControlsView.frame = CGRect(x: 0, y: self.view.frame.size.height - 44, width: 1366, height: 44)
            }
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight
        {
            if DeviceType.IS_IPAD
            {
                browserControlsView.frame = CGRect(x: 0, y: self.view.frame.size.height - 44, width: 1024, height: 44)
            }
            else if DeviceType.IS_IPAD_PRO_10_5
            {
                //browserControlsView.frame = CGRect(x: 0, y: 1100 - 44, width: 1112, height: 44)
                browserControlsView.frame = CGRect(x: 0, y: self.view.frame.size.height - 44, width: 1112, height: 44)

            }
            else if DeviceType.IS_IPAD_PRO_12_9
            {
                browserControlsView.frame = CGRect(x: 0, y: self.view.frame.size.height - 44, width: 1366, height: 44)
            }
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.portrait
        {
            if DeviceType.IS_IPAD
            {
                browserControlsView.frame = CGRect(x: 0, y: self.view.frame.size.height - 44, width: 1024, height: 44)
            }
            else if DeviceType.IS_IPAD_PRO_10_5
            {
                browserControlsView.frame = CGRect(x: 0, y: self.view.frame.size.height - 44, width: 1112, height: 44)
            }
            else if DeviceType.IS_IPAD_PRO_12_9
            {
                browserControlsView.frame = CGRect(x: 0, y: self.view.frame.size.height - 44, width: 1366, height: 44)
            }
            print("toolbar browserControlsView rotate view frame \(browserControlsView.frame)")
            
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown
        {
            if DeviceType.IS_IPAD
            {
                browserControlsView.frame = CGRect(x: 0, y: self.view.frame.size.height - 44, width: 1024, height: 44)
            }
            else if DeviceType.IS_IPAD_PRO_10_5
            {
                browserControlsView.frame = CGRect(x: 0, y: self.view.frame.size.height - 44, width: 1112, height: 44)
            }
            else if DeviceType.IS_IPAD_PRO_12_9
            {
                browserControlsView.frame = CGRect(x: 0, y: self.view.frame.size.height - 44, width: 1366, height: 44)
            }
            
        }
    }
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    convenience init()
    {
        
        self.init(nibName:nil, bundle:nil)
         NotificationCenter.default.addObserver(self, selector: #selector(didRotateFromInterfaceOrientation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
  public func initWithDelegate(delegate: SKBrowserDelegate,  withFeatures p_sourceKitBrowserFeatures: NSArray) -> Any
    {
            delegatee = delegate
            sourceKitBrowserFeatures = p_sourceKitBrowserFeatures

        if (p_sourceKitBrowserFeatures != nil && p_sourceKitBrowserFeatures.count > 0)
            {
                
                for feature: NSString in p_sourceKitBrowserFeatures as! Array
                {
                    if feature as String == Constant.kSourceKitBrowserFeatureDisableStatusBar
                   {
                    disableStatusBar = true
                    }
                    else if (feature as String == Constant.kSourceKitBrowserFeatureSupportInlineMediaPlayback)
                    {
                      supportInlineMediaPlayback = true
                    }
                    else if (feature as String == Constant.kSourceKitBrowserFeatureScalePagesToFit)
                    {
                        scalePagesToFit = true
                    }
                    
                    SkLogger .debug(tag: "SKBrowser", withMessage:  String(format: "Requesting SourceKitBrowser feature: %@", feature as CVarArg) as NSString)
                }
            }
       return self
    }
  
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType:UIWebViewNavigationType) -> Bool
    {
        var url = NSURL()
        url = request .url! as NSURL
        var scheme = NSString()
        scheme = url .scheme! as NSString
        print(scheme)
        var host = NSString()
        if scheme .isEqual(to: "about")
        {
            host = ""
        }
        else
        {
            host = url .host! as NSString
            print(host)
        }
       
        var absUrlString = NSString()
        absUrlString = url .absoluteString! as NSString
        print(absUrlString)

        if (absUrlString != "about:blank")
        {
            var openSystemBrowserDirectly = Bool()
            openSystemBrowserDirectly = false
            
            if (host .isEqual(to: "itunes.apple.com") || host .isEqual(to: "phobos.apple.com") || host .isEqual(to: "maps.google.com"))
            {
                openSystemBrowserDirectly = true
            }
            else if (scheme != "http" && scheme != "https")
            {
                openSystemBrowserDirectly = true
            }
            
            if (openSystemBrowserDirectly)
            {
                if(UIApplication.shared .canOpenURL(url as URL))
                {
                    if(self.delegatee? .responds(to: #selector(sourceKitBrowserWillExitApp)))!
                        
                    {
                        self.delegatee? .sourceKitBrowserWillExitApp(sourceKitBrowser: self)
                    }
                    self .dismiss()
                    if let url = URL(string: "\(url)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    return false
                }
                else
                {
                    self .dismiss()
                    webView .stopLoading()

                    return false
                }
            }
        }
        
           return true
    }
    
    
    public func webViewDidStartLoad(_ webView: UIWebView)
    {
        loadingIndicator? .startAnimating()
    }

    public func webViewDidFinishLoad(_ webView: UIWebView)
    {
        browserControlsView.backButton.isEnabled = webView .canGoBack
        browserControlsView.forwardButton.isEnabled = webView .canGoForward
        loadingIndicator? .stopAnimating()
    }

    func forward()
    {
        if (browserWebView .canGoForward)
        {
            browserWebView .goForward()
        }
    }
    
    func back()
    {
        if (browserWebView .canGoBack)
        {
            browserWebView .goBack()
        }
    }
    
    func dismiss()
    {
        browserWebView .stopLoading()
        SkLogger .debug(tag: "SKBrowser", withMessage: "Dismissing SourceKitBrowser")
        self .removeFromParentViewController()
        self .dismiss(animated: true, completion: nil)
        
        self.delegatee? .sourceKitBrowserClosed(sourceKitBrowser: self)
        self.delegatee = nil
        currrentRequest = nil
        loadingIndicator = nil
        sourceKitBrowserFeatures = nil
    
        DispatchQueue.main.async
            {
                self.currentViewController .dismiss(animated: false, completion: {
                   // self.currentViewController .navigationController?.popViewController(animated: false)
                    self.currentViewController .dismiss(animated: false, completion: nil)
              })
        }
    }
 
    func refresh()
    {
        browserWebView .reload()
    }
    
    func launchSafari()
    {

        if UIDevice().userInterfaceIdiom == .pad
        {
            let alertController = UIAlertController(title: "Action", message: nil, preferredStyle: .actionSheet)
            let defaultAction = UIAlertAction(title: "Launch Safari", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                self .openURLfromSafari()
            })
            let deleteAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
                //  Do some destructive action here.
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
                //  Do something here upon cancellation.
            })
            
            alertController.addAction(defaultAction)
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let actionSheetController = UIAlertController(title: "Action", message: nil, preferredStyle: .actionSheet)
            
            let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                print("Cancel")
            }
            actionSheetController.addAction(cancelActionButton)
            
            let saveActionButton = UIAlertAction(title: "Launch Safari", style: .default) { action -> Void in
                print("Save")
                self .openURLfromSafari()
            }
            actionSheetController.addAction(saveActionButton)
            
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    func openURLfromSafari()
    {
        var currentRequestURL = NSURL()
        currentRequestURL = self.browserWebView.request? .url! as! NSURL
        self.delegatee? .sourceKitBrowserWillExitApp(sourceKitBrowser: self)
        self .dismiss()
        if let url = URL(string: "\(currentRequestURL)")
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func setLogLevel(level: SourceKitLogLevel)
    {
        var levelNames = NSArray()
        levelNames = ["none","error","warning","info","debug"]
        let levelName: NSString = levelNames[level.rawValue] as! NSString
        print(levelName)
        logLevel = level
    }
    
    @objc func sourceKitBrowserWillExitApp(sourceKitBrowser: SKBrowser2)
     {
    
    }

}
struct ScreenSize1
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType1
{
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO_9_7      = IS_IPAD
    static let IS_IPAD_PRO_12_9     = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}
