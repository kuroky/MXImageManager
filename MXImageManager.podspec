#
#  Be sure to run `pod spec lint MXImageManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "MXImageManager"
  spec.version      = "1.0.0"
  spec.summary      = "基于SDWebImage、YYWebImage的图片管理"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = <<-DESC
对SDWebImage、YYWebImage的封装，实现图片的下载，缓存
                   DESC

  spec.homepage     = "https://github.com/kuroky/MXImageManager"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "kuroky" => "kuro2007cumt@gmail.com" }
  
  spec.source       = { :git => "https://github.com/kuroky/MXImageManager.git", :tag => "#{spec.version}" }

  spec.source_files  = "MXImageManager/*{h,m}"
  
  # 在这个属性中声明过的.h文件能够使用<>方法联想调用（这个是可选属性）
  spec.public_header_files = "MXImageManager/*.{h}"
  
  spec.platform     = :ios, "10.0"
  
  spec.ios.deployment_target = "10.0"
    
  spec.dependency "SDWebImage", "4.4.5"
  spec.dependency "YYWebImage", "1.0.5"

end
