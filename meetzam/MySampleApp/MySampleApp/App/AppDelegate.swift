    //
//  AppDelegate.swift
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.10
//

import UIKit
import UserNotifications
    
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // ====================================
        // UINavigationBar customization
        let navigationBarAppearace = UINavigationBar.appearance()
        
        // change nav bar color
        navigationBarAppearace.tintColor = UIColor.init(red: 252/255, green: 252/255, blue: 252/255, alpha: 1)
        
        // Gulf orange
        navigationBarAppearace.barTintColor = UIColor.init(red: 242/255, green: 92/255, blue: 0/255, alpha: 1)
        
        // change bar to translucent
        navigationBarAppearace.isTranslucent = true
        
        // change title color
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.init(red: 252/255, green: 252/255, blue: 252/255, alpha: 1), NSFontAttributeName: UIFont.init(name: "HelveticaNeue", size: 19) as Any]
        
        // inApp notification
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            
        }
        
        // ====================================
        
        return AWSMobileClient.sharedInstance.didFinishLaunching(application, withOptions: launchOptions)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // print("application application: \(application.description), openURL: \(url.absoluteURL), sourceApplication: \(sourceApplication)")
        return AWSMobileClient.sharedInstance.withApplication(application, withURL: url, withSourceApplication: sourceApplication, withAnnotation: annotation)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AWSMobileClient.sharedInstance.applicationDidBecomeActive(application)
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            let realC = ChatViewController()
            DispatchQueue.main.async {
                realC.incomingData()
            }
            
            let mainVC = UIApplication.shared.keyWindow?.rootViewController
            if mainVC is MainViewController {
                (mainVC as! MainViewController).viewControllers?[3].tabBarItem.badgeValue = " "
            }
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        AWSMobileClient.sharedInstance.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        NotificationCenter.default.post(name: Notification.Name(rawValue: AWSMobileClient.remoteNotificationKey), object: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        AWSMobileClient.sharedInstance.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        AWSMobileClient.sharedInstance.application(application, didReceiveRemoteNotification: userInfo , fetchCompletionHandler: completionHandler)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let realC = ChatViewController()
        realC.incomingData()
        
        let mainVC = UIApplication.shared.keyWindow?.rootViewController
        if mainVC is MainViewController {
            (mainVC as! MainViewController).viewControllers?[3].tabBarItem.badgeValue = " "
        }
//        completionHandler(UNNotificationPresentationOptions.badge)
        
//        if let mainVC = UIApplication.shared.keyWindow?.rootViewController {
//            if mainVC is MainViewController {
//                if let selectedVC = (mainVC as! MainViewController).selectedViewController {
//                    if selectedVC is UINavigationController {
//                        let finalVC = selectedVC as? UINavigationController
//                        if finalVC?.visibleViewController is ChatViewController {
//                            (finalVC?.visibleViewController as! ChatViewController).viewWillAppear(true)
//                        }
//                    }
//                }
//            }
//        }
        
        
//        if let mainVC = UIApplication.shared.keyWindow?.rootViewController {
//            if mainVC is MainViewController {
//                if let selectedVC = (mainVC as! MainViewController).selectedViewController {
//                    if selectedVC is UINavigationController {
//                        let finalVC = selectedVC as? UINavigationController
//                        if finalVC?.visibleViewController is ChatLogController {
////                            (finalVC?.visibleViewController as? ChatLogController)?.notificationMsg(new_Contact: , text: text)
//                        }
//                        else if finalVC?.visibleViewController is ChatViewController {
//                            (finalVC?.visibleViewController as! ChatViewController).viewWillAppear(true)
//                        }
//                    }
//                }
//            }
//        }
    }
    
    // =======================================================================
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ChatViewModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
}

