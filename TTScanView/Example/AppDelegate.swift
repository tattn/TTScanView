//
//  AppDelegate.swift
//  TTScanView
//
//  Created by Tanaka Tatsuya
//  Copyright © 2015年 Tatsuya Tanaka. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ScanDelegate {

    var window: UIWindow?
    var scanView: ScanView?
    var counter = 0

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let VC = UIViewController()
        VC.view?.backgroundColor = UIColor.whiteColor()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = VC
        
        let frame = window!.frame
        VC.view?.frame = frame
        
        scanView = ScanView(frame: CGRectMake(0, 0, 300, 300))
        VC.view!.addSubview(scanView!)
        scanView!.center = VC.view!.center
        scanView!.delegate = self
        scanView!.showQRcode("Hello world")
        
        let button = UIButton(type: UIButtonType.System)
        button.frame = CGRectMake(0, scanView!.frame.origin.y + 330, frame.width, 20)
        button.setTitle("Button", forState: UIControlState.Normal)
        button.addTarget(self, action: "touchUpButton:", forControlEvents: UIControlEvents.TouchUpInside)
        VC.view!.addSubview(button)
        
        return true
    }
    
    @IBAction func touchUpButton(sender: UIButton) {
        if counter == 0 {
            scanView!.showCamera(ScanView.CameraType.Barcode)
        }
        else {
            scanView!.showQRcode("Hello world")
        }
        
        counter = (counter + 1) % 2
    }
    
    func detectedCode(code: String) {
        print(code)
    }
}

