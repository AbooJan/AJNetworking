
Pod::Spec.new do |s|

  s.name         = "AJNetworking"
  s.version      = "3.0.0"
  s.summary      = "AJNetworking是对AFNetworking 3.x 版本的封装，内部集成缓存和JSON转化."

  s.description  = <<-DESC
                    AJNetworking是对网络层的封装，将网络请求、JSON数据转化和数据缓存合三为一，上层可以更专注于业务的处理。
                   DESC

  s.homepage     = "https://github.com/AbooJan/AJNetworking"

  s.license          = "MIT"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "AbooJan" => "aboojaner@gmail.com" }

  s.platform     = :ios
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"

  s.source       = { :git => "https://github.com/AbooJan/AJNetworking.git", :tag => "#{s.version}" }
  s.source_files  = "AJNetworking/Classes/*.{h,m}","AJNetworking/Classes/Model/*.{h,m}","AJNetworking/Classes/Utils/*.{h,m}"

  s.frameworks   = "UIKit","Foundation","Security"
  s.requires_arc = true

  s.dependency "AFNetworking"
  s.dependency "MJExtension"
  s.dependency "SPTPersistentCache"

end
