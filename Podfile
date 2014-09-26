source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '7.1'

inhibit_all_warnings!

workspace 'WhirlyGlobeSwift'
xcodeproj 'WhirlyGlobe/WhirlyGlobe'

pod 'WhirlyGlobe', '2.3'

target 'WhirlyGlobeComponentTester', :exclusive => true do
  xcodeproj 'WhirlyGlobeComponentTester/WhirlyGlobeComponentTester'

  pod 'WhirlyGlobeResources'
end
