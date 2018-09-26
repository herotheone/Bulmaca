# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Bulmaca Sözlük' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Bulmaca Sözlük
    pod 'SearchTextField'
    pod 'Firebase'
    pod 'Firebase/Auth'
    pod 'Firebase/Database'
    pod 'SVProgressHUD'
    pod 'Google-Mobile-Ads-SDK'
    pod 'GRDB.swift', '~> 3.1'

    post_install do |installer|
    installer.pods_project.targets.each do |target|
    if target.name == 'GRDB.swift'
    target.build_configurations.each do |config|
    config.build_settings['SWIFT_VERSION'] = '4.0'
    end
    end
    end
    end


end
