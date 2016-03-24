//
//  AppDelegate.swift
//  swift-demo
//
//  Created by Joel Oliveira on 23/03/16.
//  Copyright © 2016 Joel Oliveira. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, NotificarePushLibDelegate{

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        NotificarePushLib.shared().launch()
        NotificarePushLib.shared().delegate = self
        NotificarePushLib.shared().handleOptions(launchOptions)
        
        // Override point for customization after application launch.
        return true
    }
    
    func notificarePushLib(library: NotificarePushLib!, onReady info: [NSObject : AnyObject]!) {
        
        NotificarePushLib.shared().registerForNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //
        
        NotificarePushLib.shared().registerDevice(deviceToken, completionHandler: { (NSDictionary) -> Void in
            
            
        }) { (NSError) -> Void in
            // handle Error
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        //
        NotificarePushLib.shared().handleNotification(userInfo, forApplication: application, completionHandler: { (NSDictionary) -> Void in
            
            completionHandler(UIBackgroundFetchResult.NewData)

            
            }) { (NSError) -> Void in
        
                completionHandler(UIBackgroundFetchResult.NoData)

        }
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        
        NotificarePushLib.shared().handleAction(identifier, forNotification: userInfo, withData: responseInfo, completionHandler: { (NSDictionary) -> Void in
            
            }) { (NSError) -> Void in
                
        }
    }
    
    func notificarePushLib(library: NotificarePushLib!, didUpdateBadge badge: Int32) {
        //
        NSNotificationCenter.defaultCenter().postNotificationName("updateInbox", object: nil)

    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

