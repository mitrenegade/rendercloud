#
# Be sure to run `pod lib lint RenderCloud.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RenderCloud'
  s.version          = '2.0.1'
  s.summary          = 'Abstractions for cloud API calls and a direct Database interface, with Firebase implementation'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  This pod provides an interface for:
       Cloud API calls
       Database and queries
  This pod also includes a vanilla Firebase implementation
                       DESC

  s.homepage         = 'https://bitbucket.org/renderapps/rendercloud'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bobby Ren' => 'bobby@renderapps.io' }
  s.source           = { :git => 'git@bitbucket.org:renderapps/rendercloud.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.static_framework = true
  s.source_files = 'RenderCloud/Classes/**/*'
  
  # s.resource_bundles = {
  #   'RenderCloud' => ['RenderCloud/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.dependency 'Firebase'
  s.dependency 'Firebase/Core'
  s.dependency 'Firebase/Auth'
  s.dependency 'Firebase/Database'
  s.dependency 'Firebase/Storage'
  s.dependency 'Firebase/RemoteConfig'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'RxOptional'
end
