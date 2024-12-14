#
# Be sure to run `pod lib lint VBotPhoneSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VBotPhoneSDK'
  s.version          = '0.1.0'
  s.summary          = 'A short description of VBotPhoneSDK.'


  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/VBotDevTeam/VBot-iOS-SDK-Example'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '37604706' => 'datnq@vpmedia.vn' }
  s.source = { :path => '.' }

  s.ios.deployment_target = '13.5'
  s.vendored_frameworks = 'VBotPhoneSDK.framework'

  s.source_files = 'VBotPhoneSDK/Classes/**/*'
  
  s.dependency 'CocoaLumberjack', '3.8.2'
  s.dependency 'SDWebImage', '5.0.0'
  s.xcconfig = { 'OTHER_SWIFT_FLAGS' => '-no-verify-emitted-module-interface',
      'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited)',
      'GCC_PREPROCESSOR_DEFINITIONS' => 'PJ_AUTOCONF=1',
      'GCC_PREPROCESSOR_DEFINITIONS'=> 'SV_APP_EXTENSIONS',
      'IPHONEOS_DEPLOYMENT_TARGET' => '13.5'}
  
end
