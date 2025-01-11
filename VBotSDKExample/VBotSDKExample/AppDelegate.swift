//
//  AppDelegate.swift
//  VBotSDKExample
//
//  Created by DAT NGUYEN QUOC on 13/12/2024.
//

import UIKit
import VBotPhoneSDK
import PushKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var voipRegistry: PKPushRegistry!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Cấu hình cho SDK
        let config = VBotConfig(
            supportPopupCall: true, // Bật popup call trong cuộc gọi
            iconTemplateImageData: UIImage(named: "callkit-icon")?.pngData()) // Icon cho màn hình CallKit
        // Khởi tạo SDK
        VBotPhone.sharedInstance.setup(with: config)
        
        // Khởi tạo PKPushRegistry
        voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        voipRegistry!.desiredPushTypes = [.voIP]
        voipRegistry!.delegate = self
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {
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




