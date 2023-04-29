# Uncomment the next line to define a global platform for your project

platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!


workspace 'joosum'
project 'joosum/App.xcodeproj'
project 'joosum/Domain.xcodeproj'
project 'joosum/Presentation.xcodeproj'
project 'joosum/Core.xcodeproj'

target 'App' do
  project 'joosum/App/App.xcodeproj'
  pod 'FlexLayout', '~> 1.0'
  pod 'PinLayout', '~> 1.0'
  pod 'PINRemoteImage/PINCache', '~> 3.0'
  pod 'PINRemoteImage/iOS', '~> 3.0'
end

target 'Domain' do
  project 'joosum/Domain/Domain.xcodeproj'

end

target 'Presentation' do
  project 'joosum/Presentation/Presentation.xcodeproj'
  pod 'FlexLayout', '~> 1.0'
  pod 'PinLayout', '~> 1.0'
  pod 'PINRemoteImage/PINCache', '~> 3.0'
  pod 'PINRemoteImage/iOS', '~> 3.0'

end

target 'Core' do
  project 'joosum/Core/Core.xcodeproj'

end
