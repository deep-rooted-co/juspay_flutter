#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint juspay_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'juspay_flutter'
  s.version          = '0.0.1'
  s.summary          = 'A flutter plugin for juspay payment SDK.'
  s.description      = <<-DESC
A flutter plugin for juspay payment SDK.
                       DESC
  s.homepage         = 'https://deep-rooted.co'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Deep Rooted.Co' => 'talktous@deep-rooted.co' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'HyperSDK', '2.0.90'
  s.dependency 'SimplFingerPrint', '1.0.7'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
