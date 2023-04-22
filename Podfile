# Uncomment the next line to define a global platform for your project

platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!


workspace 'Projects'
project 'Projects/App.xcodeproj'
project 'Projects/Domain.xcodeproj'
project 'Projects/Presentation.xcodeproj'
project 'Projects/Data.xcodeproj'

target 'App' do
  project 'Projects/App/App.xcodeproj'
  pod 'FlexLayout', '~> 1.0', binary: true
  pod 'PinLayout', '~> 1.0', binary: true
  pod 'PINRemoteImage/PINCache', '~> 3.0', binary: true
  pod 'PINRemoteImage/iOS', '~> 3.0', binary: true
end

target 'Domain' do
  project 'Projects/Domain/Domain.xcodeproj'

end

target 'Presentation' do
  project 'Projects/Presentation/Presentation.xcodeproj'
  pod 'FlexLayout', '~> 1.0', binary: true
  pod 'PinLayout', '~> 1.0', binary: true
  pod 'PINRemoteImage/PINCache', '~> 3.0', binary: true
  pod 'PINRemoteImage/iOS', '~> 3.0', binary: true

end

target 'Data' do
  project 'Projects/Data/Data.xcodeproj'


end
