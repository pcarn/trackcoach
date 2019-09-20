# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

use_frameworks!

target 'TrackCoach' do
  pod 'JVFloatingDrawer', git: 'https://github.com/pcarn/JVFloatingDrawer'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
        end
    end
end
