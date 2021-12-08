#
# Be sure to run `pod lib lint TPPhoto-Swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TPPhoto-Swift'
  s.version          = '1.0.0'
  s.summary          = 'Picture picker and Image browser.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Topredator/TPPhoto-Swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Topredator' => 'luyanggold@163.com' }
  s.source           = { :git => 'https://github.com/Topredator/TPPhoto-Swift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
#  s.source_files = 'TPPhoto-Swift/Classes/**/*'
  
  # 图片资源
  s.resource_bundles = {
      'TPPhotoSwift'  => ['TPPhoto-Swift/Assets/*xcassets']
  }
  
  s.subspec 'Base' do |ss|
      ss.source_files = 'TPPhoto-Swift/Classes/Base/**/*'
  end
  
  s.subspec 'Picker' do |ss|
      ss.source_files = 'TPPhoto-Swift/Classes/Picker/**/*'
      ss.dependency 'TPPhoto-Swift/Base'
      ss.dependency 'SnapKit'
      ss.dependency 'SVProgressHUD'
      ss.frameworks = 'Photos'
  end
  
  s.subspec 'Previewer' do |ss|
      ss.source_files = 'TPPhoto-Swift/Classes/Previewer/**/*'
      ss.dependency 'TPUIKit-Swift'
      ss.dependency 'SnapKit'
      ss.dependency 'TPPhoto-Swift/Base'
      ss.dependency 'SDWebImage'
  end
  # s.resource_bundles = {
  #   'TPPhoto-Swift' => ['TPPhoto-Swift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
