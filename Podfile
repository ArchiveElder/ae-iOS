# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'aeVeganDiary' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for aeVeganDiary
  pod 'SnapKit', '~> 5.0.0'
  pod 'FSCalendar'
  pod 'Charts'
  pod 'Alamofire', '~> 5.2'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'RxCocoa'
  pod 'RxSwift'
  pod 'KakaoSDKCommon'  # 필수 요소를 담은 공통 모듈
  pod 'KakaoSDKAuth'  # 사용자 인증
  pod 'KakaoSDKUser'  # 카카오 로그인, 사용자 관리
  pod 'NMapsMap'
  pod 'GoogleMaps', '6.1.0'
  pod 'Google-Maps-iOS-Utils', '3.4.0'

end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
end
