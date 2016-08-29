#
# Be sure to run `pod lib lint SCButton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SCButton'
  s.version          = '0.1.0'
  s.summary          = 'button style'
  s.description      = <<-DESC
                        a useful tool button sytle
                       DESC

  s.homepage         = 'https://github.com/<GITHUB_USERNAME>/SCButton'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '刘成清' => 'liuchengqing@iyunxiao.com' }
  s.source           = { :git => 'https://github.com/<GITHUB_USERNAME>/SCButton.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'SCButton/Classes/**/*'
  s.public_header_files = 'SCButton/Classes/**/*.h'
  
  # s.resource_bundles = {
  #   'SCButton' => ['SCButton/Assets/*.png']
  # }

  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
