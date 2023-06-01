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
project 'Projects/Core/LoginManager/LoginManager.xcodeproj'

def flex_layout
  pod 'FlexLayout', :git => 'git@github.com:pink-boss/FlexLayout.git'
end

target 'Joosum' do
  project 'Projects/Joosum/Joosum.xcodeproj'
  flex_layout
  pod 'PinLayout', '~> 1.0'
  pod 'GoogleSignIn'
end

target 'Domain' do
  project 'Projects/Domain/Domain.xcodeproj'
end

target 'Presentation' do
  project 'Projects/Presentation/Presentation.xcodeproj'
  flex_layout
  pod 'PinLayout', '~> 1.0'
  pod 'GoogleSignIn'
end

target 'PresentationTests' do
  project 'Projects/Presentation/Presentation.xcodeproj'
  pod 'GoogleSignIn'
end

target 'DesignSystem' do
  project 'Projects/DesignSystem/DesignSystem.xcodeproj'
  flex_layout
  pod 'PinLayout', '~> 1.0'
end

# Core

target 'Networking' do
  project 'Projects/Core/Networking/Networking.xcodeproj'
end
