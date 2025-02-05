//
//  AppDelegate.swift
//  VBotPhoneSDK
//
//  Created by 37604706 on 01/04/2024.
//  Copyright (c) 2024 37604706. All rights reserved.
//

import UIKit

import PushKit
import VBotPhoneSDK

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
            iconTemplateImageData: UIImage(named: "callkit-icon")?.pngData() // Icon cho màn hình CallKit
        )
        // Khởi tạo SDK
        let token = <App Token>
        VBotPhone.sharedInstance.setup(token: token, with: config)

        // Khởi tạo PKPushRegistry
        voipRegistry = PKPushRegistry(queue: .main)
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
        guard let token = registry.pushToken(for: .voIP) else {
            VBotLogger.error(filter: "🍭 AppDelegate", "Không thể lấy token push")
            return
        }

        let pushToken = token.map { String(format: "%.2hhx", $0) }.joined()
        savePushToken(pushToken)
        VBotLogger.debug(filter: "🍭 AppDelegate", "Nhận được token: \(token) \(pushToken)")
    }

    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        
        if type == .voIP {
            let dictionaryPayload = payload.dictionaryPayload as? [String: Any] ?? [:]

            VBotLogger.info(filter: "🍭 AppDelegate", "payload: \(dictionaryPayload)")

            let metaData = dictionaryPayload["metaData"] as? [String: Any] ?? [:]
            let checkSum = metaData["check_sum"] as? String ?? ""

            let callerId = dictionaryPayload["callerId"] as? String ?? ""
            let callerAvatar = dictionaryPayload["callerAvatar"] as? String ?? ""
            let callerName = dictionaryPayload["callerName"] as? String ?? ""

            let calleeId = dictionaryPayload["calleeId"] as? String ?? ""
            let calleeAvatar = dictionaryPayload["calleeAvatar"] as? String ?? ""
            let calleeName = dictionaryPayload["calleeName"] as? String ?? ""


            VBotLogger.debug(filter: "🍭 AppDelegate", "Payload processed successfully | checkSum: \(checkSum)")

            guard !callerId.isEmpty, !calleeId.isEmpty else {
                VBotLogger.error(filter: "🍭 AppDelegate", "Invalid payload: missing callerId or calleeId")
                completion() // Đảm bảo gọi completion ngay cả khi payload không hợp lệ
                return
            }

            VBotPhone.sharedInstance.startIncomingCall(
                callerId: callerId,
                callerName: callerName,
                callerAvatar: callerAvatar,
                calleeId: calleeId,
                calleeName: calleeName,
                calleeAvatar: calleeAvatar,
                checkSum: checkSum,
                metaData: metaData,
                completion: completion
            )
        } else {
            completion()
        }
       
    }

    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        VBotLogger.error(filter: "🍭 AppDelegate", "didInvalidatePushTokenFor \(type)")
    }
}

