
platform :ios, '13.0'

target 'Bandit - IOS Academy' do
 
  use_frameworks!

pod 'Firebase/Core'
pod 'Firebase/Storage'
pod 'Firebase/Database'
pod 'Firebase/Auth'
pod 'Firebase/Analytics'
pod 'Firebase/Crashlytics'

pod 'Appirater'
pod 'SDWebImage'

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
  end
 end
end

end
