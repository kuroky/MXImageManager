#
#  Be sure to run `pod spec lint MXImageManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "MXImageManager"
  spec.version      = "1.1.1"
  spec.summary      = "基于SDWebImage、YYWebImage的图片管理"

  spec.description  = <<-DESC
对SDWebImage、YYWebImage的封装，实现图片的下载，缓存
                   DESC

  spec.homepage     = "https://github.com/kuroky/MXImageManager"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "kuroky" => "kuro2007cumt@gmail.com" }
  
  spec.source       = { :git => "https://github.com/kuroky/MXImageManager.git", :tag => "#{spec.version}" }

  spec.source_files  = "MXImageManager/*{h,m}"
  
  spec.platform     = :ios, "10.0"
  
  spec.dependency "SDWebImage", "5.0.6"

end
