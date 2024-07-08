platform :ios, '13.0'

target 'LeaveCasa' do
  use_frameworks!
  
  pod 'Alamofire'
  pod 'ObjectMapper'
  pod 'DropDown'
  pod "SearchTextField"
  pod 'SDWebImage'
  pod 'NVActivityIndicatorView'
  pod 'TTGSnackbar'
  pod 'SKCountryPicker'
  pod 'IBAnimatable'
  pod 'AdvancedPageControl'
  pod 'OTPFieldView'
  pod 'RangeSeekSlider'
  pod 'razorpay-pod'
  pod 'SideMenu'
  pod 'IQKeyboardManagerSwift'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'
  pod 'FSCalendar'
  pod 'Popover'
  
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
