# Uncomment the next line to define a global platform for your project

platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!


workspace 'Projects'
project 'Projects/App.xcodeproj'
project 'Projects/Domain.xcodeproj'
project 'Projects/Presentation.xcodeproj'
project 'Projects/Core.xcodeproj'

target 'App' do
  project 'Projects/App/App.xcodeproj'
  pod 'FlexLayout', '~> 1.0'
  pod 'PinLayout', '~> 1.0'
end

target 'Domain' do
  project 'Projects/Domain/Domain.xcodeproj'

end

target 'Presentation' do
  project 'Projects/Presentation/Presentation.xcodeproj'
  pod 'FlexLayout', '~> 1.0'
  pod 'PinLayout', '~> 1.0'
end

target 'Core' do
  project 'Projects/Core/Core.xcodeproj'


end
