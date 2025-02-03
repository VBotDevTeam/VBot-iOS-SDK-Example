Pod::Spec.new do |s|
  s.name         = 'VBotPhoneSDK'
  s.version      = '1.4.0'
  s.authors      = "VBotDevTeam"
  s.summary      = "VBotPhoneSDK"
  s.description  = "VBot Phone SDK for iOS."
  s.homepage     = "https://vbot.vn"
  s.license      = 'LICENSE.txt'
  s.xcconfig = { "VBotPhoneSDK_SDK_VERSION" => s.version }
s.source       = { :path => "./" }
  s.documentation_url = "https://vbot.vn"
  s.platform = :ios
  s.ios.deployment_target = '12.0'
  s.static_framework = true
  s.swift_versions = [4.0, 4.2, 5.0, 5.3, 5.4, 6.0]
	
    s.frameworks = [
	"Foundation",
      	"UIKit",
     	"AVFoundation",
      	"CallKit",
      	"PushKit"
    ]

    s.vendored_frameworks = [
      	"VBot/VBotPJSIP.xcframework",
      	"VBot/VBotPhoneSDK.xcframework",
	"VBot/CocoaLumberjack.xcframework",
	"VBot/Reachability.xcframework",
	"VBot/Starscream.xcframework",
    ]
  s.resources =   ['VBot/resources/*.png']
   
end
