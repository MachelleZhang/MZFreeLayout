Pod::Spec.new do |s|
  s.name             = 'MZFreeLayout'
  s.version          = '1.0.0'
  s.summary          = 'A short description of MZFreeLayout.'

  s.description      = <<-DESC
类似Excel样式的自由布局
                       DESC

  s.homepage         = 'https://github.com/MachelleZhang/MZFreeLayout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MachelleZhang' => '407916482@qq.com' }
  s.source           = { :git => 'https://github.com/MachelleZhang/MZFreeLayout.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = "#{s.name.to_s}/*.{h, m}"
  s.frameworks = 'UIKit', 'MapKit'
  
end
