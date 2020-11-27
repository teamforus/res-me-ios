//
//  AppDelegate.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/6/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var commonService: CommonServiceProtocol! = CommonService()
    var appnotifier = AppVersionUpdateNotifier()
    var timer = Timer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        KVSpinnerView.settings.backgroundRectColor = .white
        KVSpinnerView.settings.backgroundOpacity = 5.0
        KVSpinnerView.settings.tintColor = #colorLiteral(red: 0.1918309331, green: 0.3696506619, blue: 0.9919955134, alpha: 1)
        application.applicationIconBadgeNumber = 0
        
        #if ALPHA
//        CheckWebSiteReacheble.checkWebsite(url: "https://staging.test.api.forus.io") { (isReacheble) in
//            if isReacheble {
//                UserDefaults.standard.setValue("https://staging.test.api.forus.io/api/v1/", forKey: UserDefaultsName.ALPHAURL)
//            }else {
//                UserDefaults.standard.setValue("https://staging.api.forus.io/api/v1/", forKey: UserDefaultsName.ALPHAURL)
//            }
//        }
         UserDefaults.standard.setValue("https://staging.api.forus.io/api/v1/", forKey: UserDefaultsName.ALPHAURL)
        #endif
        NotificationCenter.default.addObserver(self, selector: #selector(closeAppNotifierView), name: NotificationName.CloseAppNotifier, object: nil)
        
        #if DEBUG
        #else
        Fabric.with([Crashlytics.self])
        
        #endif
        
        window?.makeKeyAndVisible()
        
        
        if existCurrentUser() {
            
            CurrentSession.shared.token = getCurrentUser().accessToken ?? ""
            self.addShortcuts(application: application)
            if UserDefaults.standard.bool(forKey: UserDefaultsName.AddressIndentityCrash) {
                
//                commonService.get(request: "identity", complete: { (response: Office, statusCode) in
//                    Crashlytics.sharedInstance().setUserIdentifier(response.address)
//                }) { (error) in
//
//                }
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
            
            if UserDefaults.standard.bool(forKey: UserDefaultsName.StartFromScanner){
                
                initialViewController.selectedIndex = 1
                
            }
            
            self.window?.rootViewController = initialViewController
            
        }else {
            
            let storyboard = UIStoryboard(name: "First", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "first") as! HiddenNavBarNavigationController
            self.window?.rootViewController = initialViewController
            
        }
        didCheckPasscode(vc: self.window!.rootViewController!)
        initPush(application)
        
        appnotifier.initNotifier(self)
        
        return true
    }
    
    func getCurrentUser() -> User{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "currentUser == YES")
        do {
            let results = try context.fetch(fetchRequest) as? [User]
            if results?.count != 0 {
                return results![0]
            }
        } catch {}
     return User()
    }
    
    func existCurrentUser() -> Bool{
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           let context = appDelegate.persistentContainer.viewContext
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
           fetchRequest.predicate = NSPredicate(format:"currentUser == YES")
           do{
               let results = try context.fetch(fetchRequest) as? [User]
               if results?.count != 0 {
                  
                   return true
               }
           } catch{}
           return false
       }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        timer.invalidate()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        setupTimer()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        setupTimer()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Preference.userHasCloseUpdateNotifier = false
        self.saveContext()
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.absoluteString.contains("meapp://identity-confirmation"){
            
            NotificationCenter.default.post(name: NotificationName.AuthorizeRegistrationTokenEmail, object: self, userInfo: ["authToken" : url.absoluteString.replacingOccurrences(of: "meapp://identity-confirmation?token=", with: "")])
            
        }else if url.absoluteString.contains("meapp://identity-restore"){
            
            NotificationCenter.default.post(name: NotificationName.AuthorizeTokenEmail, object: self, userInfo: ["authToken" : url.absoluteString.replacingOccurrences(of: "meapp://identity-restore?token=", with: "")])
            
        }
        return true
    }
    
    // MARK: - Core Data stack
    
     lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "MeApp")
           container.viewContext.automaticallyMergesChangesFromParent = true
           let description = container.persistentStoreDescriptions
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()
    
    
    // MARK: - ShortCut Items
    
    func addShortcuts(application: UIApplication) {
        let voucherItem = UIMutableApplicationShortcutItem(type: "Vouchers", localizedTitle: Localize.vouchers(), localizedSubtitle: "", icon: UIApplicationShortcutIcon(templateImageName: "wallet"), userInfo: nil)
        
        let qrItem = UIMutableApplicationShortcutItem(type: "QR", localizedTitle: "QR", localizedSubtitle: "", icon: UIApplicationShortcutIcon(templateImageName: "iconGrey"), userInfo: nil)
        
        let recordItem = UIMutableApplicationShortcutItem(type: "Records", localizedTitle: Localize.records(), localizedSubtitle: "", icon: UIApplicationShortcutIcon(templateImageName: "records"), userInfo: nil)
        
        application.shortcutItems = [voucherItem, qrItem, recordItem]
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        let handleShortCutItem = handleShortcutItem(shortCutItem: shortcutItem)
        
        completionHandler(handleShortCutItem)
    }
    
    func handleShortcutItem(shortCutItem: UIApplicationShortcutItem) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
        var handle = false
        
        guard let shortCutType = shortCutItem.type as String? else { return false }
        
        switch shortCutType {
        case "Vouchers":
            initialViewController.selectedIndex = 0
            handle = true
            break
        case "QR" :
            initialViewController.selectedIndex = 1
            handle = true
            break
        case "Records":
            initialViewController.selectedIndex = 2
            handle = true
            break
        default:
            break
        }
         self.window?.rootViewController = initialViewController
        return handle
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // TODO: Notification
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.hexString
        print("APNs token retrieved: \(deviceTokenString)")
        let dataDict:[String: String] = ["token": deviceTokenString]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        UserDefaults.standard.setValue(deviceTokenString, forKey: "TOKENPUSH")
        UserDefaults.standard.synchronize()
    }
    
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}

extension AppDelegate {
    
    func initPush(_ application: UIApplication){
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    func didCheckPasscode(vc: UIViewController){
        if UserDefaults.standard.string(forKey: ALConstants.kPincode) != "" && UserDefaults.standard.string(forKey: ALConstants.kPincode) != nil {
            var appearance = ALAppearance()
            appearance.image = UIImage(named: "lock")!
            appearance.title = Localize.enter_login_code()
            appearance.isSensorsEnabled = true
            appearance.cancelIsVissible = false
            appearance.delegate = self
            
            AppLocker.present(with: .validate, and: appearance, withController: vc)
        }
    }
}

extension AppDelegate: AppLockerDelegate{
    
    func closePinCodeView(typeClose: typeClose) {
        if typeClose == .logout{
            
        }
    }
    
}

extension AppDelegate {
    
    func setupTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkForUpdate), userInfo: nil, repeats: true)
    }
    
    @objc func checkForUpdate() {
        if !Preference.userHasCloseUpdateNotifier{
            appnotifier.isUpdateAvailable()
        }
    }
}

extension AppDelegate: AppUpdateNotifier {
    func hasNewVersion(shouldBeUpdated: Bool) {
        if shouldBeUpdated && !appnotifier.viewIsShoun {
            if let vc = window?.rootViewController as? HiddenNavBarNavigationController {
                vc.topViewController?.view.addSubview(appnotifier.showUpdateView())
                appnotifier.vc = vc.topViewController
                appnotifier.setupView()
            }else if let vc = window?.rootViewController as? MMainTabBarController {
                if let navVC = vc.selectedViewController as? HiddenNavBarNavigationController {
                    navVC.topViewController?.view.addSubview(appnotifier.showUpdateView())
                    appnotifier.vc = navVC.topViewController
                    appnotifier.setupView()
                }else {
                    vc.selectedViewController?.view.addSubview(appnotifier.showUpdateView())
                    appnotifier.vc = vc.selectedViewController
                    appnotifier.setupView()
                }
            }
        }
    }
    
   @objc func closeAppNotifierView() {
        appnotifier.closeBodyView()
    }
}
