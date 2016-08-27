#
#  Be sure to run `pod spec lint AJNetworking.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name            = "AJNetworking"
  s.version         = "3.0.0"
  s.summary      = "AJNetworking是对AFNetworking 3.0 版本的封装，集合了JSON序列化、数据缓存功能"

  s.description  = <<-DESC
                        AJNetworking是对AFNetworking 3.0 版本的封装，结合MJExtension框架把JSON序列化问题透明了, 使用SPTPersistentCache处理请求数据的缓存
                         DESC

  s.homepage     = "https://github.com/AbooJan/AJNetworking"
  s.license          = "MIT"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "AbooJan" => "aboojaner@gmail.com" }
  s.platform        = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  s.source          = { :git => "https://github.com/AbooJan/AJNetworking.git", :tag => "3.0.0" }
  s.source_files  = "AJNetworking/Classes/*","AJNetworking/Classes/Model/*","AJNetworking/Classes/Utils/*"
  s.requires_arc  = true

  s.frameworks   = "UIKit","Foundation","Security"
  s.dependency "AFNetworking"
  s.dependency "MJExtension"
  s.dependency "SPTPersistentCache"

end
