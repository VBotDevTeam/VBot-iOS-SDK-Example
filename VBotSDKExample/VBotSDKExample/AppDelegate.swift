//
//  AppDelegate.swift
//  VBotPhoneSDK
//
//  Created by 37604706 on 01/04/2024.
//  Copyright (c) 2024 37604706. All rights reserved.
//

import UIKit

import VBotPhoneSDK
import PushKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var voipRegistry: PKPushRegistry!

    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var notificationCenter: UNUserNotificationCenter {
        return UNUserNotificationCenter.current()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
       
        // Cấu hình cho SDK
        let config = VBotConfig(
            supportPopupCall: true, // Bật popup call trong cuộc gọi
            iconTemplateImageData: UIImage(named: "callkit-icon")?.pngData()) // Icon cho màn hình CallKit
        // Khởi tạo SDK
        VBotPhone.sharedInstance.setup(with: config)
        
        // Khởi tạo PKPushRegistry
        voipRegistry = PKPushRegistry(queue: .main)
        voipRegistry!.desiredPushTypes = [.voIP]
        voipRegistry!.delegate = self

        setupObservers()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {
        removeObservers()
    }
}

// Lắng nghe các sự kiện cùa Pushkit
extension AppDelegate: PKPushRegistryDelegate {
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        VBotPhone.sharedInstance.pushRegistry(registry, didUpdate: pushCredentials, for: type)
    }

    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        VBotPhone.sharedInstance.pushRegistry(registry, didReceiveIncomingPushWith: payload, for: type, completion: completion)
    }

    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        VBotPhone.sharedInstance.pushRegistry(registry, didInvalidatePushTokenFor: type)
    }
}

extension AppDelegate: VBotPhoneDelegate {
    func receivedApnsToken(token: String?) {}

    func callInfoUpdated(user: CallUser) {}

    func callInfoUpdated() {}

    func messageButtonTapped() {}

    func callStarted() {}

    func callAccepted() {}

    func callEnded() {}

    func callMuteStateDidChange(muted: Bool) {}

    func callHoldStateDidChange(isOnHold: Bool) {}

    func callStateChanged(call: VBotCall) {}

    @objc func showCallVC(_ notification: Notification? = nil) {}

    @objc func hideCallVC(_ notification: Notification? = nil) {
    }
}

private extension AppDelegate {
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showCallVC), name: Notification.Name.VBotCallStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showCallVC), name: Notification.Name.VBotCallAccepted, object: nil)
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.VBotCallAccepted, object: nil)
    }
}
