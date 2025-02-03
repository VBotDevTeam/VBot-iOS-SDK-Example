# VBot-iOS-SDK-Example

## Code demo

[https://github.com/VBotDevTeam/VBot-iOS-SDK-Example](https://github.com/VBotDevTeam/VBot-iOS-SDK-Example)

---

## Yêu cầu

iOS 12.0 trở lên

---

## Cài đặt SDK

### Cocoapod
Copy thư mục **Lib** từ project VBot-iOS-SDK-Example vào project của bạn
Thêm VBotPhoneSDK vào Podfile

```jsx
platform :ios, '13.5'

target 'Runner' do
  use_frameworks! :linkage => :static

  pod 'VBotPhoneSDK', :path => './Lib/VBotPhoneSDK'

  target 'RunnerTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
```

---

## Cấu hình dự án

### Bật Voip trong dự án Xcode

Chọn **Xcode Project → Capabilities**

Thêm **Background Modes** và **Push Notifications**

Ở **Background Modes,** Bật **Audio, AirPlay, and Picture in Picture |** **Voice over IP | Background Fetch | Remote Notifications**

Mở tệp **info.plist** và thêm key sau

```jsx
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is necessary to be able to make calls.</string>
```

Lưu ý:

Khi khởi chạy dự án mà Xcode trả về lỗi

“Sandbox: rsync.samba (13105) deny(1) file-write-create”

Thực hiện chỉnh sửa sau

Trong **Build Settings**

- **User Script Sandboxing**: Chọn **No**

---

## Sử dụng SDK

---

### import VBot SDK và cấu hình Pushkit

Trong **AppDelegate.swift**

```jsx

import VBotPhoneSDK
import PushKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

		private var voipRegistry: PKPushRegistry?

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
```

---

### Đa ngôn ngữ

VBot SDK mặc định chỉ hỗ trợ Tiếng Việt

Khi app thay đổi ngôn ngữ, hãy dùng hàm **setLocalizationStrings(strings)** để thay đổi ngôn ngữ cho VBot SDK

```swift
let strings = VBotLocalizedStrings(call_btn_mute: "Tắt tiếng")
VBotPhone.sharedInstance.setLocalizationStrings(strings)
```

### Kết nối

---

Hàm này chỉ cần gọi duy nhất một lần khi người dùng đăng nhập vào app của bạn

Sau khi connect thành công thì dữ liệu sẽ được lưu vào SDK

Sau khi người dùng tắt app và mở lại thì **client.setup()** là đủ để SDK hoạt động

```jsx
VBotPhone.sharedInstance.connect(token: token) { displayName, error in
	guard let displayName = displayName else {
		// login error
		return
	}
	// login successful
}
```

Trong đó:

- token: Token SDK của tài khoản VBot
- displayName: Tên của tài khoản
- error: Lỗi trả về khi đăng nhập không thành công
  ***

### Ngắt kết nối

Hàm này sẽ cần gọi thì người dùng đăng xuất khỏi ứng dụng và xóa tất cả dữ liệu SDK

> Sau khi người dùng tắt app và mở lại thì cần gọi **client.connect** với tokenKey

> Khi token hết hạn thì hàm nảy sẽ trả về lỗi, dùng hàm **client.delete** để xóa dữ liệu client trước khi connect lại với token mới

```jsx
VBotPhone.sharedInstance.disconnect { error in
	if error != nil {
		// logout error
		return
	}
	// logout successful
}
```

---

### Xóa tài khoản

Xóa tất cả dữ liệu SDK

Hàm này sẽ sử dụng trong trường hợp token hết hạn hoặc cần thay đổi tài khoản

```swift
client.delete() {

}
```

---

### Lấy danh sách hotline

```jsx
VBotPhone.sharedInstance.getHotlines { hotlines, error in
	if error != nil {
		// get hotline error
		return
	}
	// get hotline successful
}
```

---

### Gọi đi

```jsx
VBotPhone.sharedInstance.startOutgoingCall(
        callerId: String,
        callerAvatar: String? = nil,
        callerName: String,
        calleeId: String,
        calleeAvatar: String? = nil,
        calleeName: String,
        checkSum: String? = nil,)
```

---

### Thao tác trong cuộc gọi

```kotlin
func returnToCallVC()

func getActiveCall() -> VBotCall?

func endCall(completion: @escaping (Error?) -> Void)

func muteCall(completion: @escaping (Error?) -> Void)

func hasAudioBluetooth() -> Bool

func isSpeakerOn() -> Bool

func onOffSpeaker()

func holdCall(completion: @escaping (Error?) -> Void)

func isCallHold() -> Bool

func isCallMute() -> Bool

func sendDTMF(digit: String, completion: @escaping (Error?) -> Void)
```

---

### Lắng nghe các sự kiện

Có 2 cách để ắng nghe các sự kiện trong VBot SDK

1. **Sử dụng Protocol delegate**

```swift
protocol VBotPhoneDelegate {

    // Trả về ApnsToken
    // Có thể dùng hàm này để cập nhật ApnsToken mới lên máy chủ
    func receivedApnsToken(token: String?)

    // Trạng thái cuộc gọi thay đổi
    func callStateChanged(call: VBotCall)

    // Cuộc gọi đi đã bắt đầu
    func callStarted()

    // Cuộc gọi đến được chấp nhận (Khi user chọn chấp nhận cuộc gọi)
    func callAccepted()

    // Cuộc gọi kết thúc
    func callEnded()

    // Trạng thái Microphone thay đổi
    func callMuteStateDidChange(muted: Bool)

    // Trạng thái Hold thay đổi
    func callHoldStateDidChange(isOnHold: Bool)

    // Nhấn vào nút nhắn tin
    func messageButtonTapped()

    // Thông tin cuộc gọi cập nhật
    func callInfoUpdated()

}
```

Ở bất cứ class nào cũng có thể đăng ký nhận sự kiện VBot bằng cách như sau:

```swift
  // Đăng ký nhận sự kiện cuộc gọi
  VBotPhone.sharedInstance.addDelegate(self)

  // Hủy đăng ký
   deinit {
       VBotPhone.sharedInstance.removeDelegate(self)
   }
```

1. **Sử dụng Notification**

```swift
// Trả về ApnsToken, có thể dùng hàm này để cập nhật ApnsToken mới lên máy chủ
Notification.Name.receivedApnsToken

// Thay đổi trạng thái cuộc gọi
Notification.Name.VBotCallStateChanged

// Cuộc gọi đi đã bắt đầu
Notification.Name.VBotCallStarted

// Cuộc gọi đến được chấp nhận (Khi user chọn chấp nhận cuộc gọi)
Notification.Name.VBotCallAccepted

// Cuộc gọi kết thúc
Notification.Name.VBotCallEnded

// Trạng thái Microphone thay đổi
Notification.Name.VBotCallMuteStateDidChange

// Cập nhật thông tin người gọi
Notification.Name.VBotCallInfoUpdated
```

---
