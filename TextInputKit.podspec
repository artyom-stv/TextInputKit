#
#  Be sure to run `pod spec lint TextInputKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "TextInputKit"
  spec.version      = "0.0.1"
  spec.summary      = "A Swift framework for formatting text input on iOS, macOS and tvOS."

  spec.description  = <<-DESC
Here will be a description
                   DESC

  spec.homepage     = "https://github.com/artyom-stv/TextInputKit"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Artem Starosvetskiy" => "artyom.stv@gmail.com" }
  # spec.social_media_url   = "https://twitter.com/Artem Starosvetskiy"
  spec.source       = { :git => "https://github.com/artyom-stv/TextInputKit.git", :tag => "#{spec.version}" }

  spec.ios.deployment_target = "8.0"
  spec.osx.deployment_target = "10.10"

  spec.source_files  = 'TextInputKit/TextInputKit/Code/**/*.swift'

  spec.dependency "PhoneNumberKit"

end
