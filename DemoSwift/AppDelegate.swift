//
//  AppDelegate.swift
//  DemoSwift
//
//  Created by Joel Oliveira on 18/03/2019.
//  Copyright © 2019 Joel Oliveira. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, NotificarePushLibDelegate {
    
    var window: UIWindow?
    var myString: String?
    var fakeOnboardingIsDone: Bool? = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NotificarePushLib.shared().initialize(withKey: nil, andSecret: nil)
        NotificarePushLib.shared().delegate = self
        NotificarePushLib.shared().launch()
        NotificarePushLib.shared().didFinishLaunching(options: launchOptions);
        
        if #available(iOS 10.0, *) {
            NotificarePushLib.shared().presentationOptions = .alert
        }
        
        myString = "SOME STRING"
        return true
    }
    
    func notificarePushLib(_ library: NotificarePushLib, onReady application: NotificareApplication) {
        
        
        if (NotificarePushLib.shared().remoteNotificationsEnabled()) {
            NotificarePushLib.shared().registerForNotifications()
        } else {
            let alert = UIAlertController(title: "Notificare", message: "Do you want to receive notifications?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                NotificarePushLib.shared().registerForNotifications()
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            let navController = window?.rootViewController as? UINavigationController
            navController?.present(alert, animated: true)
        }

        
    }
    
    func notificarePushLib(_ library: NotificarePushLib, didRegister device: NotificareDevice) {
        print(device.deviceID)
        
        NotificarePushLib.shared().addTag("tag_swift", completionHandler: {(_ response: Any?, _ error: Error?) -> Void in
            if error == nil {
                //Tag added
            }
        })

        if (NotificarePushLib.shared().locationServicesEnabled()) {
            NotificarePushLib.shared().startLocationUpdates()
        }
        
        
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        NotificarePushLib.shared().continue(userActivity, restorationHandler: restorationHandler);
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NotificarePushLib.shared().handleOpen(url, withOptions: options)
        print(url)
        return true;
    }
    
    func notificarePushLib(_ library: NotificarePushLib, didReceiveLocationServiceAuthorizationStatus status: NotificareGeoAuthorizationStatus) {
        
        if (NotificareGeoAuthorizationStatusAuthorizedAlways != status) {
            
        }
    }
    
    func notificarePushLib(_ library: NotificarePushLib, didReceiveLocationServiceAccuracyAuthorization accuracy: NotificareGeoAccuracyAuthorization) {
        
        if (NotificareGeoAccuracyAuthorizationFull != accuracy) {
            
        }
        
        if (NotificarePushLib.shared().myDevice().locationServicesAuthStatus == "always" ||
            NotificarePushLib.shared().myDevice().locationServicesAccuracyAuth != "full") {
            
        }
    }
    
    func notificarePushLib(_ library: NotificarePushLib, didReceiveRemoteNotificationInBackground notification: NotificareNotification, withController controller: Any?) {
        let navController = window?.rootViewController as? UINavigationController
        NotificarePushLib.shared().present(notification, in: navController!, withController: controller as Any)
    }
    
    func notificarePushLib(_ library: NotificarePushLib, didReceiveRemoteNotificationInForeground notification: NotificareNotification, withController controller: Any?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didLoadInbox"), object: Any?.self)
    }
    
    func notificarePushLib(_ library: NotificarePushLib, didLoadInbox items: [NotificareDeviceInbox]) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didLoadInbox"), object: Any?.self)
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NotificarePushLib.shared().didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //Handle Error
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NotificarePushLib.shared().didReceiveRemoteNotification(userInfo, completionHandler: {(_ response: Any?, _ error: Error?) -> Void in
            if error == nil {
                completionHandler(.newData)
            } else {
                completionHandler(.noData)
            }
        })
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        NotificarePushLib.shared().handleAction(withIdentifier: identifier, forRemoteNotification: userInfo, withResponseInfo: responseInfo, completionHandler: {(_ response: Any?, _ error: Error?) -> Void in
            completionHandler()
        })
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        NotificarePushLib.shared().handleAction(withIdentifier: identifier, forRemoteNotification: userInfo, withResponseInfo: nil, completionHandler: {(_ response: Any?, _ error: Error?) -> Void in
            completionHandler()
        })
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func printMyString() {
        print("myString->\(String(describing: myString))")
    }
    
}

