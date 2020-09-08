#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'fluttertoast'
  s.version          = '0.0.2'
  s.summary          = 'Toast Library for Flutter'
  s.description      = <<-DESC
Toast Library for FLutter
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Karthik Ponnam' => 'ponnamkarthik3@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Toast'
  s.ios.deployment_target = '8.0'
end

