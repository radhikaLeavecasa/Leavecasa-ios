platform :ios, '13.0'

target 'LeaveCasa' do
  use_frameworks!
  
  # Pods for LeaveCasa
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
  pod 'FLAnimatedImage'
  pod 'RangeSeekSlider'
  pod 'razorpay-pod'#, '~> 1.4.0'
  pod 'ImageViewer.swift', '~> 3.0'
  pod 'AMPopTip'
  pod 'SideMenu'
  pod 'PDFGenerator', '~> 3.1'
  pod 'IQKeyboardManagerSwift'
  pod 'lottie-ios'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'
  pod 'ReactiveKit'
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
