# Uncomment the next line to define a global platform for your project

platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!


workspace 'joosum'
project 'Projects/Joosum.xcodeproj'
project 'Projects/Domain.xcodeproj'
project 'Projects/Presentation.xcodeproj'
project 'Projects/DesignSystem.xcodeproj'
# Core
project 'Projects/Core/Networking/Networking.xcodeproj'

target 'Joosum' do
  project 'Projects/Joosum/Joosum.xcodeproj'
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

target 'DesignSystem' do
  project 'Projects/DesignSystem/DesignSystem.xcodeproj'
  pod 'FlexLayout', '~> 1.0'
  pod 'PinLayout', '~> 1.0'
end

target 'Networking' do
  project 'Projects/Core/Networking/Networking.xcodeproj'


end
