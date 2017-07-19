
Pod::Spec.new do |s|
  s.name             = 'VZKit'
  s.version          = '1.1.0'
  s.summary          = 'VZKit is a kit for develop iOS app.'


  s.description      = <<-DESC
VZKit is a kit for develop iOS app,VZKit is a kit for develop iOS app.
                       DESC

  s.homepage         = 'https://github.com/VonZen/VZKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'davonzhou@live.com' => 'VonZen' }
  s.source           = { :git => 'https://github.com/VonZen/VZKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'VZKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'VZKit' => ['VZKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'AFNetworking', '~> 3.1.0'
   s.dependency 'MJExtension', '~> 3.0.13'
end
