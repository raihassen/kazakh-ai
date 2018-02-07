source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'Kazakh-AI' do
    pod 'Alamofire', '~> 4.4'
pod ‘Popover’
pod 'DZNEmptyDataSet'
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.1'
    end
  end
end

end
