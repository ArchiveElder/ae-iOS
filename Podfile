# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'aeVeganDiary' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for aeVeganDiary
  pod 'SnapKit', '~> 5.0.0'
  pod 'FSCalendar'
  pod 'Charts'

end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end